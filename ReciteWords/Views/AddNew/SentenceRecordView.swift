//
//  SentenceCard.swift
//  Words
//
//  Created by jake on 2024/3/17.
//

import SwiftUI

struct SentenceRecordView : View {
    
    @EnvironmentObject var vm:AddNewViewModel
    
    @StateObject var wsvm:WordSentenceViewModel
    
    init(wordSentence:WordSentence) {
        _wsvm = StateObject(wrappedValue: WordSentenceViewModel(wordSentence: wordSentence))
    }
    
    var body: some View {
        GeometryReader {proxy in
            ZStack {
                VStack (alignment:.leading) {
                    AudioTextView(placeHolder: "word meaning", content: wsvm.wordSentence.wordDesc, voiceAddr: wsvm.wordSentence.wordDescVoiceAddr) { transContent, voiceAddr in
                        vm.meaningRecordFinished(wordSentence: wsvm.wordSentence, content: transContent, voiceAddr: voiceAddr)
                    }.frame(height: UIConstant.btnWidth * 2)
                    
                    ScrollViewReader { value in
                        ScrollView {
                            ForEach(0..<self.wsvm.sentenceCount,  id: \.self) { index in
                                let sentence = self.wsvm.wordSentence.sentencelist[index]
                                AudioTextView(placeHolder: "record new sentence",content: sentence.content, voiceAddr: sentence.voiceAddr) { transContent, voiceAddr in
                                    vm.sentenceRecordFinished(sentence: sentence, content: transContent, voiceAddr: voiceAddr)
                                }.frame(height: 80.0)
                            }
                            Spacer()
                        }
                    }
                }.cornerRadius(15.0)
                
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Button (action: {
                            wsvm.addSentenceBtnClick()
                        }){
                            HStack {
                                AdaptiveImage(light: Image("plus_l").resizable(),
                                              dark: Image("plus_d").resizable()).frame(width:40,height: 40)
                                Text("add sentence")
                            }
                        }.buttonStyle(PlainButtonStyle()).frame(width:100,height: UIConstant.btnWidth,alignment: .leading).padding(10)
                    }
                }
            }
        }
    }
}

