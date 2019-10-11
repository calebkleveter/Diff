import KeyPathReflector

@dynamicMemberLookup
public struct Diff<T> {
    internal var values: [String: Value<Any>]
    internal let reflector: KeyPathReflector<T>

    public init(_ type: T.Type = T.self) throws {
        self.reflector = try KeyPathReflector()
        self.values = [:]
    }

    public init(_ values: [DiffSetter<T>]) throws {
        try self.init(T.self)
        values.forEach { setter in
            guard let key = self.reflector.property(for: setter.key)?.name else { return }
            self.values[key] = setter.value
        }
    }

    public subscript <V>(dynamicMember keyPath: KeyPath<T, V>) -> Value<V> {
        get {
            guard let key = self.reflector.property(for: keyPath)?.name else { return .unchanged }
            return self.values[key].flatMap { value in
                value.cast(to: V.self)
            } ?? .unchanged
        }

        set {
            if let key = self.reflector.property(for: keyPath)?.name {
                self.values[key] = newValue.cast()
            }
        }
    }

    public func apply(to model: inout T) throws {
        try self.values.forEach { key, value in
            guard case let .update(new) = value else { return }
            guard let property = self.reflector.properties.first(where: { $0.name == key }) else { return }
            try property.set(value: new, on: &model)
        }
    }
}
