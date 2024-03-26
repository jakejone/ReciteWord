//
//  ContentView.swift
//  Words
//
//  Created by jake on 2024/2/28.
//
// 1. 数据的存储，必须用db
// 2. 数据的获取，打开App时的获取
// 3.

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
