//
//  Word.swift
//  Words
//
//  Created by jake on 2024/3/4.
//

import Foundation

enum WordMemory {
    case Gotcha
    case RingABell
    case NoIdea
}

class Word :Identifiable,ObservableObject {
    
    public let id:UUID
    
    public let date:Date
    
    @Published public var content:String?
    
    @Published public var voiceAddr:String?
    
    public var score = 0
    
    @Published public var wordSentenceList:Array<WordSentence>
    
    @Published var dataArray:Array<String> = Array()
    
    @Published var myDataList:Array<String> = Array()
    
    init(id: UUID = UUID(), date: Date = Date(), content: String, voiceAddr: String, wordSentenceList: Array<WordSentence>) {
        self.id = id
        self.date = date
        self.content = content
        self.voiceAddr = voiceAddr
        self.wordSentenceList = wordSentenceList
    }
    
    init(id: UUID = UUID(), date: Date = Date(), content: String, voiceAddr: String, score:Int) {
        self.id = id
        self.date = date
        self.content = content
        self.voiceAddr = voiceAddr
        self.score = score
        self.wordSentenceList = Array()
    }
    
    init(id: UUID = UUID(), date: Date = Date()) {
        self.id = id
        self.date = date
        self.wordSentenceList = Array()
    }
    
    func getAllVoiceList()  -> Array<String> {
        var voiceList = Array<String>()
        if let voice = voiceAddr {
            voiceList.append(voice)
        }
        
        for wordSentence in self.wordSentenceList {
            voiceList.append(wordSentence.wordDescVoiceAddr!)
            
            for sentence in wordSentence.sentencelist {
                voiceList.append(sentence.voiceAddr!)
            }
        }
        return voiceList
    }
    
    func markWordMemory(memory:WordMemory) {
        switch memory {
        case .Gotcha:
            self.score += 6
        case .RingABell:
            self.score += 3
        case .NoIdea:
            self.score += 1
        }
    }
    
    func cleanEmpty() {
        var emptyWordSentence = Array<WordSentence>()
        for wordSentence in wordSentenceList {
            if let content = wordSentence.wordDesc {
                if content.count < 1 {
                    emptyWordSentence.append(wordSentence)
                }
            } else {
                emptyWordSentence.append(wordSentence)
            }
        }
        
        if (emptyWordSentence.count > 0) {
            wordSentenceList = wordSentenceList.filter({item in !emptyWordSentence.contains(where: {$0.wsid == item.wsid})})
        }
        
        for wordSentence in wordSentenceList {
            wordSentence.cleanEmpty()
        }
    }
    
}

extension Word: Hashable {
    static func == (lhs: Word, rhs: Word) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
