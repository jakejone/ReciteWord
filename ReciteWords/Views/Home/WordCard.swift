//
//  WordCard.swift
//  Words
//
//  Created by jake on 2024/3/23.
//

import SwiftUI
import AVFoundation

struct WordCard : View {
    
    @EnvironmentObject var vm:ViewModel
    
    @ObservedObject var word:Word
    
    var btnWidth = 40.0
    
    init(word: Word) {
        self.word = word
    }
    
    var body: some View {
        GeometryReader { proxy in
            VStack {
                ZStack {
                    Button(action: {
                        vm.playWord(word: word, force: true)
                    }, label: {
                        Text(self.word.content!).frame(width:proxy.size.width, alignment: .center).font(.largeTitle).padding([.top],60)
                    })
                    
                    HStack {
                        Spacer()
                        NavigationLink(destination: AddNewView(word: self.word)) {
                            Image("editing").resizable()
                        }.frame(width:40,height: 40).padding([.top],60).padding([.trailing],10)
                    }
                }
                
                VStack {
                    ScrollViewReader { value in
                        ScrollView(.horizontal, showsIndicators: false) {
                            LazyHStack {
                                ForEach(0..<self.word.wordSentenceList.count,  id: \.self) { index in
                                    VStack {
                                        SentenceDisplayView(sentenceList: self.word.wordSentenceList[0].sentencelist ).frame(width:proxy.size.width - 20,height: proxy.size.height - (self.btnWidth + 40) - 30 - 40 - 150 ).padding(10)
                                        Spacer()
                                    }.id(index)
                                }
                            }.scrollTargetLayout()
                        }.scrollTargetBehavior(.viewAligned)
                    }.background(Color(UIColor.secondarySystemBackground)).cornerRadius(15.0)
                    
                    Spacer()
                    bottomBtn
                    
                }.padding([.bottom], 10)
            }
            
            
        }
    }
    
    private var bottomBtn : some View {
        switch vm.memoryBtnState {
        case .origin:
            return AnyView(
                HStack {
                    Button(action: {
                        self.vm.markInMemory(memory: .NoIdea)
                    }, label: {
                        Text("no idea").frame(maxWidth: .infinity).contentShape(Rectangle())
                    }).frame(maxWidth: .infinity).frame(height:40)
                        .foregroundColor(.white)
                        .background(.orange)
                        .cornerRadius(10)
                        .padding([.leading],10)
                    
                    Button(action: {
                        self.vm.markInMemory(memory: .RingABell)
                    }, label: {
                        Text("ring a bell").frame(maxWidth: .infinity).contentShape(Rectangle())
                    }).frame(maxWidth: .infinity).frame(height:40)
                        .foregroundColor(.white)
                        .background(.orange)
                        .cornerRadius(10)
                    
                    Button(action: {
                        self.vm.markInMemory(memory: .Gotcha)
                    }, label: {
                        Text("gotcha").frame(maxWidth: .infinity).contentShape(Rectangle())
                    }).frame(maxWidth: .infinity).frame(height:40)
                        .foregroundColor(.white)
                        .background(.orange)
                        .cornerRadius(10)
                        .padding([.trailing],10)
                }
            )
        case .gotoNext:
            return AnyView(
                Button(action: {
                    self.vm.nextWord()
                }, label: {
                    Text("Next Word").frame(maxWidth: .infinity).contentShape(Rectangle())
                }).frame(maxWidth: .infinity).frame(height:40)
                    .foregroundColor(.white)
                    .background(.orange)
                    .cornerRadius(10)
                    .padding([.leading],10)
                    .padding([.trailing],10)
            )
        }
    }
}
