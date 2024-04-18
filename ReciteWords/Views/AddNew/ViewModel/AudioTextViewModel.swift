//
//  AudioTextViewModel.swift
//  ReciteWords
//
//  Created by jake on 2024/4/14.
//

import Foundation
import SwiftUI

class AudioTextViewModel: ObservableObject {
    
    enum RecordState {
        case origin
        case recording
        case recorded
    }

    @Published private(set) var recordState = RecordState.origin
    
    @Published var recordingContent = String()
    
    // prevent very quick double click
    private var isRecording = false
    
    private var recordingUrl:URL?
    
    private var audioRecorder = AudioRecorder()
    
    private var audioPlayer = AudioPlayer()
    
    private var audioRecognizer = SpeechRecognitionManager()
    
    init() {
        recordingContent = ""
    }
    
    init(inContent:String, inVoiceAddr:String) {
        recordingContent = inContent
        recordingUrl = URL(fileURLWithPath: inVoiceAddr)
        recordState = .recorded
    }
    
    func clickRecord(contentHandler:@escaping (String,String)->()) {
        switch recordState {
        case .origin:
            self.startRecord()
        case .recording:
            self.stopRecord(contentHandler: contentHandler)
        case .recorded:
            self.startRecord()
        }
    }
    
    func startRecord() {
        
        audioRecorder.checkAudioPermissionWithGrantedHandler { granted in
            if (granted) {
                if (self.isRecording) {
                    print("double click triggle")
                    return
                }
                self.isRecording = true
                
                self.recordingUrl = self.audioRecorder.startRecording()
                self.audioRecognizer.startSpeechRecognition { transContent in
                    if transContent.count > 0 {
                        self.recordingContent = transContent
                    }
                }
                
                DispatchQueue.main.async {
                    self.recordState = .recording
                }
            } else {
                print("no permission")
            }
        }
    }
    
    func stopRecord(contentHandler:@escaping (String,String)->()) {
        audioRecorder.stopRecording()
        audioRecognizer.stopSpeechRecognition()
        contentHandler(self.recordingContent, self.recordingUrl!.relativePath)
        self.recordState = .recorded
        self.isRecording = false
    }
    
    func clickPlay(urlString:String) {
        // play
        let url = URL(fileURLWithPath: urlString)
        self.audioPlayer.playWithFileURL(url)
    }
}
