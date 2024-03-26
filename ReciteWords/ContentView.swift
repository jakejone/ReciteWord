//
//  ContentView.swift
//  Words
//
//  Created by jake on 2024/2/28.
//

import SwiftUI
import Speech

struct ContentView: View {
    
    var body: some View {
        NavigationStack {
            ZStack (alignment: .topTrailing) {
                
                WordBanner().padding(30)
                
                HStack (alignment:.top) {
                    VStack(alignment:.trailing) {
                        NavigationLink(destination: NewwordView()) {
                            Image("plus").resizable()
                        }.frame(width:60,height: 60)
                    }
                }.padding([.trailing], 30)
            }
        }
    }
}

#Preview {
    ContentView()
}
