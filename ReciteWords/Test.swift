//
//  Test.swift
//  ReciteWords
//
//  Created by jake on 2024/3/31.
//

import Foundation
import SwiftUI

struct Test: View {

    @State private var array: [String] = []

    var body: some View {
        VStack {
            Button("click") {
                self.array.append("c")
            }
            ForEach(self.array, id: \.self) {string in
                Text(string)
            }
        }.onAppear { // Prefer, Life cycle method
            self.array.append("A")
            self.array.append("B")
            self.array.append("C")
        }
    }
}
