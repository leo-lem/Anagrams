//
//  PersistentData-Protocol.swift
//  WordScramble
//
//  Created by Leopold Lemmermann on 28.12.21.
//

import Foundation

protocol PersistentStorage {
    func save() -> Void
    func load() -> Void
}
