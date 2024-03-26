//
//  AudioRecorder.swift
//  Words
//
//  Created by jake on 2024/3/9.
//

import Foundation
import AVKit

class AudioRecorder {
    
    var audioRecorder: AVAudioRecorder!
    
    func startRecording() -> URL? {
        let audioSession = AVAudioSession.sharedInstance()
        
        do {
            try audioSession.setCategory(.playAndRecord, mode: .default)
            try audioSession.setActive(true)
            
            let settings: [String: Any] = [
                         AVFormatIDKey: kAudioFormatMPEG4AAC,
                         AVSampleRateKey: 44100.0,
                         AVNumberOfChannelsKey: 2,
                         AVEncoderAudioQualityKey: AVAudioQuality.medium.rawValue
                     ]  
            let currentUrl = self.generateVoiceURL()
            audioRecorder = try AVAudioRecorder(url: currentUrl, settings: settings)
            audioRecorder.record()
            return currentUrl
        } catch {
            print("Error recording audio: \(error.localizedDescription)")
        }
        
        return nil
    }

    func stopRecording() {
        if audioRecorder.isRecording {
            audioRecorder.stop()
        }
    }
    
    func getCurrentTimeStamp() -> Int {
        let someDate = Date()
        // convert Date to TimeInterval (typealias for Double)
        let timeInterval = someDate.timeIntervalSince1970
        // convert to Integer
        return Int(timeInterval)
    }
    
    func generateVoiceURL() -> URL {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let voiceDataDir = documentsDirectory.appendingPathComponent("wordData/voiceData/")
        if FileManager.default.fileExists(atPath: voiceDataDir.path()) == false {
            do {
                try FileManager.default.createDirectory(at: voiceDataDir, withIntermediateDirectories: false)
            } catch {
                print(error)
            }
        }
        
        let voicdUrl = voiceDataDir.appendingPathComponent(String(getCurrentTimeStamp()) + ".m4a")
        return voicdUrl
    }
}
