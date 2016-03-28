public enum FilterParameter<T> {
	case Include([T])
	case Exclude([T])

	var values: [T] {
		switch self {
		case let .Include(values): return values
		case let .Exclude(values): return values
		}
	}

	var shouldExclude: Bool {
		switch self {
		case .Include: return false
		case .Exclude: return true
		}
	}
}

extension FilterParameter: ArrayLiteralConvertible {
	public init(arrayLiteral elements: T...) {
		self = .Include(Array(elements))
	}
}

extension FilterParameter where T: StringRepresentable {
	var stringValue: String {
		return (self.shouldExclude ? "-" : "") + self.values.map { $0.stringValue }.joinWithSeparator("|")
	}
}
