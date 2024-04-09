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
                    Text("export data to(TODO: add web server ,support data download ) ")
                }.padding([.trailing], 10)
                
                NavigationLink(destination: EmptyView()) {
                    Text("import data from(TODO: add web server, drag data to web page or post request ) ")
                }.padding([.trailing], 10)
            }
        }
    }
}
