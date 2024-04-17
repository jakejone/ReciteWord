//
//  AudioRecorder.swift
//  Words
//
//  Created by jake on 2024/3/9.
//

import Foundation
import AVKit

class AudioRecorder {
#if os(iOS) || os(watchOS) || os(tvOS)
    var audioRecorder: AVAudioRecorder!
#elseif os(macOS)
    var audioRecorder:AVAudioEngine!
    var outputFile: AVAudioFile?
#endif
    
    func checkAudioPermissionWithGrantedHandler(  completeHander:@escaping (_ granted:Bool)->Void) {
#if os(macOS)
        switch AVCaptureDevice.authorizationStatus(for: .audio) {
        case .authorized:
            print("authorized")
            completeHander(true)
        case .notDetermined:
            print("notDetermined")
            AVCaptureDevice.requestAccess(for: .audio) { granted in
                if granted {
                    completeHander(granted)
                } else {
                    completeHander(granted)
                }
            }
        case .denied, .restricted:
            print("denied")
            AVCaptureDevice.requestAccess(for: .audio) { granted in
                if granted {
                    completeHander(granted)
                } else {
                    completeHander(granted)
                }
            }
            completeHander(false)
        @unknown default:
            print("unknown")
            completeHander(false)
        }
#elseif os(iOS) || os(watchOS) || os(tvOS)
        if #available(iOS  17.0, *) {
            // use the feature only available in iOS 9
            // for ex. UIStackView
            switch AVAudioApplication.shared.recordPermission {
            case .granted:
                // Microphone access already granted
                completeHander(true)
            case .undetermined:
                // Requesting microphone access
                AVAudioApplication.requestRecordPermission { granted in
                    completeHander(granted)
                }
            case .denied:
                // Microphone access denied
                completeHander(false)
            @unknown default:
                fatalError("Unhandled AVAudioSession.RecordPermission case.")
            }
        } else {
            switch AVAudioSession.sharedInstance().recordPermission {
            case .granted:
                // Microphone access already granted
                completeHander(true)
            case .undetermined:
                // Requesting microphone access
                AVAudioApplication.requestRecordPermission { granted in
                    completeHander(granted)
                }
            case .denied:
                // Microphone access denied
                completeHander(false)
            @unknown default:
                fatalError("Unhandled AVAudioSession.RecordPermission case.")
            }
        }
#endif
    }
    
    func startRecording() -> URL? {
#if os(iOS) || os(watchOS) || os(tvOS)
        let audioSession = AVAudioSession.sharedInstance()
        
        do {
            try audioSession.setCategory(.playAndRecord, mode: .default)
            try audioSession.setActive(true)
            
            let settings: [String: Any] = [
                AVFormatIDKey: kAudioFormatMPEG4AAC,
                AVSampleRateKey: 44100.0,
                AVNumberOfChannelsKey: 2,
                AVEncoderAudioQualityKey: AVAudioQuality.low.rawValue
            ]
            let currentUrl = self.generateVoiceURL()
            audioRecorder = try AVAudioRecorder(url: currentUrl, settings: settings)
            audioRecorder.record()
            return currentUrl
        } catch {
            print("Error recording audio: \(error.localizedDescription)")
        }
        return nil
#elseif os(macOS)
        audioRecorder = AVAudioEngine()
        let input = audioRecorder.inputNode
        let bus = 0
        let inputFormat = input.inputFormat(forBus: bus)
        
        let outputURL = self.generateVoiceURL()
        print("audio file : \(outputURL)")
        outputFile = try! AVAudioFile(forWriting: outputURL, settings: inputFormat.settings, commonFormat: inputFormat.commonFormat, interleaved: inputFormat.isInterleaved)
        
        input.installTap(onBus: bus, bufferSize: 512, format: inputFormat) { (buffer, time) in
            try! self.outputFile?.write(from: buffer)
        }
        
        try! audioRecorder.start()
        return outputURL
#endif
    }
    
    func stopRecording() {
#if os(iOS) || os(watchOS) || os(tvOS)
        if self.audioRecorder.isRecording {
            self.audioRecorder.stop()
        }
#elseif os(macOS)
        self.audioRecorder.stop()
#endif
    }
    
    func getCurrentTimeStamp() -> Int {
        let someDate = Date()
        let timeInterval = someDate.timeIntervalSince1970
        return Int(timeInterval)
    }
    
    func generateVoiceURL() -> URL {
        let documents = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        let voiceDataDir = documents + "/wordData/voiceData/"
        if FileManager.default.fileExists(atPath: voiceDataDir) == false {
            do {
                try FileManager.default.createDirectory(at: URL(filePath: voiceDataDir), withIntermediateDirectories: false)
            } catch {
                print(error)
            }
        }
#if os(iOS) || os(watchOS) || os(tvOS)
        let fileExtension = ".m4a"
#elseif os(macOS)
        let fileExtension = ".caf"
#endif
        let voicdUrl = voiceDataDir + String(getCurrentTimeStamp()) + fileExtension
        return URL(filePath: voicdUrl)
    }
}
