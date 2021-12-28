//
//  TimerButtonView.swift
//  WordScramble
//
//  Created by Leopold Lemmermann on 28.12.21.
//

import SwiftUI

struct TimerButtonView: View {
    @Binding var enabled: Bool
    let timesUp: Bool
    
    var body: some View {
        Button {
            withAnimation { enabled.toggle() }
        } label: {
            Image(systemName: "timer")
        }
        .foregroundColor(enabled ? .primary : .gray)
        .disabled(!enabled && timesUp)
        .opacity(!enabled && timesUp ? 0.2 : 1)
    }
}

struct TimerButtonView_Previews: PreviewProvider {
    static var previews: some View {
        TimerButtonView(enabled: .constant(true), timesUp: true)
    }
}
