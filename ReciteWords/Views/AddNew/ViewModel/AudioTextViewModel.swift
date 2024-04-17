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
    
    enum PlayState {
        case hidden
        case show
    }

    @Published private(set) var recordState = RecordState.origin
    
    @Published private(set) var playState = PlayState.hidden
    
    @Published var recordingContent = String()
    
    private var recordingUrl:URL?
    
    private var audioRecorder = AudioRecorder()
    
    private var audioPlayer = AudioPlayer()
    
    private var audioRecognizer = SpeechRecognitionManager()
    
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
    }
    
    func clickPlay(urlString:String) {
        // play
        let url = URL(fileURLWithPath: urlString)
        self.audioPlayer.playWithFileURL(url)
    }
}
