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
    
    @State var sentencelist:Array<Sentence>
    
    init(word:Word, cardIndex:Int) {
        self.word = word
        self.wordSentence  = word.wordSentenceList[cardIndex]
        sentencelist = self.wordSentence.sentencelist
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
                    self.sentencelist.append(sentence)
                }){
                    Image("plus").resizable()
                        .aspectRatio(contentMode: .fit)
                    Text("add new sentense")
                }.frame(width:260,height                                                                                                                                                                                                                             : UIConstant.btnWidth,alignment: .leading).padding([.leading,.bottom],10)
                
                ScrollViewReader { value in
                    ScrollView {
                        ForEach(self.sentencelist) { sentence in
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

