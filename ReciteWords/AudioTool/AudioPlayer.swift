//
//  AudioPlayer.swift
//  Words
//
//  Created by jake on 2024/3/16.
//

import AVFoundation

protocol AudioPlayerDelegate: AnyObject {
    func audioPlayerDidFinishPlaying(_ player: AudioPlayer)
}

class AudioPlayer: NSObject {
    
    weak var delegate: AudioPlayerDelegate?
    
    private var audioPlayer: AVAudioPlayer?
    private var isPaused: Bool = false
    
    let synthesizer = AVSpeechSynthesizer()
    
    var lastID:UUID?
    
    var playCompleteHandler:()->Void = {}
    
    override init() {
        super.init()
    }
    
    func speak(text: String, id:UUID) {
        
        lastID = id
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US") // Set language as needed
        synthesizer.speak(utterance)
    }
    
    func playWithFileURL(_ fileURL: URL) {
        if setupAudioPlayer(with: fileURL) {
            play()
        }
    }
    
    func playWithFileURL(fileURL:URL, id:UUID) {
        if (lastID == id) {
            return
        }
        lastID = id
        if setupAudioPlayer(with: fileURL) {
            play()
        }
    }
    
    func playWithFileURL(fileURL:URL, id:UUID, completeHandler:@escaping ()-> Void) {
        if (lastID == id) {
            return
        }
        lastID = id
        if setupAudioPlayer(with: fileURL) {
            play()
        }
        self.playCompleteHandler = completeHandler
    }
    
    func audioPlayerDidFinishPlaying() {
        print("222")
    }
    
    func play() {
        if isPaused {
            audioPlayer?.play()
            isPaused = false
        } else {
            audioPlayer?.currentTime = 0
            audioPlayer?.play()
        }
    }
    
    func pause() {
        if let player = audioPlayer, player.isPlaying {
            player.pause()
            isPaused = true
        }
    }
    
    func stop() {
        if let player = audioPlayer {
            player.stop()
            player.currentTime = 0
            isPaused = false
        }
    }
    
    private func setupAudioPlayer(with fileURL: URL) -> Bool {
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: fileURL)
            audioPlayer?.volume = 3
            audioPlayer?.delegate = self
            return true
        } catch {
            print("Error initializing audio player: \(error.localizedDescription) url:\(fileURL)")
        }
        return false
    }
}

extension AudioPlayer: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        delegate?.audioPlayerDidFinishPlaying(self)
        self.playCompleteHandler()
    }
}
