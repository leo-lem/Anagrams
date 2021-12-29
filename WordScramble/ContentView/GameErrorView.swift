//
//  GameErrorView.swift
//  WordScramble
//
//  Created by Leopold Lemmermann on 25.12.21.
//

import SwiftUI

struct GameErrorView: View {
    let error: GameError
    
    var body: some View {
        VStack {
            Text(title).font(.headline)
                
            Text(description).font(.footnote)
        }
        .padding(10)
        .frame(maxWidth: .infinity)
        .border(.foreground , width: 5)
        .cornerRadius(10)
        .padding(.horizontal)
    }
}

extension GameErrorView {
    private var title: String {
        var string = "title-"
        
        switch error.kind {
        case .rootNotReal: string += "rootNotReal %@"
        case .rootTooShort: string += "rootTooShort %@"
        case .halftime: string += "halftime"
        case .timesUp: string += "timesUp"
        case .isRoot: string += "isRoot %@"
        case .tooShort: string += "tooShort %@"
        case .notNew: string += "notNew %@"
        case .notPossible: string += "notPossible %@"
        case .notReal: string += "notReal %@"
        }
        
        let format = NSLocalizedString(string, comment: "")
        return String.localizedStringWithFormat(format, error.word ?? "")
    }
    
    private var description: String {
        var string = "desc-"
        
        switch error.kind {
        case .rootNotReal: string += "rootNotReal"
        case .rootTooShort: string += "rootTooShort"
        case .halftime: string += "halftime"
        case .timesUp: string += "timesUp"
        case .isRoot: string += "isRoot"
        case .tooShort: string += "tooShort"
        case .notNew: string += "notNew"
        case .notPossible: string += "notPossible"
        case .notReal: string += "notReal"
        }
        
        return NSLocalizedString(string, comment: "")
    }
}

struct CustomAlertView_Previews: PreviewProvider {
    static var previews: some View {
        GameErrorView(error: GameError(.notNew))
    }
}
