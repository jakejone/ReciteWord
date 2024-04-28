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
    var wordService = WordService()
    
    enum OrderType {
        case Score
        case Alphabetical
    }
    
    init(orderType:OrderType) {
        switch orderType {
        case .Score:
            let words = wordService.getHomeWordList()
            _wordList = State(initialValue: words!)
        case .Alphabetical:
            let words = wordService.getWordListOrderByAlphabetical()
            _wordList = State(initialValue: words!)
        }
    }
    
    var body: some View {
        Table(wordList) {
            TableColumn("Word", value: \.content!)
            TableColumn("Score") { word in
                Text("\(word.score)")
            }
        }
    }
}

