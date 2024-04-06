//
//  ViewModel.swift
//  ReciteWords
//
//  Created by jake on 2024/4/1.
//

import Foundation

/*
 1. wordbanner card , wordSentence
 */

class ViewModel: ObservableObject {
    /**
     WordBanner state：
     1. loading, very quick
     2. displaying
     3. GotCha to next
     4. ring a bell to show centence and show next btn
     5. no idea to show centence and show next btn
     6.
     */
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
    
    @Published var wordList:Array<Word> = []
    
    @Published var scrollID: Int?
    
    var wordService = WordService()
    
    private let audioPlayer = AudioPlayer()
    
    // voice play control
    var lastPlayWordID:UUID?
    
    func reload() {
        if let wordsFromDB = wordService.getHomeWordList(pageIndex: 0) {
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
