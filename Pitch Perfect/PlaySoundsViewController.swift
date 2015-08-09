//
//  PlaySoundsViewController.swift
//  Pitch Perfect
//
//  Created by Eytan Biala on 8/9/15.
//  Copyright © 2015 Udacity. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController {

    var audioPlayer:AVAudioPlayer!
    var audioPlayer2:AVAudioPlayer!
    var receivedAudio:RecordedAudio!
    var audioEngine:AVAudioEngine!
    var audioFile:AVAudioFile!

    override func viewDidLoad() {
        super.viewDidLoad();

        audioPlayer = AVAudioPlayer(contentsOfURL: receivedAudio.filePathUrl, error: nil)
        audioPlayer.enableRate = true;

        audioPlayer2 = AVAudioPlayer(contentsOfURL: receivedAudio.filePathUrl, error: nil)

        audioEngine = AVAudioEngine()
        audioFile = AVAudioFile(forReading: receivedAudio.filePathUrl, error: nil)
    }

    @IBAction func slowPressed(sender: AnyObject) {
        playWithRate(0.5);
    }

    @IBAction func fastPressed(sender: AnyObject) {
        playWithRate(1.5);
    }

    @IBAction func stopPlaying(sender: AnyObject) {
        stopAudio()
    }

    @IBAction func playChipmunk(sender: AnyObject) {
        playAudioWithVariablePitch(1000)
    }

    @IBAction func playVader(sender: AnyObject) {
        playAudioWithVariablePitch(-1000)
    }

    func stopAudio() {
        audioPlayer.stop()
        audioPlayer2.stop()
    }

    @IBAction func playReverb(sender: AnyObject) {
        stopAudio()

        audioEngine.reset()

        var audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)

        var reverb = AVAudioUnitReverb()
        reverb.loadFactoryPreset(AVAudioUnitReverbPreset.SmallRoom)
        reverb.wetDryMix = 50
        audioEngine.attachNode(reverb)

        audioEngine.connect(audioPlayerNode, to: reverb, format: nil)
        audioEngine.connect(reverb, to: audioEngine.outputNode, format: nil)

        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        audioEngine.startAndReturnError(nil)

        audioPlayerNode.play()
    }

    @IBAction func playEcho(sender: AnyObject) {

        stopAudio()

        audioPlayer.currentTime = 0;
        audioPlayer.play()

        let delay:NSTimeInterval = 0.1
        var playtime:NSTimeInterval
        playtime = audioPlayer2.deviceCurrentTime + delay
        audioPlayer2.currentTime = 0
        audioPlayer2.volume = 0.8;
        audioPlayer2.playAtTime(playtime)
    }

    func playWithRate(rate: Float) {
        stopAudio()
        audioPlayer.currentTime = 0.0
        audioPlayer.rate = rate;
        audioPlayer.play();
    }

    func playAudioWithVariablePitch(pitch: Float){
        stopAudio()

        audioEngine.reset()

        var audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)

        var changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.pitch = pitch
        audioEngine.attachNode(changePitchEffect)

        audioEngine.connect(audioPlayerNode, to: changePitchEffect, format: nil)
        audioEngine.connect(changePitchEffect, to: audioEngine.outputNode, format: nil)

        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        audioEngine.startAndReturnError(nil)
        
        audioPlayerNode.play()
    }
}