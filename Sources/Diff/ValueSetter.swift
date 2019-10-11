infix operator ~

public struct DiffSetter<Root> {
    public let key: PartialKeyPath<Root>
    public let value: Value<Any>
}

public func ~<Root, Value>(keyPath: KeyPath<Root, Value>, value: Value) -> DiffSetter<Root> {
    return DiffSetter(key: keyPath, value: .update(value))
}
