//
//  Sound.swift
//  AudioPlayer Sample
//
//  Created by Tom Baranes on 15/01/16.
//  Copyright © 2016 tbaranes. All rights reserved.
//

import Foundation
import AVFoundation

enum AudioPlayerError: ErrorType {
    case FileExtension
}

class AudioPlayer: NSObject {

    static let SoundDidFinishPlayingNotification = "SoundDidFinishPlayingNotification"
    typealias SoundCompletionHandler = (didFinish: Bool) -> Void
    
    /// Name of the used to initialize the object
    let name: String?

    /// URL of the used to initialize the object
    let URL: NSURL?
    
    /// A callback closure that will be called when the audio finishes playing, or is stopped.
    var completionHandler: SoundCompletionHandler?
    
    /// is it playing or not?
    var playing: Bool {
        get {
            if let nonNilsound = sound {
                return nonNilsound.playing
            }
            return false
        }
    }

    /// the duration of the sound.
    var duration: NSTimeInterval {
        get {
            if let nonNilsound = sound {
                return nonNilsound.duration
            }
            return 0.0
        }
    }
    
    /// currentTime is the offset into the sound of the current playback position.
    var currentTime: NSTimeInterval {
        get {
            if let nonNilsound = sound {
                return nonNilsound.currentTime
            }
            return 0.0
        }
        set {
           sound?.currentTime = newValue
        }
    }

    /// The volume for the sound. The nominal range is from 0.0 to 1.0.
    var volume: Float = 1.0 {
        didSet {
            volume = min(1.0, max(0.0, volume));
            targetVolume = volume
        }
    }
    
    /// "numberOfLoops" is the number of times that the sound will return to the beginning upon reaching the end.
    /// A value of zero means to play the sound just once.
    /// A value of one will result in playing the sound twice, and so on..
    /// Any negative number will loop indefinitely until stopped.
    var numberOfLoops: Int = 0 {
        didSet {
            sound?.numberOfLoops = numberOfLoops
        }
    }

    /// set panning. -1.0 is left, 0.0 is center, 1.0 is right.
    var pan: Float = 0.0 {
        didSet {
            sound?.pan = pan
        }
    }
    
    // MARK: Init

    convenience init(fileName: String) throws {
        let fixedFileName = fileName.stringByTrimmingCharactersInSet(.whitespaceAndNewlineCharacterSet())
        var soundFileComponents = fixedFileName.componentsSeparatedByString(".")
        if soundFileComponents.count == 1 {
            throw AudioPlayerError.FileExtension
        }
        let path = NSBundle.mainBundle().pathForResource(soundFileComponents[0], ofType: soundFileComponents[1])
        try self.init(contentsOfPath: path!)
    }

    init(contentsOfPath path: String) throws {
        let fileURL = NSURL(fileURLWithPath: path)
        URL = fileURL
        name = fileURL.lastPathComponent
        sound = try? AVAudioPlayer(contentsOfURL: fileURL)
        super.init()
        
        sound?.delegate = self
    }
    
    deinit {
        timer?.invalidate()
    }
    
    // MARK: Play / Stop
    
    func play() {
        if playing == false {
            sound?.play()
        }
    }
    
    func stop() {
        if playing {
            soundDidFinishPlayingSuccessfully(false)
        }
    }
    
    // MARK: Fade
    
    func fadeTo(volume: Float, duration: NSTimeInterval = 1.0) {
        startVolume = volume;
        fadeTime = duration;
        fadeStart = NSDate().timeIntervalSinceReferenceDate
        if timer == nil {
            self.timer = NSTimer.scheduledTimerWithTimeInterval(0.015, target: self, selector: "handleFadeTo", userInfo: nil, repeats: true)
        }
    }
    
    func fadeIn(duration: NSTimeInterval = 1.0) {
        fadeTo(1.0, duration: duration)
    }
    
    func fadeOut(duration: NSTimeInterval = 1.0) {
        fadeTo(0.0, duration: duration)
    }

    // MARK: Private
    
    private func handleFadeTo() {
        let now = NSDate().timeIntervalSinceReferenceDate
        let delta: Float = (Float(now - fadeStart) / Float(fadeTime) * (targetVolume - startVolume))
        sound?.volume = startVolume + delta
        if delta > 0.0 && sound?.volume >= targetVolume ||
            delta < 0.0 && sound?.volume <= targetVolume {
                sound?.volume = targetVolume
                timer?.invalidate()
                timer = nil
                if sound?.volume == 0 {
                    stop()
                }
        }
    }
    
    // MARK: Private properties
    
    private let sound: AVAudioPlayer?
    private var startVolume: Float = 1.0
    private var targetVolume: Float = 1.0 {
        didSet {
            sound?.volume = targetVolume
        }
    }
    
    private var fadeTime: NSTimeInterval = 0.0
    private var fadeStart: NSTimeInterval = 0.0
    private var timer: NSTimer?
    
}

extension AudioPlayer: AVAudioPlayerDelegate {
    
    func audioPlayerDidFinishPlaying(player: AVAudioPlayer, successfully flag: Bool) {
        soundDidFinishPlayingSuccessfully(flag)
    }
    
}

private extension AudioPlayer {
    
    private func soundDidFinishPlayingSuccessfully(didFinishSuccessfully: Bool) {
        sound?.stop()
        timer?.invalidate()
        timer = nil
        
        if let nonNilCompletionHandler = completionHandler {
            nonNilCompletionHandler(didFinish: didFinishSuccessfully)
        }
        
        NSNotificationCenter.defaultCenter().postNotificationName(AudioPlayer.SoundDidFinishPlayingNotification, object: self)
    }
    
}
