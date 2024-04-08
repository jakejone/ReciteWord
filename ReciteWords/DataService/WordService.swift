//
//  WordService.swift
//  Words
//
//  Created by jake on 2024/3/20.
//

import Foundation

class WordService : NSObject {
    
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
}
