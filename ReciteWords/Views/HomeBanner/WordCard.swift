//
//  WordCard.swift
//  Words
//
//  Created by jake on 2024/3/23.
//

import SwiftUI
import AVFoundation

struct WordCard : View {
    
    var btnWidth = 40.0
    
    @StateObject var word:Word
    
    var completeHandler:(WordMemory)->Void?
    
    init(word: Word, completeHandler:@escaping (WordMemory)->Void) {
        print("!.. word init, word content:\(word.content!)")
        _word = StateObject(wrappedValue: word)
        self.completeHandler = completeHandler
    }
    
    var body: some View {
        GeometryReader { proxy in
            VStack {
                ZStack {
                    HStack (alignment:.top) {
                        Spacer()
                        NavigationLink(destination: NewwordView(word: self.word)) {
                            Image("editing").resizable()
                        }.frame(width:40,height: 40).padding([.top],60)
                    }
                    
                    Text(self.word.content!).font(.largeTitle).padding([.top],30)
                }
                
                ScrollViewReader { value in
                    ScrollView(.horizontal, showsIndicators: false) {
                        LazyHStack {
                            ForEach(0..<self.word.wordSentenceList.count,  id: \.self) { index in
                                VStack {
                                    WordSentenceDisplayView(sentenceList: self.word.wordSentenceList[0].sentencelist ).frame(width:proxy.size.width - 20,height: proxy.size.height - (self.btnWidth + 40) - 30 - 40 - 150 ).padding(10)
                                    Spacer()
                                }.id(index)
                            }
                        }.scrollTargetLayout()
                    }.scrollTargetBehavior(.viewAligned)
                }.background(Color(UIColor.secondarySystemBackground)).cornerRadius(15.0)
                
                Spacer()
                HStack {
                    Button("no idea") {
                        self.completeHandler(WordMemory.NoIdea)
                    }.frame(maxWidth: .infinity)
                        .frame(height:40)
                        .foregroundColor(.white)
                        .background(.orange)
                        .cornerRadius(10).padding([.leading],10)
                    Button("ring a bell") {
                        self.completeHandler(WordMemory.RingABell)
                    }.frame(maxWidth: .infinity)
                        .frame(height:40)
                        .foregroundColor(.white)
                        .background(.orange)
                        .cornerRadius(10)
                    Button("gotcha") {
                        self.completeHandler(WordMemory.Gotcha)
                    }.frame(maxWidth: .infinity).frame(height:40)
                        .foregroundColor(.white)
                        .background(.orange)
                        .cornerRadius(10)
                        .padding([.trailing],10)
                }
            }.padding([.bottom], 10)
        }
        
    }
}
