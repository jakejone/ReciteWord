//
//  RWColor.swift
//  ReciteWords
//
//  Created by jake on 2024/4/12.
//

import Foundation
import SwiftUI

struct RWColor {
    
    static var backgroundColor : Color {
        get {
#if os(iOS) || os(watchOS) || os(tvOS)
            return Color(UIColor.systemBackground)
#elseif os(macOS)
            return Color(NSColor.windowBackgroundColor)
#endif
        }
    }
    
    static var secondaryBgColor : Color {
        get {
#if os(iOS) || os(watchOS) || os(tvOS)
            return Color(UIColor.secondarySystemBackground)
#elseif os(macOS)
            return Color(NSColor.underPageBackgroundColor)
#endif
        }
    }
    
    static var thirdBgColor : Color {
        get {
#if os(iOS) || os(watchOS) || os(tvOS)
            return Color(UIColor.tertiarySystemBackground)
#elseif os(macOS)
            return Color(NSColor.controlBackgroundColor)
#endif
        }
    }
    
    
    
}
