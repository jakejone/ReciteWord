//
//  RecordView.swift
//  Words
//
//  Created by jake on 2024/3/18.
//
// It's a shit

import SwiftUI
import AVFoundation

struct AudioTextView : View {
    
    @StateObject var vm:AudioTextViewModel
    
    @State private var content = String()
    @State private var voiceAddr = String()
    
    private let placeHolder:String
    var completeHandler:(String, String) -> Void
    
    init(placeHolder:String, contentHandler:@escaping (String,String)->()) {
        _vm = StateObject(wrappedValue: AudioTextViewModel())
        self.placeHolder = placeHolder
        self.completeHandler = contentHandler
    }
    
    init(placeHolder:String, content:String?, voiceAddr:String?, contentHandler:@escaping (String,String)->()) {
        self.placeHolder = placeHolder
        if let inContent = content {
            // todo ,tow param if let
            _vm = StateObject(wrappedValue: AudioTextViewModel(inContent: inContent, inVoiceAddr: voiceAddr!))
        } else {
            _vm = StateObject(wrappedValue: AudioTextViewModel())
        }
        self.completeHandler = contentHandler
    }
    
    var body: some View {
        GeometryReader { proxy in
            VStack (alignment:.leading) {
                HStack {
                    VStack {
                        // record
                        Button(action: {
                            vm.clickRecord { content, voiceAddr in
                                self.content = content
                                self.voiceAddr = voiceAddr
                                self.completeHandler(content,voiceAddr)
                            }
                        }) {
                            Image("plus_l").resizable()
                                .aspectRatio(contentMode: .fill).frame(width: 40, height: 40)
                        }.buttonStyle(PlainButtonStyle())
                            .frame(width: UIConstant.btnWidth,height: UIConstant.btnWidth)
                        
                        recordAnimationView
                    }
                    
                    VStack {
                        // contentLabel
                        TextField(self.placeHolder, text: $vm.recordingContent, axis: .vertical)
                            .frame(width: abs(proxy.size.width - UIConstant.btnWidth * 2 - 30.0), alignment: .leading).disabled(vm.recordState == .recording ? true:false)
                    }
                    
                    if vm.recordState == .recorded {
                        Button(action: {
                            vm.clickPlay(urlString: self.voiceAddr)
                        }) {
                            AdaptiveImage(light: Image("play_l").resizable(),
                                          dark: Image("play_d").resizable()).frame(width:40,height: 40)
                        }
                        .buttonStyle(PlainButtonStyle())
                        .frame(width: UIConstant.btnWidth,height: UIConstant.btnWidth)
                        .padding([.trailing], 10)
                        .disabled(vm.recordState == .recording ?  true:false)
                    }
                }
            }.padding(10)
        }.background(RWColor.secondaryBgColor).cornerRadius(15.0)
    }
    
    @ViewBuilder
    private var recordBtnView : some View {
        switch vm.recordState {
        case .origin:
            Image("record_l").resizable().frame(width: 40, height: 40).buttonStyle(PlainButtonStyle()).background(Color.clear).border(Color.red)
            AdaptiveImage(light: Image("record_l").resizable(),
                          dark: Image("record_d").resizable()).frame(width:40,height: 40)
        case .recording:
            AdaptiveImage(light: Image("pause_l").resizable(),
                          dark: Image("pause_d").resizable()).frame(width:40,height: 40)
        case .recorded:
            AdaptiveImage(light: Image("record_l").resizable(),
                          dark: Image("record_d").resizable()).frame(width:40,height: 40)
        }
    }
    
    @ViewBuilder
    private var recordAnimationView : some View {
        switch vm.recordState {
        case .origin:
            EmptyView().frame(height:15)
        case .recorded:
            EmptyView().frame(height:15)
        case .recording:
            VoiceView().frame(width: UIConstant.btnWidth, height: 15)
        }
    }
}
