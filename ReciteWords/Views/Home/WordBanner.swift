//
//  WordBanner.swift
//  Words
//
//  Created by jake on 2024/3/23.
//

import SwiftUI
import AVFoundation

struct WordBanner :View {
    
    var pageIndex = 0
    
    var wordService = WordService()
    
    let audioPlayer = AudioPlayer()
    
    @State var wordList:Array<Word> = []
    
    @State private var scrollID: Int?
    
    init () {
        let wordArray = wordService.getHomeWordList(pageIndex: pageIndex)
        _wordList = State(initialValue: wordArray!)
        _scrollID = State(initialValue: 0)
    }
    
    func reloadWordList() {
        let wordArray = wordService.getHomeWordList(pageIndex: pageIndex)
        self.wordList = wordArray!
    }
    
    var body: some View {
        GeometryReader { proxy in
            // scroll view
            ScrollViewReader { value in
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack {
                        ForEach(0..<self.wordList.count,  id: \.self) { index in
                            let word = self.wordList[index]
                            VStack {
                                WordCard(word: word, completeHandler: { wordMemory in
                                    word.rememberWord(memory: wordMemory)
                                    self.wordService.updateWord(word: word)
                                    self.scrollToNext()
                                }).frame(width: proxy.size.width,
                                         height: proxy.size.height)
                                .onFrameChange { frame in
                                    if (frame.origin.x == 30.0) {
                                        audioPlayer.playWithFileURL(fileURL: URL(fileURLWithPath: word.voiceAddr!), id: word.id) {
                                            audioPlayer.speak(text: word.content!, id: word.id)
                                        }
                                    }
                                }
                                Spacer()
                            }.id(index)
                        }
                    }.scrollTargetLayout()
                    
                }.scrollDisabled(/*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/).scrollTargetBehavior(.viewAligned).scrollPosition(id: $scrollID).onChange(of: scrollID) { oldValue, newValue in
                    print(newValue ?? "")
                }
                
            }.background(Color(UIColor.secondarySystemBackground)).cornerRadius(15.0)
        }.onAppear() {
            self.reloadWordList()
            scrollID = 0
        }
    }
    
    func scrollToNext() {
        if (scrollID! < self.wordList.count - 1) {
            scrollID = scrollID! + 1
        }
    }
}

extension View {
    func onFrameChange(_ frameHandler: @escaping (CGRect)->(),
                       enabled isEnabled: Bool = true) -> some View {
        
        guard isEnabled else { return AnyView(self) }
        
        return AnyView(self.background(GeometryReader { (geometry: GeometryProxy) in
            
            Color.clear.beforeReturn {
                
                frameHandler(geometry.frame(in: .global))
            }
        }))
    }
    
    private func beforeReturn(_ onBeforeReturn: ()->()) -> Self {
        onBeforeReturn()
        return self
    }
}

extension Comparable {
    func clamped(to range: Range<Self>) -> Self {
        return min(max(self, range.lowerBound), range.upperBound)
    }
}
