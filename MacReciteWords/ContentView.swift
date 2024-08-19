//
//  ContentView.swift
//  Words
//
//  Created by jake on 2024/2/28.
//

import SwiftUI
import Speech

struct ContentView: View {
    
    @StateObject var splitVM:SplitViewVM
    @State private var selectedItem = OpeRow.Category.Banner
    

    init() {
        _splitVM = StateObject(wrappedValue: SplitViewVM())
    }
    
    var body: some View {
        NavigationSplitView {
            List(selection: $selectedItem) {
                ForEach(0..<splitVM.operationList.count, id:\.self) { index in
                    let operation = splitVM.operationList[index]
                    NavigationLink {
                        switch operation.category {
                        case .Banner:
                            if let jumpToWord = splitVM.jumpShowWord {
                                WordBanner(showWord: jumpToWord, splitVM: self.splitVM)
                            } else {
                                WordBanner()
                            }
                        case .AddNew:
                            AddOrUpdateView()
                        case .List:
                            WordTable(orderType: WordTable.OrderType.Alphabetical) { toShowWord in
                                splitVM.jumpShowWord = toShowWord
                                selectedItem = OpeRow.Category.Banner
                            }
                        case .Setting:
                            SettingView { toShowWord in
                                splitVM.jumpShowWord = toShowWord
                                selectedItem = OpeRow.Category.Banner
                            }
                        }
                    } label: {
                        Label {
                            Text(operation.text)
                        } icon: {
                            Image(operation.image).resizable().frame(width: 20,height: 20)
                        }
                    }.tag(operation.category)

                }
            }.listStyle(.sidebar)
        } detail: {
           
        }
    }
}

#Preview {
    ContentView()
}
