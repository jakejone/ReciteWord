//
//  WordDate.swift
//  ReciteWords
//
//  Created by jake on 2024/5/6.
//

import Foundation
import SwiftUI

struct WordDateTable : View {
    
    @State var statistics:Array<WordStatistic>
    
    @State var title = ""
    
    var wordService = WordService()
    
    init() {
        let dateStatistic = wordService.getStatisticDataByDate()
        title = "statistic data"
        _statistics = State(initialValue: dateStatistic)
    }
    
    var body: some View {
        Table(statistics) {
            TableColumn("Date", value: \.dateString)
            TableColumn("Count", value: \.count)
        }.navigationTitle(self.title)
    }
}

class WordStatistic:Identifiable {
    
    var dateString:String
    var count:String
    
    init(dateString: String, count: String) {
        self.dateString = dateString
        self.count = count
    }
}
