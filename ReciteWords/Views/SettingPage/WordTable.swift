//
//  WordTable.swift
//  ReciteWords
//
//  Created by jake on 2024/4/6.
//

import Foundation
import SwiftUI

struct WordTable : View {
    
    @State var wordList:Array<Word>
    
    @State var title = ""
    
    var wordService = WordService()
    
    enum OrderType {
        case Score
        case Alphabetical
    }
    
    var showWordHandler:(Word) -> Void
    
    init(orderType:OrderType, showWordHandler:@escaping (Word)->()) {
        var count = 0
        switch orderType {
        case .Score:
            let words = wordService.getHomeWordList()
            count = words!.count
            _wordList = State(initialValue: words!)
        case .Alphabetical:
            let words = wordService.getWordListOrderByAlphabetical()
            count = words!.count
            _wordList = State(initialValue: words!)
        }
        _title = State(initialValue: "all words : " + String(count))
        self.showWordHandler = showWordHandler
    }
    
    var body: some View {
        Table(wordList) {
            TableColumn("Word") {word in
                Button(action: {
                    self.showWordHandler(word)
                }, label: {
                    Text("\(word.content!)").frame(maxWidth: .infinity,maxHeight: .infinity,alignment: .leading).contentShape(Rectangle())
                })
            }
            TableColumn("Score") { word in
                Text("\(word.score)")
            }
        }.navigationTitle(self.title)
    }
}

