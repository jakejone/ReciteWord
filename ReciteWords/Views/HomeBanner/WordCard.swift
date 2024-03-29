//
//  WordCard.swift
//  Words
//
//  Created by jake on 2024/3/23.
//

import SwiftUI
import AVFoundation

struct WordCard : View {
    
    @State var word:Word
    
    var completeHandler:(WordMemory)->Void?
    
    init(word: Word, completeHandler:@escaping (WordMemory)->Void) {
        self.word = word
        self.completeHandler = completeHandler
    }
    
    var body: some View {
        VStack {
            ZStack {
                HStack (alignment:.top) {
                    Spacer()
                    NavigationLink(destination: NewwordView(word: self.word)) {
                        Image("pen").resizable()
                    }.frame(width:40,height: 40).padding([.top],60)
                }
                Text(self.word.content!).font(.largeTitle).padding([.top],30)
            }
            
            Spacer()
            HStack {
                Button("no idea") {
                    self.completeHandler(WordMemory.NoIdea)
                }.frame(maxWidth: .infinity)
                    .frame(height:40)
                    .foregroundColor(.white)
                    .background(.orange)
                    .cornerRadius(10).padding([.leading],10)
                Button("ring a bell") {
                    self.completeHandler(WordMemory.RingABell)
                }.frame(maxWidth: .infinity)
                    .frame(height:40)
                    .foregroundColor(.white)
                    .background(.orange)
                    .cornerRadius(10)
                Button("gotcha") {
                    self.completeHandler(WordMemory.Gotcha)
                }.frame(maxWidth: .infinity).frame(height:40)
                    .foregroundColor(.white)
                    .background(.orange)
                    .cornerRadius(10)
                    .padding([.trailing],10)
            }
        }.padding([.bottom], 10)
    }
}
