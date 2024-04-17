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
    @State private var selectedWord: Word?
    
    var body: some View {
        NavigationSplitView {
            List(selection: $selectedWord) {
                ForEach(vm.operationList) { operation in
                    NavigationLink {
                        switch operation.category {
                        case .Banner:
                            WordBanner()
                        case .AddNew:
                            AddNewView()
                        case .Setting:
                            SettingView()
                        }
                    } label: {
                        OperationCell(operation: operation)
                    }.tag(operation)
                }
            }.navigationTitle("11")
        } detail: {
            Text("Select a Landmark")
        }
    }
}

#Preview {
    ContentView()
}
