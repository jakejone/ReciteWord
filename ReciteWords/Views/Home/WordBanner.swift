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
    
    let audioPlayer = AudioPlayer()
    
    var body: some View {
        content
    }
    
    private var content: some View {
        switch vm.state {
        case .idle:
            return AnyView(EmptyView().onAppear() {
                // if load data need some time ,it will go to state loading
                // load data will be put in sub thread
                vm.reload()
            })
        case .loaded:
            return AnyView(wordBanner)
        case .ringABell:
            return AnyView(wordBanner)
        case .noIdea:
            return AnyView(wordBanner)
        case .error(let error):
            return AnyView(Text("Error: \(error.localizedDescription)"))
        }
    }
    
    private var wordBanner: some View {
        return AnyView(
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
                        
                    }.scrollDisabled(true).scrollTargetBehavior(.viewAligned).scrollPosition(id: $vm.scrollID)
                    
                }.frame(width: proxy.size.width,
                        height: proxy.size.height)
            }.background(Color(UIColor.secondarySystemBackground)))
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
