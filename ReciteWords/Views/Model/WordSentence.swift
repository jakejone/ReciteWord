//
//  Sentence.swift
//  Words
//
//  Created by jake on 2024/3/4.
//

import Foundation

class WordSentence : ObservableObject {
    
    public var wordid:UUID
    
    public var wsid:UUID
    
    public var wordDesc:String?
    
    public var wordDescVoiceAddr:String?
    
    public var sentencelist:Array<Sentence>
    
    init(wordid: UUID , wsid: UUID = UUID(), wordDesc: String? = nil, wordDescVoiceAddr: String? = nil, sentencelist: Array<Sentence>) {
        self.wordid = wordid
        self.wsid = wsid
        self.wordDesc = wordDesc
        self.wordDescVoiceAddr = wordDescVoiceAddr
        self.sentencelist = sentencelist
    }
    
    init(wordid:UUID, wsid:UUID = UUID()) {
        self.wordid = wordid
        self.wsid = wsid
        self.sentencelist = Array()
    }
    
    func cleanEmpty() {
        var emptySentence = Array<Sentence>()
        for sentence in sentencelist {
            if let content = sentence.content {
                if content.count < 1 {
                    emptySentence.append(sentence)
                }
            } else {
                emptySentence.append(sentence)
            }
        }
        
        if (emptySentence.count > 0) {
            sentencelist = sentencelist.filter({item in !emptySentence.contains(where: {$0.sid == item.sid})})
        }
    }
}

class Sentence :Identifiable {
    
    public var sid:UUID
    
    public var wsid:UUID
    
    public var content:String?
    
    public var voiceAddr:String?
    
    init(sid: UUID = UUID(), wsid: UUID) {
        self.sid = sid
        self.wsid = wsid
    }
    
    init(sid: UUID = UUID(), wsid: UUID, content:String ,voiceAddr:String) {
        self.sid = sid
        self.wsid = wsid
        self.content = content
        self.voiceAddr = voiceAddr
    }
    
    var id : String {sid.uuidString}
}
