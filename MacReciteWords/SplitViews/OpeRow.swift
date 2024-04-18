//
//  OpeRows.swift
//  MacReciteWords
//
//  Created by jake on 2024/4/13.
//

import Foundation
import SwiftUI

struct OpeRow : Identifiable{
    
    enum Category {
        case Banner
        case AddNew
        case Setting
    }
    
    let id = UUID()
    
    var category:Category
    var image:String {
        get {
            switch category {
            case .Banner:
                return "words"
            case .AddNew:
                return "plus"
            case .Setting:
                return "settings"
            }
        }
    }
    
    var text:String {
        get {
            switch category {
            case .Banner:
                return "Words"
            case .AddNew:
                return "Add new"
            case .Setting:
                return "Setting"
            }
        }
    }
}

extension OpeRow: Hashable {
    static func == (lhs: OpeRow, rhs: OpeRow) -> Bool {
        lhs.category == rhs.category
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(category)
    }
}

