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
        sentenceCount = wordSentence.sentencelist.count
    }
    
    
    func addSentenceBtnClick() {
        let sentence = Sentence(wsid: self.wordSentence.wsid)
        self.wordSentence.sentencelist.append(sentence)
        self.sentenceCount = self.wordSentence.sentencelist.count
    }
    
    func modifyMeaningContent(content:String) {
        wordSentence.wordDesc = content
    }
    
    func modifySentenceContent(sentence:Sentence, content:String) {
        sentence.content = content
    }
}
