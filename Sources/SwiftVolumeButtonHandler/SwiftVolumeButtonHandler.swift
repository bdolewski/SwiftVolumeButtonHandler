//
//  SwiftVolumeButtonHandler.swift
//  SwiftVolumeButtonHandler
//
//  Created by Bartosz Dolewski on 03/04/2019.
//  Copyright © 2019 Bartosz Dolewski. All rights reserved.
//


import MediaPlayer

class SwiftVolumeButtonHandler: NSObject {
    typealias VolumeButtonHandlerBlock = (() -> Void)
    
    public var upBlock: VolumeButtonHandlerBlock?
    public var downBlock: VolumeButtonHandlerBlock?
    
    public var audioLevel: Float = 0.0
    
    //    private var audioSession: AVAudioSession?
    private var volumeView: MPVolumeView?
    
    //private var sessionCategory: AVAudioSession.Category!
    //private var sessionOptions: AVAudioSession.CategoryOptions!
    
    private var initialVolume = CGFloat(0.0)
    
    private var isAppActive = false
    private var isStarted = false
    private var disableSystemVolumeHandler = false
    private var isAdjustingInitialVolume = false
    private var exactJumpsOnly = false
    
    private var observerForeground: NSObjectProtocol?
    private var observerBackground: NSObjectProtocol?
    
    private struct Config {
        static let sessionVolumeKeyPath = "outputVolume"
        
        static let category = AVAudioSession.Category.playback
        static let categoryOptions = AVAudioSession.CategoryOptions.mixWithOthers
        
        static let maxVolume = CGFloat(0.99999)
        static let minVolume = CGFloat(0.00001)
    }
    
    override init() {
        super.init()
        
        //sessionCategory = .playback
        //sessionOptions = .mixWithOthers
        
        volumeView = MPVolumeView(frame: .zero)
        if let volumeView = volumeView {
            UIApplication.shared.windows.first?.addSubview(volumeView)
        }
        
        volumeView?.isHidden = true
        exactJumpsOnly = false
        
        observerForeground = NotificationCenter.default.addObserver(forName: UIApplication.willEnterForegroundNotification, object: nil, queue: .main) { [weak self] notification in
            self?.setupHandlingHardwareButtons()
        }
        
        observerBackground = NotificationCenter.default.addObserver(forName: UIApplication.didEnterBackgroundNotification, object: nil, queue: .main) { [weak self] notification in
            let audioSession = AVAudioSession.sharedInstance()
            audioSession.removeObserver(self!, forKeyPath: Config.sessionVolumeKeyPath)
        }
    }
    
    deinit {
        DispatchQueue.main.async {
            self.volumeView?.removeFromSuperview()
        }
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        guard keyPath == Config.sessionVolumeKeyPath else { return }
        guard let oldVolume = change?[.oldKey] as? Float,
            let newVolume = change?[.newKey] as? Float else { return }
        
        let audioSession = AVAudioSession.sharedInstance()
        
        if newVolume > oldVolume {
            upBlock?()
            print("Volume UP --> [old = \(audioLevel) new = \(audioSession.outputVolume)]")
        }
        
        if newVolume < oldVolume {
            downBlock?()
            print("Volume DOWN --> [old = \(audioLevel) new = \(audioSession.outputVolume)]")
        }
        
        audioLevel = audioSession.outputVolume
    }
    
    func setupHandlingHardwareButtons() {
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(Config.category, options: Config.categoryOptions)
            try audioSession.setActive(true, options: [])
            
            // this is the actual "listening" part
            audioSession.addObserver(self, forKeyPath: Config.sessionVolumeKeyPath, options: [.old, .new], context: nil)
            
            audioLevel = audioSession.outputVolume
            print("Start capturing...")
        } catch {
            print("Error")
        }
    }
}

