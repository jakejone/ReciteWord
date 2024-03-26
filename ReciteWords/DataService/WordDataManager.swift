//
//  WordDataManager.swift
//  Words
//
//  Created by jake on 2024/3/5.
//

import Foundation
import SQLite

class WordDataManager {
    
    var db: Connection!
    
    // word table
    let t_wordTable = Table("word")
    let tw_uuid = Expression<String>("uuid")
    let tw_date = Expression<Date>("date")
    let tw_content = Expression<String>("content")
    let tw_voiceAddr = Expression<String>("voiceAddr")
    
    // word - sentencec
    let t_wordSentenceTable = Table("wordSentence")
    let tws_wsid = Expression<String>("wsid")
    let tws_wordid = Expression<String>("wordid")
    let tws_wordDesc = Expression<String>("wordDesc")
    let tws_wordDescVoice = Expression<String>("wordDescVoice")
    
    // sentence
    let t_sentenceTable = Table("sentence")
    let ts_sid = Expression<String>("sid")
    let ts_wsid = Expression<String>("wsid")
    let ts_sContent = Expression<String>("content")
    let ts_sVoiceAddr = Expression<String>("voiceAddr")
    
    static let shared = WordDataManager()
    
    init() {
        do {
            let destPath = self.getDBPath()
            self.db = try Connection(destPath)
            
            try self.createWordTable()
            try self.createWordSentenceTable()
            try self.createSentenceTable()
            
        } catch {
            print(" error is : \(error).")
        }
    }
   
    // MARK: - CRUD
    func fetchWordList() throws ->Array<Word> {
        var wordList = Array<Word>()
        do {
            for word in try db.prepare(t_wordTable) {
                let word = Word(id: UUID(uuidString:word[tw_uuid])!,
                                    date: word[tw_date],
                                    content: word[tw_content],
                                    voiceAddr: word[tw_voiceAddr])
                wordList.append(word)
            }
        } catch {
            print(error)
        }
        return wordList
    }
    
    func addNewWord(word:Word) throws {
        let insert = t_wordTable.insert(tw_uuid <- word.id.uuidString,
                                        tw_date <- word.date,
                                        tw_content <- word.content!,
                                        tw_voiceAddr <- word.voiceAddr!)
        try db.run(insert)
        
    }
    
    func addWordSentence(wordSentenceList:Array<WordSentence>) {
        do {
            for wordSentence in wordSentenceList {
                let insert = t_wordSentenceTable.insert(tws_wsid  <- wordSentence.wsid.uuidString,
                                                        tws_wordid <- wordSentence.wordid.uuidString,
                                                        tws_wordDesc <- wordSentence.wordDesc!,
                                                        tws_wordDescVoice <- wordSentence.wordDescVoiceAddr!)
                try db.run(insert)
            }

        } catch {
            print(error)
        }
    }
    
    func addSentencelist(sentencelist:Array<Sentence>) {
        do {
            for sentence in sentencelist {
                let insert = t_sentenceTable.insert(ts_sid <- sentence.sid.uuidString,
                                                    ts_wsid <- sentence.wsid.uuidString,
                                                    ts_sContent <- sentence.content!,
                                                    ts_sVoiceAddr <- sentence.voiceAddr!)
                try db.run(insert)
            }
        } catch {
            print(error)
        }
    }
    
    // MARK: - create table
    func createWordTable() throws {
       try db.run(t_wordTable.create (ifNotExists:true) { t in
            t.column(tw_uuid, primaryKey: true)
            t.column(tw_date)
            t.column(tw_content)
            t.column(tw_voiceAddr)
        })
    }
    
    func createWordSentenceTable() throws {
        try db.run(t_wordSentenceTable.create (ifNotExists:true) { t in
            t.column(tws_wordid)
            t.column(tws_wsid)
            t.column(tws_wordDesc)
            t.column(tws_wordDescVoice)
        })
    }
    
    func createSentenceTable() throws {
        try db.run(t_sentenceTable.create (ifNotExists:true) { t in
            t.column(ts_sid, primaryKey: true)
            t.column(ts_wsid)
            t.column(ts_sContent)
            t.column(ts_sVoiceAddr)
        })
    }
    
    // MARK: - helper
    
    func getDBPath() -> String {
        let documents = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        let destinationDir = documents + "/wordData/"
        
        let fileManager = FileManager.default
        if !fileManager.fileExists(atPath: destinationDir) {
            do {
              try fileManager.createDirectory(atPath: destinationDir, withIntermediateDirectories: false)
            } catch {
                print(error)
            }
        }
        
        let destPath = destinationDir + "jjword.db"
        return destPath
    }
    
}
