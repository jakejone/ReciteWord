//
//  WordDataManager.swift
//  Words
//
//  Created by jake on 2024/3/5.
//

import Foundation
import SQLite

class WordDataManager {
    
    private var db: Connection!
    
    // word table
    private let t_wordTable = Table("word")
    private let tw_uuid = Expression<String>("uuid")
    private let tw_date = Expression<Date>("date")
    private let tw_content = Expression<String>("content")
    private let tw_voiceAddr = Expression<String>("voiceAddr")
    private let tw_score = Expression<Int>("score")
    
    // word - sentencec
    private let t_wordSentenceTable = Table("wordSentence")
    private let tws_wsid = Expression<String>("wsid")
    private let tws_wordid = Expression<String>("wordid")
    private let tws_wordDesc = Expression<String>("wordDesc")
    private let tws_wordDescVoice = Expression<String>("wordDescVoice")
    
    // sentence
    private let t_sentenceTable = Table("sentence")
    private let ts_sid = Expression<String>("sid")
    private let ts_wsid = Expression<String>("wsid")
    private let ts_sContent = Expression<String>("content")
    private let ts_sVoiceAddr = Expression<String>("voiceAddr")
    
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
        let wordSquence = try db.prepare(t_wordTable.order(tw_score.asc,tw_date.desc))
        return try self.fetchWordList(wordSquence: wordSquence)
    }
    
    func fetchWordListOrderByAlphabetical() throws ->Array<Word> {
        let wordSquence = try db.prepare(t_wordTable.order(tw_content.asc))
        return try self.fetchWordList(wordSquence: wordSquence)
    }
    
    func fetchWordList(wordSquence:AnySequence<Row>) throws -> Array<Word> {
        var wordList = Array<Word>()
        do {
            for word in wordSquence {
                let voiceLastComponent = word[tw_voiceAddr]
                let voiceAddr = self.generateVoiceAddr(lastComponent: voiceLastComponent)
                let wordObj = Word(id: UUID(uuidString:word[tw_uuid])!,
                                   date: word[tw_date],
                                   content: word[tw_content],
                                   voiceAddr: voiceAddr,
                                   score: word[tw_score])
                
                for ws in try db.prepare(t_wordSentenceTable.filter(tws_wordid == wordObj.id.uuidString)) {
                    let wsVoiceLastComponent = ws[tws_wordDescVoice]
                    let wsVoiceAddr = self.generateVoiceAddr(lastComponent: wsVoiceLastComponent)
                    
                    let wsObj = WordSentence(wordid: wordObj.id,
                                             wsid: UUID(uuidString: ws[tws_wsid])!,
                                             wordDesc: ws[tws_wordDesc],
                                             wordDescVoiceAddr: wsVoiceAddr,
                                             sentencelist: Array<Sentence>())
                    wordObj.wordSentenceList.append(wsObj)
                    
                    for sentence in try db.prepare(t_sentenceTable.filter(ts_wsid == wsObj.wsid.uuidString)) {
                        let sVoiceLastComponent = sentence[ts_sVoiceAddr]
                        let sVoiceAddr = self.generateVoiceAddr(lastComponent: sVoiceLastComponent)
                        
                        let sObj = Sentence(sid: UUID(uuidString: sentence[ts_sid])!,
                                            wsid: wsObj.wsid,
                                            content: sentence[ts_sContent],
                                            voiceAddr: sVoiceAddr)
                        wsObj.sentencelist.append(sObj)
                    }
                }
                wordList.append(wordObj)
            }
        } catch {
            print(error)
        }
        return wordList
    }
    
    
    
    func addOrUpdateWord(word:Word) throws {
        let voice = URL(filePath: word.voiceAddr!).lastPathComponent
        let insert = t_wordTable.upsert(tw_uuid <- word.id.uuidString,
                                        tw_date <- word.date,
                                        tw_content <- word.content!,
                                        tw_voiceAddr <- voice,
                                        tw_score <- word.score,
                                        onConflictOf: tw_uuid)
        try db.run(insert)
        
    }
    
    func addWordSentence(wordSentenceList:Array<WordSentence>) {
        do {
            for wordSentence in wordSentenceList {
                let voice = URL(filePath: wordSentence.wordDescVoiceAddr!).lastPathComponent
                let insert = t_wordSentenceTable.upsert(tws_wsid  <- wordSentence.wsid.uuidString,
                                                        tws_wordid <- wordSentence.wordid.uuidString,
                                                        tws_wordDesc <- wordSentence.wordDesc!,
                                                        tws_wordDescVoice <- voice,
                                                        onConflictOf: tws_wsid)
                try db.run(insert)
            }
            
        } catch {
            print(error)
        }
    }
    
    func addSentencelist(sentencelist:Array<Sentence>) {
        do {
            for sentence in sentencelist {
                let voice = URL(filePath: sentence.voiceAddr!).lastPathComponent
                let insert = t_sentenceTable.upsert(ts_sid <- sentence.sid.uuidString,
                                                    ts_wsid <- sentence.wsid.uuidString,
                                                    ts_sContent <- sentence.content!,
                                                    ts_sVoiceAddr <- voice,
                                                    onConflictOf: ts_sid)
                try db.run(insert)
            }
        } catch {
            print(error)
        }
    }
    
    // MARK: count daily words
    func countWordsByDate(date:Date) -> Int {
        var count = 0
        do {
            let (startOfDay,endOfDay) = DateUtil.getStartAndEndOfDate(date: date)
            count = try db.scalar(t_wordTable.filter(tw_date > startOfDay && tw_date < endOfDay).count)
            print("count is \(count)")
        } catch {
            print(error)
        }
        return count
    }
    
    // MARK: - create table
    private func createWordTable() throws {
        try db.run(t_wordTable.create (ifNotExists:true) { t in
            t.column(tw_uuid, primaryKey: true)
            t.column(tw_date)
            t.column(tw_content)
            t.column(tw_voiceAddr)
            t.column(tw_score)
        })
    }
    
    private func createWordSentenceTable() throws {
        try db.run(t_wordSentenceTable.create (ifNotExists:true) { t in
            t.column(tws_wsid, primaryKey: true)
            t.column(tws_wordid)
            t.column(tws_wordDesc)
            t.column(tws_wordDescVoice)
        })
    }
    
    private func createSentenceTable() throws {
        try db.run(t_sentenceTable.create (ifNotExists:true) { t in
            t.column(ts_sid, primaryKey: true)
            t.column(ts_wsid)
            t.column(ts_sContent)
            t.column(ts_sVoiceAddr)
        })
    }
    
    // MARK: - Statistic
    
    func staticWordsByDate() throws -> Array<WordStatistic> {
        var result = Array<WordStatistic>()
        
        let dateArray = DateUtil.getAHundredDateArray()
        
        do {
            for (start,end) in dateArray {
                let count = try db.scalar(t_wordTable.filter(tw_date > start && tw_date < end).count)
                print("count is \(count)")
                let dateString = DateUtil.transDateToDayString(date: end)
                result.append(WordStatistic(dateString: dateString, count: String(count)))
            }
        } catch {
            print(error)
        }
        
        return result
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
    
    func generateVoiceAddr(lastComponent:String) -> String {
        let voiceDataDir = self.getVoiceDir()
        if FileManager.default.fileExists(atPath: voiceDataDir) == false {
            do {
                try FileManager.default.createDirectory(at: URL(filePath: voiceDataDir), withIntermediateDirectories: false)
            } catch {
                print(error)
            }
        }
        return voiceDataDir + lastComponent
    }
    
    func getVoiceDir() -> String {
        let documents = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        let voiceDataDir = documents + "/wordData/voiceData/"
        return voiceDataDir
    }
}
