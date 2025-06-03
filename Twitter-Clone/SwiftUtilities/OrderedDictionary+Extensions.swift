import OrderedCollections

extension OrderedDictionary: @retroactive ExpressibleByArrayLiteral where Value: Identifiable, Key == Value.ID {
    
    @inlinable
    public init(arrayLiteral elements: Value...) {
        self.init(elements)
    }
}

extension OrderedDictionary {
    
    @inlinable
    init<C: Collection<Value>>(_ values: C) where Value: Identifiable, Key == Value.ID {
        self.init(minimumCapacity: values.count)
        for value in values { self[value.id] = value }
    }
}
