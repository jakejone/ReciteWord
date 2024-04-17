//
//  RWButtonStyles.swift
//  ReciteWords
//
//  Created by jake on 2024/4/17.
//

import Foundation
import SwiftUI

struct BlueButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .foregroundColor(configuration.isPressed ? Color.white.opacity(0.6) : Color.white)
            .background(configuration.isPressed ? Color.blue.opacity(0.6) : Color.blue)
            .cornerRadius(6.0)
            .padding()
            .contentShape(Rectangle())
    }
}

struct OrangeButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .foregroundColor(configuration.isPressed ? Color.white.opacity(0.6) : Color.white)
            .background(configuration.isPressed ? Color.orange.opacity(0.6) : Color.orange)
            .cornerRadius(6.0)
            .padding()
            .contentShape(Rectangle())
    }
}
