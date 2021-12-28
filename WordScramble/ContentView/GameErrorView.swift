//
//  GameErrorView.swift
//  WordScramble
//
//  Created by Leopold Lemmermann on 25.12.21.
//

import SwiftUI

struct GameErrorView: View {
    let title: String, description: String
    
    var body: some View {
        VStack {
            Text(title)
                .font(.headline)
                
            Text(description)
        }
        .padding(5)
        .frame(maxWidth: .infinity)
        .border(.foreground , width: 5)
        .cornerRadius(10)
        .padding(.horizontal)
    }
}

struct CustomAlertView_Previews: PreviewProvider {
    static var previews: some View {
        GameErrorView(title: "Hello mon", description: "This is not what you should do!")
    }
}
