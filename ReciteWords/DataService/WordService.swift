//
//  WordService.swift
//  Words
//
//  Created by jake on 2024/3/20.
//

import Foundation



class WordService : NSObject {
    
    let kConfigDailyWordsCount        = "perDayWords"
    
    private var dataManager = WordDataManager()
    
    // save all the audio data，and clean it，at last
    private var tempVoiceList = Array<String>()
    
    override init() {
        super.init()
    }
    
    func getHomeWordList() ->Array<Word>? {
        var wordList:Array<Word>?
        do {
            wordList = try self.dataManager.fetchWordList()
        } catch {
            print("geet home word list error:\(error)")
        }
        return wordList
    }
    
    func getWordListOrderByAlphabetical() ->Array<Word>? {
        var wordList:Array<Word>?
        do {
            wordList = try self.dataManager.fetchWordListOrderByAlphabetical()
        } catch {
            print("geet home word list error:\(error)")
        }
        return wordList
    }
    
    func getWordListOrderByDate() ->Array<Word>? {
        var wordList:Array<Word>?
        do {
            wordList = try self.dataManager.fetchWordListOrderByDate()
        } catch {
            print("geet home word list error:\(error)")
        }
        return wordList
    }
    
    func markAudio(_ audioAddr:String) {
        tempVoiceList.append(audioAddr)
        print("ccurreent voicce count is : \(tempVoiceList.count)")
    }
    
    func cleanAudioData(voiceAddr:String) {
        do {
            try FileManager.default.removeItem(at: URL(filePath: voiceAddr))
        } catch {
            print(error)
        }
    }
    
    func updateWord(word:Word) {
        do {
            try self.dataManager.addOrUpdateWord(word:word)
        } catch {
            print(error)
        }
    }
    
    // 提交当前的，并清空
    func confirmAddNewWord(newWord:Word) {
        let wordVoicelist = newWord.getAllVoiceList()
        // clean audio data
        for voice in tempVoiceList {
            if !wordVoicelist.contains([voice]) {
                print("clean voice:\(voice)")
                self.cleanAudioData(voiceAddr: voice)
            }
        }
        
        do {
            // 1. save word
            try self.dataManager.addOrUpdateWord(word:newWord)
            
            // 2. save wordSentence
            self.dataManager.addWordSentence(wordSentenceList: newWord.wordSentenceList)
            
            // 3. save sentence
            for wordSentence in newWord.wordSentenceList {
                self.dataManager.addSentencelist(sentencelist: wordSentence.sentencelist)
            }
        } catch {
            print(error)
        }
        tempVoiceList.removeAll()
    }
    
    func cancelAddNewWord() {
        for voice in tempVoiceList {
            self.cleanAudioData(voiceAddr: voice)
        }
        tempVoiceList.removeAll()
    }
    
    func cleanExtraVoiceData() {
        do {
            let wordlist = try dataManager.fetchWordList()
            
            var allVoiceFile = Array<String>()
            
            for word in wordlist {
                let voiceUrl = URL(filePath: word.voiceAddr!)
                allVoiceFile.append(voiceUrl.lastPathComponent)
                for wordSentence in word.wordSentenceList {
                    let wsVoiceUrl = URL(filePath: wordSentence.wordDescVoiceAddr!)
                    allVoiceFile.append(wsVoiceUrl.lastPathComponent)
                    for sentence in wordSentence.sentencelist {
                        let sVoiceUrl = URL(filePath: sentence.voiceAddr!)
                        allVoiceFile.append(sVoiceUrl.lastPathComponent)
                    }
                }
            }
            
            
            let voiceDataDir = dataManager.getVoiceDir()
            
            let fileManager = FileManager.default
            
            let items = try fileManager.contentsOfDirectory(atPath: voiceDataDir)
            
            // Filter only files (excluding directories)
            let files = items.filter { item in
                print("item name is : \(item)")
                if (allVoiceFile.contains(item)) {
                    return false
                } else {
                    return true
                }
            }
            
            for removeItem in files {
                let removeItemPath = voiceDataDir + "/" + removeItem
                try fileManager.removeItem(atPath: removeItemPath)
            }
            
        } catch {
            print(error)
        }
    }
    
    // MARK: count per day words
    func countPerDayWords() -> Int {
        let config = self.readConfig()
        let dailyConfigCountString = config[kConfigDailyWordsCount]!
        let dailyConfigCount = Int(dailyConfigCountString)
        let today = Date()
        // today left
        let count = self.dataManager.countWordsByDate(date: today)
        
        return dailyConfigCount! - count
    }
    
    
    func getStatisticDataByDate() -> Array<WordStatistic> {
        do {
            return try dataManager.staticWordsByDate()
        } catch {
            print(error)
        }
        return Array()
    }
    
    func getConfigPath() -> String {
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
        
        let destPath = destinationDir + "jjword.config"
        return destPath
    }
    
    func readConfig() -> Dictionary<String,String> {
        let configPath = self.getConfigPath()
        let fileManager = FileManager.default
        if !fileManager.fileExists(atPath: configPath) {
            do {
                var defaultConfig = Dictionary<String, String>()
                defaultConfig[kConfigDailyWordsCount] = "10"
                
                let jsonData = try JSONSerialization.data(withJSONObject: defaultConfig, options: [])
                try jsonData.write(to: URL(fileURLWithPath: configPath))
                
                return defaultConfig
            } catch {
                print(error)
            }
        }
        var dictionary:Dictionary<String,String> = Dictionary()
        do {
            let fileData = try Data(contentsOf: URL(fileURLWithPath: configPath))
            dictionary = try JSONSerialization.jsonObject(with: fileData, options: []) as! Dictionary<String, String>
        } catch {
            print(error)
        }
        
        return dictionary
    }
    
    func updateConfig(config:Dictionary<String, String>) {
        let configPath = self.getConfigPath()
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: config, options: [])
            try jsonData.write(to: URL(fileURLWithPath: configPath))
        } catch {
            print(error)
        }
    }
}
