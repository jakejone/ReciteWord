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
    
    init () {
        let wordArray = wordService.getHomeWordList(pageIndex: pageIndex)
        _wordList = State(initialValue: wordArray)
        _wordCount = State(initialValue: wordArray!.count)
        
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
                                WordCard(word: word).frame(width: proxy.size.width,
                                                           height: proxy.size.height)
                                .onFrameChange { frame in
                                    
                                    if (frame.origin.x == 30.0 && frame.origin.y == 85.0) {
//                                        audioPlayer.speak(text: word.content!, id: word.id)
                                        audioPlayer.playWithFileURL(fileURL: URL(fileURLWithPath: word.voiceAddr!), id: word.id)
                                    }
                                }
                                Spacer()
                            }.id(index)
                        }
                    }.scrollTargetLayout()
                }.scrollTargetBehavior(.viewAligned)
            }.background(Color(UIColor.secondarySystemBackground)).cornerRadius(15.0)
        }.onAppear() {
            self.reloadWordList()
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
