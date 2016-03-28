public enum OrderedParameter<T> {
	case Ascending(T)
	case Descending(T)

	var value: T {
		switch self {
		case .Ascending(let value): return value
		case .Descending(let value): return value
		}
	}
}

extension OrderedParameter where T: StringRepresentable {
	var stringValue: String {
		let prefix: String
		switch self {
		case .Ascending: prefix = "+"
		case .Descending: prefix = "-"
		}
		return prefix + self.value.stringValue
	}
}
