extension Diff: Decodable where T: Decodable {
    public init(from decoder: Decoder) throws {
        try self.init()

        let container = try decoder.container(keyedBy: Key.self)
        try self.reflector.properties.forEach { property in
            guard let decodable = property.type as? Decodable.Type else { return }
            guard let key = Key(stringValue: property.name) else { return }

            do {
                let single = try container.superDecoder(forKey: key)
                let value = try decodable.init(from: single)
                self.values[property.name] = .update(value)
            }
            catch DecodingError.keyNotFound { }
            catch DecodingError.valueNotFound { }
        }
    }
}

extension Diff: Encodable where T: Encodable {
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: Key.self)

        try self.values.forEach { string, value in
            guard let key = Key(stringValue: string) else { return }
            guard case let .update(value) = value.cast(to: Encodable.self) else { return }

            let single = container.superEncoder(forKey: key)
            try value.encode(to: single)
        }
    }
}

extension Diff {
    internal struct Key: CodingKey {
        var stringValue: String
        var intValue: Int?

        init?(stringValue: String) {
            self.stringValue = stringValue
            self.intValue = Int(stringValue)
        }

        init?(intValue: Int) {
            self.stringValue = String(intValue)
            self.intValue = intValue
        }
    }
}
