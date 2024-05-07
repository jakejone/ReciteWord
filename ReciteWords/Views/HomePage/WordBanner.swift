//
//  WordBanner.swift
//  Words
//
//  Created by jake on 2024/3/23.
//

import SwiftUI
import AVFoundation

struct WordBanner :View {
    
    @EnvironmentObject var vm:ViewModel
    
    @State var title:String = ""
    
    var toShowWord:Word?
    
    init() {
        
    }
    
    init(toShowWord:Word) {
        self.toShowWord = toShowWord
    }
    
    
    var body: some View {
        GeometryReader { geometry in
            ScrollViewReader { value in
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack {
                        ForEach(0..<self.vm.wordList.count,  id: \.self) { index in
                            let word = self.vm.wordList[index]
                            VStack {
                                WordCard(word: word).frame(width: geometry.size.width,
                                                           height: geometry.size.height)
                                .onFrameChange { frame in
                                    if (frame.origin.x == 0 || frame.origin.y == 48.0) {
                                        vm.playWord(word: word)
                                    }
                                }
                                Spacer()
                            }.id(index)
                        }.onAppear() {
                            if let showWord = toShowWord {
                                vm.showWord(word: showWord)
                            }
                        }
                    }.scrollTargetLayout()
                }.scrollDisabled(true).scrollTargetBehavior(.viewAligned).scrollPosition(id: $vm.scrollID)
            }.onAppear(perform: {
                vm.reload()
            })
        }.onAppear() {
            self.title = vm.dailyWordsCount()
        }.navigationTitle(self.title)
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
