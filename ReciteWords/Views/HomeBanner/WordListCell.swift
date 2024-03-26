//
//  WordListCell.swift
//  Words
//
//  Created by jake on 2024/3/2.
//

import Foundation
import SwiftUI

struct WordListCell : View {
    
    @State private var counter = 0
    @State private var isPlaying: Bool = false
    
    var body: some View {
        VStack {
            if self.isPlaying {
                Text("111")
            } else {
                Text("222")
            }
            
            Button("+1") {
                // 3
                counter += 1
                
            }
        }
        .font(.title)
        .padding()
    }
}

struct PlayButton: View {
    @Binding var isPlaying: Bool


    var body: some View {
        Button(isPlaying ? "Pause" : "Play") {
            isPlaying.toggle()
        }
    }
}

#Preview {
    WordListCell()
}
