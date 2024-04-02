//
//  WordListCell.swift
//  Words
//
//  Created by jake on 2024/3/2.
//

import Foundation
import SwiftUI

struct WordSentenceDisplayView : View {
    
    var btnWidth = 40.0
    
    var sentenceList:Array<Sentence>
    
    var audioPlayer = AudioPlayer()
    
    @State var sentenceCount:Int = 0
    
    init(sentenceList: Array<Sentence>) {
        self.sentenceList = sentenceList
        _sentenceCount = State(initialValue: sentenceList.count)
    }
    
    var body: some View {
        VStack (alignment:.leading) {
            ScrollViewReader { value in
                ScrollView(.vertical, showsIndicators: false) {
                    LazyVStack {
                        ForEach(0..<self.sentenceCount,  id: \.self) { index in
                            let sentence:Sentence = self.sentenceList[index]
                            HStack{
                                Text(sentence.content!)
                                Button(action: {
                                    if sentence.voiceAddr != nil {
                                        self.audioPlayer.playWithFileURL(URL(fileURLWithPath: sentence.voiceAddr!))
                                    }
                                }){
                                    Image("playbtn").resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: self.btnWidth,height: self.btnWidth)
                                        .padding([.leading])
                                }
                                Spacer()
                            }
                        }
                    }.scrollTargetLayout()
                }.scrollTargetBehavior(.viewAligned)
            }.background(Color(UIColor.secondarySystemBackground)).cornerRadius(15.0)
        }
        .font(.title3)
        .padding()
    }
}
