//
//  TimerView.swift
//  WordScramble
//
//  Created by Leopold Lemmermann on 25.12.21.
//

import SwiftUI
import MyCustomUI

struct TimerView: View {
    @Binding var time: Double
    var limit: Double
    
    private var remaining: Double { limit - time }
    private var timesUp: Bool { time >= limit-0.1 }
    
    let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("\(remaining.formatted())")
                .onReceive(timer) { input in
                    if !self.timesUp {
                        self.time += timer.upstream.interval
                    } else {
                        self.time = self.limit
                    }
                }
            Text(remaining == 1 ? "second" : "seconds").font(.caption2)
        }
    }
}

struct TimerView_Previews: PreviewProvider {
    static var previews: some View {
        TimerView(time: .constant(10), limit: 300)
    }
}
