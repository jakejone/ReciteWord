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
                WordBanner()
            case .AddNew:
                AddNewView()
            case .Setting:
                SettingView()
            }
        }
    }
}

#Preview {
    ContentView()
}
