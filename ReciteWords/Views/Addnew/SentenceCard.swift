//
//  SentenceCard.swift
//  Words
//
//  Created by jake on 2024/3/17.
//

import SwiftUI

struct SentenceCard : View {
    
    var btnWidth = 40.0
    
    var wsHandler:(_ wordSentenceArray:Array<WordSentence>)->Void
    
    var word:Word
    
    var wordService:WordService
    
    @State var sentenceCount:Int = 0
    
    let wordSentence:WordSentence
    
    init(word:Word, wordService:WordService, cardIndex:Int, wordSentenceHandler:@escaping (_ wordSentenceArray:Array<WordSentence>)->()) {
        self.wsHandler = wordSentenceHandler
        self.word = word
        self.wordService = wordService
        self.wordSentence  = word.wordSentenceList[cardIndex]
    }
    
    var body: some View {
        GeometryReader {proxy in
            VStack (alignment:.leading) {
                VStack {
                    RecordView(title: "word meaning") { transContent, voiceAddr in
                        self.wordSentence.wordDesc = transContent
                        self.wordSentence.wordDescVoiceAddr = voiceAddr
                        wordService.markAudio(voiceAddr)
                    }.padding(10).frame(height: 80.0)
                }
                
                Button (action: {
                    let sentence = Sentence(wsid: wordSentence.wsid)
                    self.wordSentence.sentencelist.append(sentence)
                    sentenceCount = self.wordSentence.sentencelist.count
                }){
                    Image("plus").resizable()
                        .aspectRatio(contentMode: .fit)
                    Text("add new sentense")
                }.frame(width:260,height                                                                                                                                                                                                                             : btnWidth,alignment: .leading).padding([.leading,.bottom],10)
                
                ScrollViewReader { value in
                    ScrollView {
                        ForEach((0..<sentenceCount), id: \.self) { sIndex in
                            let sentence = wordSentence.sentencelist[sIndex]
                            RecordView(title: "record new sentence") { transContent, voiceAddr in
                                // TODO:jake attension the edit, and the position of the sentence
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

