//
//  AddNewWordView.swift
//  Words
//
//  Created by jake on 2024/3/7.
//

import SwiftUI
import AVKit

struct NewwordView : View {
    
    // need to save data to db
    
    var wordService = WordService()
    
    var btnWidth = 40.0
    
    var newWord = Word()
    
    @State var sentenceCardCount:Int = 0
    
    var body: some View {
        GeometryReader { proxy in
            ScrollView {
                
                Text("新增").font(.title)
                
                RecordView(title: "new word") { transContent, voiceAddr in
                    self.newWord.content = transContent
                    self.newWord.voiceAddr = voiceAddr
                    wordService.markAudio(voiceAddr)
                }.padding(10).frame(width: abs(proxy.size.width - 20), height: self.btnWidth + 40.0).background(Color(UIColor.secondarySystemBackground)).cornerRadius(15.0)
                
                
                HStack {
                    Button (action: {
                        let newWordSentence = WordSentence(wordid: self.newWord.id)
                        self.newWord.wordSentenceList.append(newWordSentence)
                        self.sentenceCardCount = self.newWord.wordSentenceList.count
                    }){
                        Image("plus").resizable()
                            .aspectRatio(contentMode: .fit)
                        Text("add word card")
                    }.frame(width:260,height: btnWidth,alignment: .leading).padding(10).background(Color(UIColor.secondarySystemBackground)).cornerRadius(15.0)
                    Spacer()
                }
                
                
                ScrollViewReader { value in
                    ScrollView(.horizontal, showsIndicators: false) {
                        LazyHStack {
                            ForEach(0..<sentenceCardCount,  id: \.self) { index in
                                VStack {
                                    SentenceCard(word:self.newWord, wordService: self.wordService, cardIndex: index) { wordSentenceArray in
                                        self.newWord.wordSentenceList = wordSentenceArray
                                    }.frame(width:proxy.size.width - 20,height: proxy.size.height - (self.btnWidth + 40) - 30 - 40 - 150 ).padding(10)
                                    Spacer()
                                }.id(index)
                            }
                        }.scrollTargetLayout()
                    }.scrollTargetBehavior(.viewAligned)
                }.background(Color(UIColor.secondarySystemBackground)).cornerRadius(15.0)
                
                Spacer()
                HStack {
                    Button {
                        // TODO:jake alert confirm
                    } label: {
                        Text("cancel")
                    }
                    
                    Button {
                        // TODO:jake alert confirm
                        self.wordService.confirmAddNewWord(newWord: self.newWord)
                    } label: {
                        Text("commit")
                    }
                }
            }.padding(10)
        }
        
    }
}
