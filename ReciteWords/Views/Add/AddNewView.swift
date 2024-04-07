//
//  AddNewWordView.swift
//  Words
//
//  Created by jake on 2024/3/7.
//

import SwiftUI
import AVKit

struct AddNewView : View {
    
    var wordService = WordService()
    
    @ObservedObject var newWord:Word
    
    @Environment(\.presentationMode) var presentationMode
    
    var isUpdate = false
    
    var title:String
    
    init() {
        self.newWord = Word()
        title = "Add New"
    }
    
    init(word:Word) {
        self.newWord = word
        isUpdate = true
        title = "update word"
    }
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                ScrollView {
                    VStack {
                        
                        AudioTextView(title: "new word", content: self.newWord.content) { transContent, voiceAddr in
                            self.newWord.content = transContent
                            self.newWord.voiceAddr = voiceAddr
                            wordService.markAudio(voiceAddr)
                        }.padding(10).frame(width: abs(geometry.size.width - 20), height: UIConstant.btnWidth + 40.0).background(Color(UIColor.secondarySystemBackground)).cornerRadius(15.0)
                        
                        ScrollViewReader { value in
                            ScrollView(.horizontal, showsIndicators: false) {
                                LazyHStack {
                                    ForEach(0..<self.newWord.wordSentenceList.count,  id: \.self) { index in
                                        VStack {
                                            SentenceRecordView(word:self.newWord, cardIndex: index)
                                                .frame(width: geometry.size.width - 40,height: 400)
                                                .padding(10)
                                        }.id(index)
                                    }
                                }.scrollTargetLayout()
                            }.scrollTargetBehavior(.viewAligned)
                        }.background(Color(UIColor.secondarySystemBackground)).cornerRadius(15.0)
                    }
                }.padding(10)
                Spacer()
                HStack {
                    HStack {
                        Button (action: {
                            let newWordSentence = WordSentence(wordid: self.newWord.id)
                            self.newWord.wordSentenceList.append(newWordSentence)
                        }){
                            Image("plus").resizable()
                                .aspectRatio(contentMode: .fit)
                            Text("add word card")
                        }.frame(width:260,height: UIConstant.btnWidth,alignment: .leading).padding(10).background(Color(UIColor.secondarySystemBackground)).cornerRadius(15.0)
                        Spacer()
                    }.padding([.leading],10)
                    
                    Button {
                        self.presentationMode.wrappedValue.dismiss()
                    } label: {
                        Text("cancel")
                    }.frame(width:100, height:40).foregroundColor(.white)
                        .background(.blue)
                        .cornerRadius(10)
                        .padding([.leading,.trailing],10)
                    
                    Button {
                        self.wordService.confirmAddNewWord(newWord: self.newWord)
                        self.presentationMode.wrappedValue.dismiss()
                    } label: {
                        Text("commit")
                    }.frame(width:100, height:40).foregroundColor(.white)
                        .background(.blue)
                        .cornerRadius(10)
                        .padding([.leading,.trailing],10)
                }.padding([.bottom], 10)
            }
        }.onAppear(){
            if (!isUpdate) {
                
            }
        }.navigationTitle(title)
    }
}
