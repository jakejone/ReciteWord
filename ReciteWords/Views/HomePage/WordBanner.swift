//
//  WordBanner.swift
//  Words
//
//  Created by jake on 2024/3/23.
//

import SwiftUI
import AVFoundation

struct WordBanner :View {
    
    @StateObject var vm:ViewModel
    
    @State var title:String = ""
    
    init() {
        _vm = StateObject(wrappedValue: ViewModel())
    }
    
    init(showWord:Word, splitVM:SplitViewVM) {
        _vm = StateObject(wrappedValue: ViewModel(showWord: showWord))
        splitVM.jumpShowWord = nil
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
                                Spacer()
                            }.id(index)
                        }
                    }.scrollTargetLayout()
                }.scrollDisabled(true).scrollTargetBehavior(.viewAligned).scrollPosition(id: $vm.scrollID)
            }
        }.onAppear() {
            self.title = vm.dailyWordsCount()
        }.navigationTitle(self.title).environmentObject(self.vm)
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
