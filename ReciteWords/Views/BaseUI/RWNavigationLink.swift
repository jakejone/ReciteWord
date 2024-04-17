//
//  RWNavigationLink.swift
//  ReciteWords
//
//  Created by jake on 2024/4/12.
//

import Foundation
import SwiftUI

struct RWNavigationLink<Label, Destination> : View where Label : View, Destination : View {
    
    var destination:Destination
    
    var label:Label
    
    /// Creates a navigation link that presents the destination view.
    /// - Parameters:
    ///   - destination: A view for the navigation link to present.
    ///   - label: A view builder to produce a label describing the `destination`
    ///    to present.
    public init(destination: Destination, @ViewBuilder label: () -> Label){
        self.destination = destination
        self.label = label()
    }
    
    var body: some View {
        NavigationLink(destination:self.destination ) {
            self.label
        }.buttonStyle(NavButtonStyle())
    }
}

struct NavButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(0)
            .font(.title)
            .foregroundColor(.white)
            .background(Color.clear)
            .cornerRadius(5)
    }
}

