//
//  File.swift
//  ReciteWords
//
//  Created by jake on 2024/4/6.
//

import Foundation
import SwiftUI

struct SettingView : View {
    var body: some View {
        VStack {
            List {
                NavigationLink(destination: WordTable()) {
                    Text("check data list ")
                }.padding([.trailing], 10)
                
                NavigationLink(destination: EmptyView()) {
                    Text("export data to( TO DO ) ")
                }.padding([.trailing], 10)
                
                NavigationLink(destination: EmptyView()) {
                    Text("import data from( TO DO ) ")
                }.padding([.trailing], 10)
            }
        }
    }
}
