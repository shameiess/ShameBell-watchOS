//
//  InterfaceController.swift
//  ShameBell WatchKit Extension
//
//  Created by Kevin Nguyen on 2/12/18.
//  Copyright © 2018 Kevin Dang Nguyen. All rights reserved.
//

import WatchKit
import Foundation
import CoreMotion
import AVFoundation

class InterfaceController: WKInterfaceController {
    
    let motionManager = CMMotionManager()
    var audioPlayer: AVAudioPlayerNode!
    var audioEngine: AVAudioEngine!
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        
        if (motionManager.isAccelerometerAvailable) {
            let motionQueue = OperationQueue()
            motionManager.startAccelerometerUpdates(to: motionQueue, withHandler: { (accelerometerData, error) in
                guard error == nil else { return }
                if accelerometerData!.acceleration.z > 0.0 {
                    // User shook
                    print("Shook")
                    self.playShameAudio()
                }
            })
        }
    }
    
    @IBAction func shameButton() {
        playShameAudio()
    }
    
    func playShameAudio() {
		// https://stackoverflow.com/a/40635988
        if (audioPlayer == nil) {
            audioPlayer = AVAudioPlayerNode()
            audioEngine = AVAudioEngine()
            audioEngine.attach(audioPlayer)
            let stereoFormat = AVAudioFormat(standardFormatWithSampleRate: 44100, channels: 2)
            audioEngine.connect(audioPlayer, to: audioEngine.mainMixerNode, format: stereoFormat)
            do {
                if !audioEngine.isRunning {
                    try audioEngine.start()
                }
            } catch {}
        }
        
        if let path = Bundle.main.path(forResource: "gameofthrones_shame", ofType: "mp3") {
            let fileUrl = URL(fileURLWithPath: path)
            do {
                let asset = try AVAudioFile(forReading: fileUrl)
                audioPlayer.scheduleFile(asset, at: nil, completionHandler: nil)
                audioPlayer.play()
            } catch {
                print ("asset error")
            }
        }
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
}
