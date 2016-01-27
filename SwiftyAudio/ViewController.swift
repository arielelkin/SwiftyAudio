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

        // Setup AVAudioSession
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayAndRecord)

            let ioBufferDuration = 128.0 / 44100.0

            try AVAudioSession.sharedInstance().setPreferredIOBufferDuration(ioBufferDuration)

        } catch {
            assertionFailure("AVAudioSession setup error: \(error)")
        }


        // Setup engine and node instances
        assert(engine.inputNode != nil)
        let input = engine.inputNode!
        let output = engine.outputNode
        let format = input.inputFormatForBus(0)


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


        // Start engine
        do {
            try engine.start()
        } catch {
            assertionFailure("AVAudioEngine start error: \(error)")
        }
    }
}

