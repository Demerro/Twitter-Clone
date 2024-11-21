extension Sequence {
    
    public func min<T>(by closure: (Element) throws -> T) rethrows -> Element? where T: Comparable {
        let tuples = try self.lazy.map({ (element: $0, value: try closure($0)) })
        let minimum = tuples.min(by: { $0.value < $1.value })
        return minimum?.element
    }
}
