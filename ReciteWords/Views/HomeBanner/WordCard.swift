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
    
    init(word: Word) {
        self.word = word
    }
    
    var body: some View {
        VStack {
            Spacer()
            Text(self.word.content!)
            Spacer()
            HStack {
                Button("I don't know it") {
                    
                }.frame(maxWidth: .infinity)
                    .frame(height:40)
                    .foregroundColor(.white)
                    .background(.orange)
                    .cornerRadius(10).padding([.leading],10)
                Button("ring a bell") {
                    
                }.frame(maxWidth: .infinity)
                    .frame(height:40)
                    .foregroundColor(.white)
                    .background(.orange)
                    .cornerRadius(10)
                Button("I know it") {
                    
                }.frame(maxWidth: .infinity).frame(height:40)
                    .foregroundColor(.white)
                    .background(.orange)
                    .cornerRadius(10)
                    .padding([.trailing],10)
            }
        }
    }
}
