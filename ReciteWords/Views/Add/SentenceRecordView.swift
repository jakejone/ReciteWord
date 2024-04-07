//
//  SentenceCard.swift
//  Words
//
//  Created by jake on 2024/3/17.
//

import SwiftUI

struct SentenceRecordView : View {
    
    var wordService:WordService = WordService()
    
    @ObservedObject var word:Word
    
    let wordSentence:WordSentence
    
    init(word:Word, cardIndex:Int) {
        self.word = word
        self.wordSentence  = word.wordSentenceList[cardIndex]
    }
    
    var body: some View {
        GeometryReader {proxy in
            VStack (alignment:.leading) {
                VStack {
                    AudioTextView(title: "word meaning", content: self.wordSentence.wordDesc) { transContent, voiceAddr in
                        self.wordSentence.wordDesc = transContent
                        self.wordSentence.wordDescVoiceAddr = voiceAddr
                        wordService.markAudio(voiceAddr)
                    }.padding(10).frame(height: 80.0)
                }
                
                Button (action: {
                    let sentence = Sentence(wsid: wordSentence.wsid)
                    self.wordSentence.sentencelist.append(sentence)
                }){
                    Image("plus").resizable()
                        .aspectRatio(contentMode: .fit)
                    Text("add new sentense")
                }.frame(width:260,height                                                                                                                                                                                                                             : UIConstant.btnWidth,alignment: .leading).padding([.leading,.bottom],10)
                
                ScrollViewReader { value in
                    ScrollView {
                        ForEach((0..<self.wordSentence.sentencelist.count), id: \.self) { sIndex in
                            let sentence = wordSentence.sentencelist[sIndex]
                            AudioTextView(title: "record new sentence",content: sentence.content) { transContent, voiceAddr in
                                sentence.content = transContent
                                sentence.voiceAddr = voiceAddr
                                wordService.markAudio(voiceAddr)
                            }.padding(10).frame(height: 80.0)
                        }
                        Spacer()
                    }
                }
            }.background(Color(UIColor.lightGray)).cornerRadius(15.0)
        }
    }
}

