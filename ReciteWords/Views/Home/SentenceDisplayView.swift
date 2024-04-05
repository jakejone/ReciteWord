//
//  WordListCell.swift
//  Words
//
//  Created by jake on 2024/3/2.
//

import Foundation
import SwiftUI

struct SentenceDisplayView : View {
    
    @EnvironmentObject var vm:ViewModel
    
    @ObservedObject var word:Word
    
    init(word:Word) {
        self.word = word
    }
    
    var body: some View {
        VStack (alignment:.leading) {
            GeometryReader { geometry in
                ScrollViewReader { value in
                    ScrollView(.vertical, showsIndicators: false) {
                        LazyVStack {
                            ForEach(0..<self.word.wordSentenceList.count,  id: \.self) { index in
                                VStack {
                                    let wordSentence:WordSentence = self.word.wordSentenceList[index]
                                    Button(action: {
                                        vm.playWordSentence(wordSentence: wordSentence)
                                    }){
                                        if (wordSentence.wordDesc != nil) {
                                            Text(wordSentence.wordDesc!).font(.title2).frame(maxWidth: .infinity, alignment:.center)
                                        }
                                    }
                                    self.sentenceListView(wordSentence: wordSentence)
                                }.padding([.top,.leading,.trailing],10).padding([.bottom],20).background(Color(UIColor.secondarySystemBackground)).cornerRadius(15)
                            }
                        }.scrollTargetLayout()
                    }.scrollTargetBehavior(.viewAligned).frame(width: geometry.size.width, height: geometry.size.height)
                }
            }
        }
    }
    
    func sentenceListView(wordSentence:WordSentence) -> AnyView {
        return AnyView(
            ForEach(0..<wordSentence.sentencelist.count,  id: \.self) { sentenceIndex in
                let sentence:Sentence = wordSentence.sentencelist[sentenceIndex]
                HStack{
                    Button(action: {
                        vm.playSentence(sentence: sentence)
                    }){
                        Text(sentence.content!).font(.title2).frame(maxWidth: .infinity, alignment:.leading).padding([.top],10)
                    }
                    Spacer()
                }
            }
        )
    }
}
