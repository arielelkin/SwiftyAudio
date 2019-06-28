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

        view.backgroundColor = .white

        // Setup AVAudioSession
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playAndRecord)

            let ioBufferDuration = 128.0 / 44100.0

            try AVAudioSession.sharedInstance().setPreferredIOBufferDuration(ioBufferDuration)

        } catch {
            assertionFailure("AVAudioSession setup error: \(error)")
        }

        // Setup engine and node instances
        let input = engine.inputNode
        let output = engine.outputNode
        let format = input.inputFormat(forBus: 0)

        distortion.loadFactoryPreset(.drumsBitBrush)
        distortion.preGain = 4.0
        engine.attach(distortion)

        reverb.loadFactoryPreset(.mediumChamber)
        reverb.wetDryMix = 80
        engine.attach(reverb)

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
