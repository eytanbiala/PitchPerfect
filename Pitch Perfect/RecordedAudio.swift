//
//  RecordedAudio.swift
//  Pitch Perfect
//
//  Created by Eytan Biala on 8/9/15.
//  Copyright © 2015 Udacity. All rights reserved.
//

import Foundation

class RecordedAudio {
    var filePathUrl: NSURL!
    var title: String!

    init(filePathUrl: NSURL, title: String) {
        self.filePathUrl = filePathUrl
        self.title = title
    }
}