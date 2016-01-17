# AudioPlayer

[![Cocoapods Compatible](https://img.shields.io/cocoapods/v/AudioPlayerSwift.svg)](https://img.shields.io/cocoapods/v/AudioPlayerSwift.svg)
[![Platform](https://img.shields.io/cocoapods/p/AudioPlayerSwift.svg?style=flat)](http://cocoadocs.org/docsets/AudioPlayerSwift)
[![License](https://img.shields.io/cocoapods/l/AudioPlayerSwift.svg?style=flat)](http://cocoapods.org/pods/AudioPlayerSwift)

AudioPlayer is a simple class for playing audio in iOS, OS X and tvOS apps.

## Usage

```
// Initialize
let audioPlayer = AudioPlayer("sound.mp3")

// Start playing
audioPlayer.play()

// Stop playing with a fade out
audioPlayer.fadeOut()
```

See the samples project to see advanced usage

## Installation

### Cocoapods Installation

AudioPlayer is available on CocoaPods. Just add the following to your Podfile:

```
pod 'AudioPlayerSwift'
```

### Swift Package Manager

AudioPlayer is available on SPM. Just add the following to your Package file:

```
import PackageDescription

let package = Package(
    dependencies: [
        .Package(url: "https://github.com/tbaranes/AudioPlayerSwift.git", majorVersion: 1)
    ]
)
```

### Manual Installation

Just drag the `Source/*.swift` files into your project.


## AudioPlayer properties

```
name
```

The name of the sound. This is either the name that was passed to the `init`, or the last path component of the audio file.

```
URL
```

The absolute URL of the audio file.

```
completionHandler
```

A callback closure that will be called when the audio finishes playing, or is stopped.

```
playing
```

Is it playing or not?

```
duration
```

The duration of the sound.

```
currentTime
```

The current time offset into the sound of the current playback position.

```
volume
```

The volume for the sound. The nominal range is from 0.0 to 1.0.

```
numberOfLoops
```

Number of times that the sound will return to the beginning upon reaching the end.

- A value of zero means to play the sound just once.
- A value of one will result in playing the sound twice, and so on..
- Any negative number will loop indefinitely until stopped.
  
  
```
pan
```

The left/right stereo pan of the file. -1.0 is left, 0.0 is center, 1.0 is right.
 
## AudioPlayer methods

```
init(fileName: String) throws
init(contentsOfPath path: String) throws
```

These methods create a new AudioPlayer instance from a file name or file path.

```
func play()
```

Plays the sound. Has no effect if the sound is already playing.

```
func stop()
```

Stops the sound. Has no effect if the sound is not already playing. 

```
func fadeTo(volume: Float, duration: NSTimeInterval = 1.0)
```

This method fades a sound from it's current volume to the specified volume over the specified time period. 

```
func fadeIn(duration: NSTimeInterval = 1.0)
```

Fades the sound volume from 0.0 to 1.0 over the specified duration. 

```
func fadeOut(duration: NSTimeInterval = 1.0)
```

Fades the sound from it's current volume to 0.0 over the specified duration. 


## Notifications

```
SoundDidFinishPlayingNotification
```

This notification is fired (via NSNotificationCenter) whenever a sound finishes playing, either due to it ending naturally, or because the stop method was called. The notification object is an instance of the AudioPlayer class. You can access the AudioPlayer class's `name` property to find out which sound has finished.

## What's next

- AudioPlayerManager
- Your features!

## Contribution

- If you found a **bug**, open an **issue**
- If you have a **feature request**, open an **issue**
- If you want to **contribute**, submit a **pull request**

##Contact

* [@tbaranes](https://github.com/tbaranes/) on github

 
