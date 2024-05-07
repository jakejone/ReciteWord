//
//  File.swift
//  ReciteWords
//
//  Created by jake on 2024/4/6.
//

import Foundation
import SwiftUI

struct SettingView : View {
    
    var dbPath: String {
        get {
            return WordDataManager().getDBPath()
        }
    }
    
    var body: some View {
        VStack {
            List {
                NavigationLink(destination: WordDateTable()) {
                    Text("statistic data by date")
                }.padding([.trailing], 10)
                NavigationLink(destination: WordTable(orderType: WordTable.OrderType.Score, showWordHandler: { Word in
                    
                })) {
                    Text("check data list (score order)")
                }.padding([.trailing], 10)
                
                NavigationLink(destination: WordTable(orderType: WordTable.OrderType.Alphabetical, showWordHandler: { Word in
                    
                })) {
                    Text("check data list (alphabetical order)")
                }.padding([.trailing], 10)
                
                NavigationLink(destination: EmptyView()) {
                    Text("export data to(TODO: add web server ,support data download ) ")
                }.padding([.trailing], 10)
                
                NavigationLink(destination: EmptyView()) {
                    Text("import data from(TODO: add web server, drag data to web page or post request ) ")
                }.padding([.trailing], 10)
                
                TextEditor(text: .constant(self.dbPath))
                
                Button("clean extra voice data") {
                    WordService().cleanExtraVoiceData()
                }
                
            }
        }
    }
}
