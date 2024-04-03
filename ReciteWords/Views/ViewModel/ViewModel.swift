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
    
    
    @Published private(set) var state = State.idle
    
    @Published private(set) var memoryBtnState = MemoryBtnState.origin
    
    @Published var wordList:Array<Word> = []
    
    @Published var scrollID: Int?
    
    var wordService = WordService()
    
    
    func reload() {
        if let wordsFromDB = wordService.getHomeWordList(pageIndex: 0) {
            wordList = wordsFromDB
        }
        state = .loaded
    }
    
    func markInMemory(memory:WordMemory) {
        switch memory {
        case .Gotcha:
            self.nextWord()
        case .RingABell:
            // TODO : sentence state
            self.memoryBtnState = .gotoNext
        case .NoIdea:
            // TODO : sentence state
            self.memoryBtnState = .gotoNext
        }
    }
    
    func nextWord() {
        self.wordBannerShowNext()
        self.memoryBtnState = .origin
    }
    
    private func wordBannerShowNext() {
        if scrollID != nil {
            scrollID! += 1
        } else {
            scrollID = 1
        }
    }
    
    
}
