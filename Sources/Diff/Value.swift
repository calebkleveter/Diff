public enum Value<T> {
    case unchanged
    case update(T)

    internal func cast<U>(to type: U.Type = U.self) -> Value<U>? {
        switch self {
        case .unchanged: return .unchanged
        case let .update(value): return (value as? U).map(Value<U>.update)
        }
    }

    public func map<To>(_ handler: (T) throws -> To) rethrows -> Value<To> {
        switch self {
        case .unchanged: return .unchanged
        case let .update(value): return try .update(handler(value))
        }
    }

    public func flatMap<To>(_ handler: (T) throws -> Value<To>) rethrows -> Value<To> {
        switch self {
        case .unchanged: return .unchanged
        case let .update(value): return try handler(value)
        }
    }
}
