//
//  SplitViewVM.swift
//  ReciteWords
//
//  Created by jake on 2024/5/8.
//

import Foundation
import SwiftUI

class SplitViewVM: ObservableObject {
    
    var jumpShowWord:Word?
    
#if os(macOS)
    var operationList:Array<OpeRow> {
        get {
            var list = Array<OpeRow>()
            list.append(OpeRow(category: OpeRow.Category.Banner))
            list.append(OpeRow(category: OpeRow.Category.AddNew))
            list.append(OpeRow(category: OpeRow.Category.List))
            list.append(OpeRow(category: OpeRow.Category.Setting))
            return list
        }
    }
#endif
    
}
