//
//  HomePage.swift
//  MacReciteWords
//
//  Created by jake on 2024/4/13.
//

import Foundation
import SwiftUI

struct HomePage : View {
    
    @StateObject var vm = ViewModel()
    
    var body: some View {
        
        VStack {
            
            GeometryReader { geometry in
                Text("123123111111111111111")
                WordBanner().frame(width: geometry.size.width,height: geometry.size.height)
                
                operationBtns
                
            }.onAppear() {
                self.vm.reload()
            }.environmentObject(vm)
            
        }
        
    }
    
    private var operationBtns : some View {
        return ZStack {
            HStack {
                Spacer()
                NavigationLink(destination: AddNewView()) {
                    
                    NavigationLink(destination: Text("123123123")) {
                        ButtonView()
                    }
                }.background(Color.clear).padding([.trailing], 10)
                
                NavigationLink(destination: SettingView()) {
                    Image("settings").resizable().frame(width:40,height: 40)
                }.padding([.trailing], 10)
            }
        }
    }
}


struct ButtonView: View {
    var body: some View {
        Text("Starten")
            .frame(width: 200, height: 100, alignment: .center)
            .background(Color.yellow)
            .foregroundColor(Color.red)
    }
}



