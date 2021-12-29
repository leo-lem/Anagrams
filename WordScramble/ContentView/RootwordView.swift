//
//  RootwordView.swift
//  WordScramble
//
//  Created by Leopold Lemmermann on 29.12.21.
//

import SwiftUI
import MyCustomUI

struct RootwordView: View {
    @Binding var newRootword: String
    @Binding var editingRootword: Bool
    
    let rootword: String, isFirst: Bool
    let newGame: (_ rootword: String) -> Void, nextWord: () -> Void, previousWord: () -> Void
    
    var body: some View {
        HStack {
            SymbolButton("chevron.left", previousWord)
                .font(.system(size: 20))
                .foregroundColor(isFirst || editingRootword ? .gray : .primary)
                .disabled(isFirst || editingRootword)
            
            if editingRootword {
                TextField("", text: $newRootword) {
                    if newRootword != rootword { self.newGame(newRootword) }
                    withAnimation { self.editingRootword = false }
                    self.focused = false
                }
                .font(.largeTitle)
                .fixedSize()
                .focused($focused)
                .task { focused = true }
                
            } else {
                Text(rootword).font(.largeTitle)
                    .onLongPressGesture {
                        self.newRootword = rootword
                        withAnimation { self.editingRootword = true }
                        self.focused = true
                    }
            }
            
            SymbolButton("chevron.right", nextWord)
                .font(.system(size: 20))
                .foregroundColor(editingRootword ? .gray : .primary)
                .disabled(editingRootword)
        }
    }
    
    @FocusState private var focused: Bool
}

struct RootwordView_Previews: PreviewProvider {
    static var previews: some View {
        RootwordView(newRootword: .constant("cowboy"),
                     editingRootword: .constant(true),
                     rootword: "silkworm",
                     isFirst: false) {_ in} nextWord: {} previousWord: {}
        .foregroundColor(.primary)
    }
}
