//
//  ViewController.swift
//  SwiftySmasher
//
//  Created by Ariel Elkin on 14/04/2015.
//  Copyright (c) 2015 Ariel. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {

    var engine = AVAudioEngine()
    var distortion = AVAudioUnitDistortion()
    var reverb = AVAudioUnitReverb()


    override func viewDidLoad() {
        super.viewDidLoad()

        var audioSessionSetupError: NSError?

        AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayAndRecord, error: &audioSessionSetupError)

        var ioBufferDuration = 128.0 / 44100.0

        AVAudioSession.sharedInstance().setPreferredIOBufferDuration(ioBufferDuration, error: &audioSessionSetupError)
        if audioSessionSetupError != nil {
            println("audioSession setup error: \(audioSessionSetupError)")
        }



        // Setup engine and node instances
        var input = engine.inputNode
        var output = engine.outputNode
        var format = input.inputFormatForBus(0)


        distortion.loadFactoryPreset(.DrumsBitBrush)
        distortion.preGain = 4.0
        engine.attachNode(distortion)

        reverb.loadFactoryPreset(.MediumChamber)
        reverb.wetDryMix = 80
        engine.attachNode(reverb)

        // Connect nodes
        engine.connect(input, to: distortion, format: format)

        engine.connect(distortion, to: reverb, format: format)

        engine.connect(reverb, to: output, format: format)
        
        
        var error:NSError?
        // Start engine
        engine.startAndReturnError(&error)
        
    }
    
    
}

