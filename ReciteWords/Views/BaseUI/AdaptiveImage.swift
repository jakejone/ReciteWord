//
//  AdaptiveView.swift
//  ReciteWords
//
//  Created by jake on 2024/4/7.
//

import Foundation
import SwiftUI

struct AdaptiveImage: View {
    @Environment(\.colorScheme) var colorScheme
    let light: Image
    let dark: Image

    @ViewBuilder var body: some View {
        if colorScheme == .light {
            light
        } else {
            dark
        }
    }
}
