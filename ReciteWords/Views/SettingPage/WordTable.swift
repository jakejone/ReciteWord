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
    init() {
        let words = wordService.getHomeWordList()
        _wordList = State(initialValue: words!)
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

