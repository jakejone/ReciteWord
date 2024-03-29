//
//  WordBanner.swift
//  Words
//
//  Created by jake on 2024/3/23.
//

import SwiftUI
import AVFoundation

struct WordBanner :View {
    
    var wordService = WordService()
    
    var pageIndex = 0
    
    let audioPlayer = AudioPlayer()
    
    @State var wordList:Array<Word>?
    
    @State var wordCount:Int
    
    @State var lastSpeakWordID:UUID?
    
    @State private var currentIndex = 0
    
    @State private var scrollID: Int?
    
    init () {
        let wordArray = wordService.getHomeWordList(pageIndex: pageIndex)
        _wordList = State(initialValue: wordArray)
        _wordCount = State(initialValue: wordArray!.count)
        _scrollID = State(initialValue: 0)
    }
    
    func reloadWordList() {
        let wordArray = wordService.getHomeWordList(pageIndex: pageIndex)
        self.wordList = wordArray
        self.wordCount = wordArray!.count
    }
    
    var body: some View {
        
        GeometryReader { proxy in
            // scroll view
            ScrollViewReader { value in
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack {
                        ForEach(0..<wordCount,  id: \.self) { index in
                            VStack {
                                let word = self.wordList![index]
                                WordCard(word: word, completeHandler: { wordMemory in
                                    word.rememberWord(memory: wordMemory)
                                    self.wordService.updateWord(word: word)
                                    self.scrollToNext()
                                }).frame(width: proxy.size.width,
                                                           height: proxy.size.height)
                                .onFrameChange { frame in
                                    if (frame.origin.x == 30.0 && frame.origin.y == 85.0) {
                                        audioPlayer.playWithFileURL(fileURL: URL(fileURLWithPath: word.voiceAddr!), id: word.id) {
                                            audioPlayer.speak(text: word.content!, id: word.id)
                                        }
                                    }
                                }
                                Spacer()
                            }.id(index)
                        }
                    }.scrollTargetLayout()
                    
                }.scrollTargetBehavior(.viewAligned).scrollDisabled(true).scrollPosition(id: $scrollID).onChange(of: scrollID) { oldValue, newValue in
                    print(newValue ?? "")
                }
                
            }.background(Color(UIColor.secondarySystemBackground)).cornerRadius(15.0)
        }.onAppear() {
            self.reloadWordList()
        }
    }
    
    func scrollToNext() {
        withAnimation {
            if (scrollID! < self.wordCount - 1) {
                scrollID = self.scrollID! + 1
            }
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
