//
//  MacReciteWordsApp.swift
//  MacReciteWords
//
//  Created by jake on 2024/4/11.
//

import SwiftUI

@main
struct MacReciteWordsApp: App {
    @StateObject var vm = ViewModel()
    var body: some Scene {
        WindowGroup {
            ContentView()
        }.environmentObject(vm)
    }
}
