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
    
    var body: some View {
        GeometryReader { proxy in
            // scroll view
            ScrollViewReader { value in
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack {
                        ForEach(0..<self.vm.wordList.count,  id: \.self) { index in
                            let word = self.vm.wordList[index]
                            VStack {
                                WordCard(word: word).frame(width: proxy.size.width,
                                         height: proxy.size.height)
                                .onFrameChange { frame in
                                    if (frame.origin.x == 0) {
                                        vm.playWord(word: word)
                                    }
                                }
                                Spacer()
                            }.id(index)
                        }
                    }.scrollTargetLayout()
                    
                }.scrollDisabled(true).scrollTargetBehavior(.viewAligned).scrollPosition(id: $vm.scrollID)
                
            }.frame(width: proxy.size.width,
                    height: proxy.size.height)
        }.background(Color(UIColor.systemBackground))
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
