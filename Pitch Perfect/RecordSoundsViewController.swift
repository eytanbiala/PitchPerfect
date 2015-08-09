//
//  RecordSoundsViewController.swift
//  Pitch Perfect
//
//  Created by Eytan Biala on 8/4/15.
//  Copyright (c) 2015 Udacity. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {

    @IBOutlet weak var recordingLabel: UILabel!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var pauseResumeButton: UIButton!

    var audioRecorder:AVAudioRecorder?
    var recordedAudio: RecordedAudio!

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated);

        pauseResumeButton.hidden = true;
        stopButton.hidden = true;
        recordingLabel.text = "Tap to Record"
    }

    @IBAction func recordAudio(sender: UIButton) {
        recordingLabel.text = "Recording"
        stopButton.hidden = false;
        recordButton.enabled = false;
        pauseResumeButton.setImage(UIImage(named: "pause_blue"), forState: UIControlState.Normal)
        pauseResumeButton.hidden = false;

        let dirPath: AnyObject = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0]

        let recordingName = "my_audio.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        print(filePath)

        AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayAndRecord, error: nil)

        audioRecorder = AVAudioRecorder(URL: filePath, settings: nil, error: nil)
        audioRecorder!.delegate = self;
        audioRecorder!.meteringEnabled = true
        audioRecorder!.prepareToRecord();
        audioRecorder!.record()
    }

    @IBAction func pauseResumeRecording(sender: AnyObject) {
        if (audioRecorder?.recording ?? false) {
            audioRecorder?.pause();
            recordingLabel.text = "Recording paused"
            pauseResumeButton.setImage(UIImage(named: "resume_blue"), forState: UIControlState.Normal)
        } else {
            audioRecorder?.record();
            recordingLabel.text = "Recording"
            pauseResumeButton.setImage(UIImage(named: "pause_blue"), forState: UIControlState.Normal)
        }

        print("Image \(pauseResumeButton.imageView?.image)");
    }

    @IBAction func stopRecording(sender: AnyObject) {
        stopButton.hidden = true;
        recordButton.enabled = true;
        pauseResumeButton.hidden = true;

        audioRecorder?.stop();
        AVAudioSession.sharedInstance().setActive(false, error: nil)
    }


    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
            recordedAudio = RecordedAudio(filePathUrl: recorder.url, title: recorder.url.lastPathComponent!)
            self.performSegueWithIdentifier("stopRecording", sender: recordedAudio)
        } else {
            print("Recording failed")
            recordButton.enabled = true
            stopButton.hidden = true
            recordingLabel.text = "Tap to Record"
        }
        
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "stopRecording" {
            let playSoundsVC:PlaySoundsViewController = segue.destinationViewController as! PlaySoundsViewController
            let data = sender as! RecordedAudio

            playSoundsVC.receivedAudio = data;
        }
    }
    
}

