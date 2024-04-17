//
//  OperationCell.swift
//  MacReciteWords
//
//  Created by jake on 2024/4/13.
//

import Foundation
import SwiftUI

struct OperationCell : View {
    
    var operation:OpeRow
    
    var body: some View {
        HStack {
            Image(operation.image).resizable().aspectRatio(contentMode: .fill).frame(width: 20,height: 20)
            Text(operation.text)
            Spacer()
        }.frame(height: 30)
    }
}
