//
//  TimerView.swift
//  WordScramble
//
//  Created by Leopold Lemmermann on 25.12.21.
//

import SwiftUI

struct TimerView: View {
    @Binding var time: Int
    var limit: Int
    
    private var remaining: Int { limit - time }
    private var timesUp: Bool { time >= limit }
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("\(remaining)")
                .onReceive(timer) { input in
                    if !self.timesUp {
                        self.time += Int(timer.upstream.interval)
                    } else {
                        self.time = self.limit
                    }
                }
            Text(remaining == 1 ? "second-label" : "seconds-label").font(.caption2)
        }
        .foregroundColor(timesUp ? .red : .primary)
    }
}

struct TimerView_Previews: PreviewProvider {
    static var previews: some View {
        TimerView(time: .constant(10), limit: 300)
    }
}
