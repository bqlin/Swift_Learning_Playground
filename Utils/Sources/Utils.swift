import Foundation

public func getBufferAddress<T>(of array: [T]) -> String {
    return array.withUnsafeBufferPointer { buffer in
        String(describing: buffer.baseAddress!)
    }
}

public func getAddress<T>(of ptr: UnsafePointer<T>) -> String {
    return String(describing: ptr)
}
