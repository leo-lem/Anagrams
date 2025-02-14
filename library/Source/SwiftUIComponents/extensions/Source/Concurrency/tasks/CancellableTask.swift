//	Created by Leopold Lemmermann on 14.11.22.

// providing a common ancestor for different task types
public protocol CancellableTask {
  func cancel()
}

extension CancellableTask where Self == Task<Void, Never> {
  func cancel() { self.cancel() }
}

extension CancellableTask where Self == Task<Void, Error> {
  func cancel() { self.cancel() }
}

extension Task: CancellableTask {}
