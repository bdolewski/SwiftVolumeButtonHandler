//
//  ViewController.swift
//  SwiftVolumeButtonHandler
//
//  Created by Bartosz Dolewski on 03/04/2019.
//  Copyright © 2019 Bartosz Dolewski. All rights reserved.
//

import UIKit
import AVKit

class ViewController: UIViewController {
    @IBOutlet var buttonLabel: UILabel!
    @IBOutlet var newAudioLabel: UILabel!
    
    private var audioLevel: Float = 0.0
    private var observerForeground: NSObjectProtocol?
    private var observerBackground: NSObjectProtocol?
    
    private let hwButtonHandler = SwiftVolumeButtonHandler()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        newAudioLabel.text = "Current audio level: \(hwButtonHandler.audioLevel)"
        
        hwButtonHandler.upBlock = { [weak self] in
            self?.buttonLabel.text = "Pressed button: UP ⬆︎"
            self?.newAudioLabel.text = "Audio level is: \(String(describing: self?.hwButtonHandler.audioLevel))"
            print("ViewController: detected button UP")
        }
        
        hwButtonHandler.downBlock = { [weak self] in
            self?.buttonLabel.text = "Pressed button: DOWN ⬇︎"
            self?.newAudioLabel.text = "Audio level is: \(String(describing: self?.hwButtonHandler.audioLevel))"
            print("ViewController: detected button DOWN" )
        }
    }
}

