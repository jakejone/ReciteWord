//
//  WordListCell.swift
//  Words
//
//  Created by jake on 2024/3/2.
//

import Foundation
import SwiftUI

struct SentenceDisplayView : View {
    
    @State var sentenceList:Array<Sentence>
    
    @EnvironmentObject var vm:ViewModel
    
    init(sentenses: Array<Sentence>) {
        self.sentenceList = sentenses
    }
    
    var body: some View {
        VStack (alignment:.leading) {
            GeometryReader { geometry in
                ScrollViewReader { value in
                    ScrollView(.vertical, showsIndicators: false) {
                        LazyVStack {
                            ForEach(0..<self.sentenceList.count,  id: \.self) { index in
                                let sentence:Sentence = self.sentenceList[index]
                                HStack{
                                    Button(action: {
                                        vm.playSentence(sentence: sentence)
                                    }){
                                        Text(sentence.content!).font(.title2).frame(maxWidth: .infinity, alignment:.leading).padding([.top],10)
                                    }
                                    Spacer()
                                }
                            }
                        }.scrollTargetLayout()
                    }.scrollTargetBehavior(.viewAligned).frame(width: geometry.size.width, height: geometry.size.height)
                }.background(Color(UIColor.secondarySystemBackground)).cornerRadius(15.0)
            }
        }
        .font(.title3)
        .padding()
    }
}
