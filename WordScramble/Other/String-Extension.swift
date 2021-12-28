//
//  StringExtension.swift
//  WordScramble
//
//  Created by Leopold Lemmermann on 27.12.21.
//

import SwiftUI

extension String {
    public enum MutatingError: Error {
        case noMatch
    }
    
    public mutating func removeFirst(where expression: (Self.Element) -> Bool) throws {
        if let index = self.firstIndex(where: expression) {
            self.remove(at: index)
        } else {
            throw MutatingError.noMatch
        }
    }
    
    public mutating func removeFirst(char: String.Element) throws {
        if let index = self.firstIndex(of: char) {
            self.remove(at: index)
        } else {
            throw MutatingError.noMatch
        }
    }
    
    public func checkIfContained(subword: String) -> Bool {
        var word = self
        
        do {
            for char in subword {
                try word.removeFirst(char: char)
            }
            return true
        } catch {
            return false
        }
    }
    
    public func checkIfReal(language: String) -> Bool {
        let checker = UITextChecker(), range = NSRange(location: 0, length: self.utf16.count)
        
        let misspelledRange = checker.rangeOfMisspelledWord(in: self, range: range, startingAt: 0,
                                                            wrap: false, language: language)
        
        return misspelledRange.location == NSNotFound
    }
}
