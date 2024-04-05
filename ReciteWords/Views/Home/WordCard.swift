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
        GeometryReader { geometry in
            VStack {
                ZStack {
                    Button(action: {
                        vm.playWord(word: word, force: true)
                    }, label: {
                        Text(self.word.content!).frame(width:geometry.size.width, alignment: .center).font(.largeTitle).padding([.top],60)
                    })
                    
                    HStack {
                        Spacer()
                        NavigationLink(destination: AddNewView(word: self.word)) {
                            Image("editing").resizable()
                        }.frame(width:40,height: 40).padding([.top],60).padding([.trailing],10)
                    }
                }
                
                VStack {
                    wordSentence
                    
                    bottomBtn
                    
                }.padding([.bottom], 10)
            }
        }
    }
    
    private var wordSentence : some View {
        switch vm.sentenceState {
        case .hidden:
            return AnyView(
                GeometryReader { proxy in
                    Button(action: {
                        self.vm.markInMemory(memory: .RingABell)
                    }, label: {
                        Text("").frame(width:proxy.size.width,height: proxy.size.height)
                    })
                }
            )
        case .show:
            return AnyView(
                GeometryReader { geometry in
                    ScrollViewReader { value in
                        ScrollView(.horizontal, showsIndicators: false) {
                            LazyHStack {
                                SentenceDisplayView(word: self.word ).frame(width:geometry.size.width - 20).frame(maxHeight:.infinity).padding(10)
                            }.scrollTargetLayout()
                        }.scrollTargetBehavior(.viewAligned)
                    }
                }
            )
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
