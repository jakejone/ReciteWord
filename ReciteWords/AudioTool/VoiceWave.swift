//
//  VoiceWave.swift
//  Words
//
//  Created by jake on 2024/3/15.
//

import Foundation
import SwiftUI

struct VoiceView : View {
    
    let barHeight = 15.0
    @State private var drawingHeight = true
    
    var animation: Animation {
        return .linear(duration: 0.5).repeatForever()
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                bar(low: 0.1)
                    .animation(animation.speed(1.5), value: drawingHeight)
                bar(low: 0.2)
                    .animation(animation.speed(1.2), value: drawingHeight)
                bar(low: 0.3)
                    .animation(animation.speed(1.0), value: drawingHeight)
                bar(low: 0.4)
                    .animation(animation.speed(1.7), value: drawingHeight)
                bar(low: 0.2)
                    .animation(animation.speed(1.4), value: drawingHeight)
            }
            .onAppear{
                drawingHeight.toggle()
            }
        }
    }
    
    func bar(low: CGFloat = 0.0, high: CGFloat = 1.0) -> some View {
        RoundedRectangle(cornerRadius: 3)
            .fill(.indigo.gradient)
            .frame(height: (drawingHeight ? high : low) * barHeight)
            .frame(height: barHeight, alignment: .center)
    }
}

#Preview {
    VoiceView()
}
