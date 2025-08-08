// Created by Leopold Lemmermann on 07.08.25.

public struct CKClient: Sendable {
  public var share: @MainActor (SharedGame) async -> Void
  public var fetchTop: @MainActor (_ limit: Int) async -> [SharedGame]
  public var delete: @MainActor (SharedGame) async -> Void
  public var isAvailable: @MainActor () async -> Bool
}
