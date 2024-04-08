//
//  ContentView.swift
//  Words
//
//  Created by jake on 2024/2/28.
//

import SwiftUI
import Speech

struct ContentView: View {
    
    @StateObject var vm = ViewModel()
    
    var body: some View {
        VStack {
            NavigationStack {
                GeometryReader { geometry in
                    
                    WordBanner().frame(width: geometry.size.width,height: geometry.size.height)
                    
                    operationBtns
                    
                }.onAppear() {
                    self.vm.reload()
                }.environmentObject(vm)
            }
        }
    }
    
    private var operationBtns : some View {
        return ZStack {
            HStack {
                Spacer()
                
                NavigationLink(destination: AddNewView()) {
                    AdaptiveImage(light: Image("plus_l").resizable(),
                                  dark: Image("plus_d").resizable()).frame(width:40,height: 40)
                    
                }.padding([.trailing], 10)
                
                NavigationLink(destination: SettingView()) {
                    AdaptiveImage(light: Image("settings_l").resizable(),
                                  dark: Image("settings_d").resizable()).frame(width:40,height: 40)
                }.padding([.trailing], 10)
            }
        }
    }
}

#Preview {
    ContentView()
}
