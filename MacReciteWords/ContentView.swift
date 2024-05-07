//
//  ContentView.swift
//  Words
//
//  Created by jake on 2024/2/28.
//

import SwiftUI
import Speech

struct ContentView: View {
    
    @EnvironmentObject var vm:ViewModel
    @State private var selectedItem = OpeRow.Category.Banner
    
    @State var showWord:Word?
    
    var body: some View {
        NavigationSplitView {
            List(selection: $selectedItem) {
                ForEach(0..<vm.operationList.count, id:\.self) { index in
                    let operation = vm.operationList[index]
                    NavigationLink(value: operation.category) {
                        Label(
                            title: { Text(operation.text) },
                            icon: { Image(operation.image).resizable().frame(width: 20,height: 20) }
                        )
                    }
                }
            }.listStyle(.sidebar)
        } detail: {
            switch self.selectedItem {
            case .Banner:
                if let jumpToWord = showWord {
                    WordBanner(toShowWord: jumpToWord)
                } else {
                    WordBanner()
                }
            case .AddNew:
                AddOrUpdateView()
            case .List:
                WordTable(orderType: WordTable.OrderType.Alphabetical) { toShowWord in
                    self.showWord = toShowWord
                    selectedItem = OpeRow.Category.Banner
                }
            case .Setting:
                SettingView()
            }
        }
    }
}

#Preview {
    ContentView()
}
