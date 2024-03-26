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

    
    override init() {
        super.init()
    }
    
    init?(fileName: String) {
        super.init()
        guard let url = Bundle.main.url(forResource: fileName, withExtension: "mp3") else {
            return nil
        }
        
        setupAudioPlayer(with: url)
    }
    
    
    func speak(text: String, id:UUID) {
        if (lastID == id) {
            return
        }
        lastID = id
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US") // Set language as needed
        synthesizer.speak(utterance)
    }
    
    func playWithFileURL(_ fileURL: URL) {
        setupAudioPlayer(with: fileURL)
        play()
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
    
    private func setupAudioPlayer(with fileURL: URL) {
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: fileURL)
            audioPlayer?.delegate = self
        } catch {
            print("Error initializing audio player: \(error.localizedDescription)")
        }
    }
}

extension AudioPlayer: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        delegate?.audioPlayerDidFinishPlaying(self)
    }
}
