//
//  RecordView.swift
//  Words
//
//  Created by jake on 2024/3/18.
//

import SwiftUI
import AVFoundation

struct RecordView : View {
    
    var btnWidth = 40.0
    
    var title = "record to generate content"
    
    var audioRecorder = AudioRecorder()
    
    var audioPlayer = AudioPlayer()
    
    var audioRecognizer = SpeechRecognitionManager()
    
    @State private var isRecording = false
    
    @State private var voicePlayHidden = true
    
    @State private var voiceRecordFinish = false
    
    @State private var recogniContent = String()
    
    @State var currentUrl:URL?
    
    var compleHandler:(String, String) -> Void
    
    init(title:String, contentHandler:@escaping (String,String)->()) {
        if title.count > 0 {
            self.title = title
        }
        self.compleHandler = contentHandler
    }
    
    var body: some View {
        GeometryReader { proxy in
            VStack (alignment:.leading) {
                HStack {
                    VStack {
                        // record
                        Button(action: {
                            voicePlayHidden.toggle()
                            if isRecording {
                                audioRecorder.stopRecording()
                                audioRecognizer.stopSpeechRecognition()
                                
                                voiceRecordFinish = true
                                
                                self.compleHandler(self.recogniContent, self.currentUrl!.absoluteString)
                            } else {
                                audioRecorder.checkAudioPermissionWithGrantedHandler { granted in
                                    if (granted) {
                                        self.currentUrl = audioRecorder.startRecording()
                                        audioRecognizer.startSpeechRecognition { transContent in
                                            if transContent.count > 0 {
                                                self.recogniContent = transContent
                                            }
                                        }
                                    } else {
                                        // TODO:jake alert to turn on the permission
                                    }
                                }
                                
                            }
                            isRecording.toggle()
                        }) {
                            if isRecording {
                                Image("jj_rcs").resizable()
                                    .aspectRatio(contentMode: .fit)
                            } else {
                                Image("jj_rc").resizable()
                                    .aspectRatio(contentMode: .fit)
                            }
                            
                        }.frame(width: self.btnWidth,height: self.btnWidth, alignment: .leading)
                        
                        if voicePlayHidden == false {
                            VoiceView().frame(width: self.btnWidth, height: 15)
                        } else {
                            Spacer().frame(height:15)
                        }
                    }
                    
                    VStack(alignment:.leading) {
                        // contentLabel
                        TextField(self.title, text: $recogniContent, axis: .vertical)
                            .textFieldStyle(.roundedBorder).frame(width: abs(proxy.size.width - self.btnWidth * 2 - 30.0), alignment: .leading).disabled(isRecording ? true:false)
                    }
                    
                    // play
                    if voiceRecordFinish {
                        Button(action: {
                            // play
                            if self.currentUrl != nil && self.currentUrl!.isFileURL {
                                self.audioPlayer.playWithFileURL(self.currentUrl!)
                            }
                        }) {
                            Image("playbtn").resizable()
                                .aspectRatio(contentMode: .fit)
                        }.frame(width: self.btnWidth,height: self.btnWidth).padding([.leading], 5).disabled(isRecording ?  true:false)
                    }
                }
            }
        }
    }
}
