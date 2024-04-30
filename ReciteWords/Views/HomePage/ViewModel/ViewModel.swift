//
//  ViewModel.swift
//  ReciteWords
//
//  Created by jake on 2024/4/1.
//

import Foundation
import SwiftUI

/*
 1. wordbanner card , wordSentence
 */

class ViewModel: ObservableObject {
    
    enum State {
        case idle
        case loaded
        case ringABell
        case noIdea
        case error(Error)
        
        var isError: Bool {
            switch self {
            case .error:
                return true
            default:
                return false
            }
        }
    }
    
    enum MemoryBtnState {
        case origin
        case gotoNext
    }
    
    enum SentenceState {
        case hidden
        case show
    }
    
    @Published private(set) var state = State.idle
    
    @Published private(set) var sentenceState = SentenceState.hidden
    
    @Published private(set) var memoryBtnState = MemoryBtnState.origin
    
    @Published var wordList:Array<Word> = loadData()
    
    @Published var scrollID: Int?
    
    var pageIndex = 0
    
    var wordService = WordService()
    
    private let audioPlayer = AudioPlayer()
    
    // voice play control
    var lastPlayWordID:UUID?
    
#if os(macOS)
    var operationList:Array<OpeRow> {
        get {
            var list = Array<OpeRow>()
            list.append(OpeRow(category: OpeRow.Category.Banner))
            list.append(OpeRow(category: OpeRow.Category.AddNew))
            list.append(OpeRow(category: OpeRow.Category.List))
            list.append(OpeRow(category: OpeRow.Category.Setting))
            return list
        }
    }
#endif
    
    func reload() {
        if let wordsFromDB = wordService.getHomeWordList() {
            wordList = wordsFromDB
        }
        state = .loaded
    }
    
    func markInMemory(word:Word ,memory:WordMemory) {
        word.markWordMemory(memory: memory)
        wordService.updateWord(word: word)
        
        switch memory {
        case .Gotcha:
            self.nextWord()
        case .RingABell:
            self.memoryBtnState = .gotoNext
            self.sentenceState = .show
        case .NoIdea:
            self.memoryBtnState = .gotoNext
            self.sentenceState = .show
        }
    }
    
    func nextWord() {
        self.wordBannerShowNext()
        self.memoryBtnState = .origin
        self.sentenceState = .hidden
    }
    
    private func wordBannerShowNext() {
        if scrollID != nil {
            scrollID! += 1
            if (scrollID! >= self.wordList.count) {
                self.reload()
                scrollID = 0
            }
        } else {
            scrollID = 1
        }
        
    }
    
    func playWord(word:Word) {
        self.playWord(word: word, force: false)
    }
    
    func playWord(word:Word, force:Bool) {
        
        if (lastPlayWordID == word.id && !force) {
            return
        }
        lastPlayWordID = word.id
        
        audioPlayer.playWithFileURL(fileURL: URL(fileURLWithPath: word.voiceAddr!)) {
            self.audioPlayer.speak(text: word.content!)
        }
    }
    
    func playSentence(sentence:Sentence) {
        audioPlayer.playWithFileURL(fileURL: URL(fileURLWithPath: sentence.voiceAddr!)) {
            self.audioPlayer.speak(text: sentence.content!)
        }
    }
    
    func playWordSentence(wordSentence:WordSentence) {
        audioPlayer.playWithFileURL(fileURL: URL(fileURLWithPath: wordSentence.wordDescVoiceAddr!)) {
            self.audioPlayer.speak(text: wordSentence.wordDesc!)
        }
    }
}

func loadData() -> Array<Word> {
    let wordService = WordService()
    return wordService.getHomeWordList()!
}
