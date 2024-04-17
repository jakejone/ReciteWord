//
//  AddNewViewModel.swift
//  ReciteWords
//
//  Created by jake on 2024/4/17.
//

import Foundation

class AddNewViewModel : ObservableObject {
    
    @Published private var voiceRecordFinish = false
    
    @Published var word:Word
    
    @Published var wordSentenceCount = 0
    
    var wordService = WordService()
    var isUpdate = false
    
    var title = "record to generate content"
    
    init() {
        let newWord = Word()
        self.word = newWord
        self.title = "add new"
    }
    
    init(word:Word) {
        self.word = word
        self.title = "update"
    }
    
    func clean() {
        let newWord = Word()
        self.word = newWord
        wordSentenceCount = 0
    }
    
    func wordRecordFinished(content:String?, voiceAddr:String?) {
        self.word.content = content
        self.word.voiceAddr = voiceAddr
        if let address = voiceAddr {
            wordService.markAudio(address)
        }
    }
    
    func meaningRecordFinished(wordSentence:WordSentence, content:String?, voiceAddr:String?) {
        wordSentence.wordDesc = content
        wordSentence.wordDescVoiceAddr = voiceAddr
        if let address = voiceAddr {
            wordService.markAudio(address)
        }
    }
    
    func sentenceRecordFinished(sentence:Sentence, content:String?, voiceAddr:String?) {
        sentence.content = content
        sentence.voiceAddr = voiceAddr
        if let address = voiceAddr {
            wordService.markAudio(address)
        }
    }
    
    func addCardBtnClick() {
        let newWordSentence = WordSentence(wordid: self.word.id)
        self.word.wordSentenceList.append(newWordSentence)
        wordSentenceCount = self.word.wordSentenceList.count
    }
    
    func addSentenceBtnClick(wordSentence:WordSentence) {
        let sentence = Sentence(wsid: wordSentence.wsid)
        wordSentence.sentencelist.append(sentence)
    }
    
    func commitBtnClick() {
        self.wordService.confirmAddNewWord(newWord: self.word)
    }
    
}
