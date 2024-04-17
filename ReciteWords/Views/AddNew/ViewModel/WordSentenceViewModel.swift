//
//  WordSentenceViewModel.swift
//  ReciteWords
//
//  Created by jake on 2024/4/17.
//

import Foundation

class WordSentenceViewModel : ObservableObject {
    
    @Published var wordSentence:WordSentence
    
    @Published var sentenceCount = 0
    
    init(wordSentence: WordSentence) {
        self.wordSentence = wordSentence
    }
    
    func addSentenceBtnClick() {
        let sentence = Sentence(wsid: self.wordSentence.wsid)
        self.wordSentence.sentencelist.append(sentence)
        self.sentenceCount = self.wordSentence.sentencelist.count
    }
}
