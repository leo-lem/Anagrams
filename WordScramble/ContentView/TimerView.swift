//
//  TimerView.swift
//  WordScramble
//
//  Created by Leopold Lemmermann on 25.12.21.
//

import SwiftUI
import MyCustomUI

struct TimerView: View {
    @Binding var enabled: Bool
    var time: Double, limit: Double
    
    private var remaining: Double { limit - time }
    private var timeUp: Bool { time >= limit}
    
    var body: some View {
        HStack {
            Text(remaining == 1 ? "\(remaining.formatted()) second" : "\(remaining.formatted()) seconds")
                .hidden(!enabled)
                .animation(.default, value: enabled)
            
            Button {
                withAnimation { enabled.toggle() }
            } label: {
                Image(systemName: "timer")
            }
            .foregroundColor(enabled ? .primary : .gray)
            .disabled(timeUp)
            .opacity(timeUp ? 0.1 : 1)
        }
        .font(.headline)
    }
}

struct TimerView_Previews: PreviewProvider {
    static var previews: some View {
        TimerView(enabled: .constant(true), time: 10, limit: 300)
    }
}
