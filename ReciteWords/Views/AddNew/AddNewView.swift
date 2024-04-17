//
//  AddNewWordView.swift
//  Words
//
//  Created by jake on 2024/3/7.
//

import SwiftUI
import AVKit

struct AddNewView : View {
    
    @StateObject var vm:AddNewViewModel
    
    @Environment(\.presentationMode) var presentationMode

    @State private var showAlert = false
    
    init() {
        _vm = StateObject(wrappedValue: AddNewViewModel())
    }
    
    init(word:Word) {
        _vm = StateObject(wrappedValue: AddNewViewModel(word: word))
    }
    
    var body: some View {
        GeometryReader { geometry in
            VStack (alignment: .leading) {
                // audio text
                AudioTextView(placeHolder: "word", content: vm.word.content) { transContent, voiceAddr in
                    vm.wordRecordFinished(content: transContent, voiceAddr: voiceAddr)
                }.frame(maxWidth: .infinity).frame(height: UIConstant.btnWidth * 2)
                
                // word sentenceCard scrollView
                ScrollViewReader { value in
                    ScrollView(.horizontal, showsIndicators: true) {
                        LazyHStack {
                            ForEach(0..<self.vm.wordSentenceCount,  id: \.self) { index in
                                VStack {
                                    SentenceRecordView(wordSentence:self.vm.word.wordSentenceList[index])
                                        .frame(width: geometry.size.width)
                                }.id(index)
                            }
                        }.scrollTargetLayout()
                    }.scrollTargetBehavior(.viewAligned)
                }.frame(maxHeight: .infinity).cornerRadius(15.0)
                
                Spacer()
                // bottom Operation bar
                HStack {
                    HStack {
                        Button (action: {
                            vm.addCardBtnClick()
                        }){
                            HStack {
                                AdaptiveImage(light: Image("plus_l").resizable(),
                                              dark: Image("plus_d").resizable()).frame(width:40,height: 40)
                                Text("add card")
                            }
                        }.buttonStyle(PlainButtonStyle()).frame(width:100,height: UIConstant.btnWidth,alignment: .leading).padding(10)
                        Spacer()
                    }.padding([.leading],10)
#if os(iOS) || os(watchOS) || os(tvOS)
                    Button("cancel") {
                        self.presentationMode.wrappedValue.dismiss()
                    }.buttonStyle(BlueButtonStyle())
                        .frame(width:100, height:40)
                        .foregroundColor(.white)
                        .background(.blue)
                        .cornerRadius(10)
                        .padding([.leading,.trailing],10)
#endif
                    Button("commit") {
                        vm.commitBtnClick()
                        showAlert = true
                    }.buttonStyle(BlueButtonStyle())
                        .frame(width:100, height:40)
                        .foregroundColor(.white)
                        .background(.blue)
                        .cornerRadius(10)
                        .padding([.leading,.trailing],10)
                    
                }.padding([.bottom], 10)
            }
        }.navigationTitle(vm.title).environmentObject(vm).alert(isPresented: $showAlert) {
            Alert(
                title: Text("success"),
                dismissButton: .default(Text("add new"), action: {
                    vm.clean()
                })
            )
        }
    }
    
    func reloadAddNew() {
        
    }
}
