//
//  Word.swift
//  Words
//
//  Created by jake on 2024/3/4.
//

import Foundation

class Word :Identifiable {

    public let id:UUID
    
    public let date:Date
    
    public var content:String?
    
    public var voiceAddr:String?
    
    public var wordSentenceList:Array<WordSentence>
    
    init(id: UUID = UUID(), date: Date = Date(), content: String, voiceAddr: String, wordSentenceList: Array<WordSentence>) {
        self.id = id
        self.date = date
        self.content = content
        self.voiceAddr = voiceAddr
        self.wordSentenceList = wordSentenceList
    }
    
    init(id: UUID = UUID(), date: Date = Date(), content: String, voiceAddr: String) {
        self.id = id
        self.date = date
        self.content = content
        self.voiceAddr = voiceAddr
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
    
}
