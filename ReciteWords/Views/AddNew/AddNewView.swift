//
//  AddNewWordView.swift
//  Words
//
//  Created by jake on 2024/3/7.
//

import SwiftUI
import AVKit

struct AddNewView : View {
    
    @StateObject var addNewVM:AddNewViewModel
    
    @Environment(\.presentationMode) var presentationMode

    @State private var showAlert = false
    
    init() {
        _addNewVM = StateObject(wrappedValue: AddNewViewModel())
    }
    
    init(word:Word) {
        _addNewVM = StateObject(wrappedValue: AddNewViewModel(word: word))
    }
    
    var body: some View {
        GeometryReader { geometry in
            VStack (alignment: .leading) {
                // audio text
                AudioTextView(placeHolder: "word", content: addNewVM.word.content, voiceAddr: addNewVM.word.voiceAddr) { transContent, voiceAddr in
                    addNewVM.wordRecordFinished(content: transContent, voiceAddr: voiceAddr)
                }.frame(maxWidth: .infinity).frame(height: UIConstant.btnWidth * 2)
                
                // word sentenceCard scrollView
                ScrollViewReader { value in
                    ScrollView(.horizontal, showsIndicators: true) {
                        LazyHStack {
                            ForEach(0..<self.addNewVM.wordSentenceCount,  id: \.self) { index in
                                VStack {
                                    SentenceRecordView(wordSentence:self.addNewVM.word.wordSentenceList[index])
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
                            addNewVM.addCardBtnClick()
                        }){
                            HStack {
                                Image("plus").resizable().frame(width:40,height: 40)
                                Text("add card")
                            }
                        }.buttonStyle(PlainButtonStyle()).frame(width:100,height: UIConstant.btnWidth,alignment: .leading).padding(10)
                        Spacer()
                    }.padding([.leading],10)

                    Button("cancel") {
#if os(iOS) || os(watchOS) || os(tvOS)
                        self.presentationMode.wrappedValue.dismiss()
#elseif os(macOS)
                        addNewVM.clean()
#endif
                    }.buttonStyle(BlueButtonStyle())
                        .frame(width:100, height:40)
                        .foregroundColor(.white)
                        .background(.blue)
                        .cornerRadius(10)
                        .padding([.leading,.trailing],10)

                    Button("commit") {
                        addNewVM.commitBtnClick()
                        showAlert = true
                    }.buttonStyle(BlueButtonStyle())
                        .frame(width:100, height:40)
                        .foregroundColor(.white)
                        .background(.blue)
                        .cornerRadius(10)
                        .padding([.leading,.trailing],10)
                    
                }.padding([.bottom], 10)
            }
        }.navigationTitle(addNewVM.title).environmentObject(addNewVM).alert(isPresented: $showAlert) {
            Alert(
                title: Text("success"),
                dismissButton: .default(Text("add new"), action: {
                    addNewVM.clean()
                })
            )
        }.onDisappear(perform: {
            addNewVM.clean()
        })
    }
}
