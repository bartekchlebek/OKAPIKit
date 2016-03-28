public enum LogsPerCacheCount {
	case Count(Int)
	case All
}

extension LogsPerCacheCount: IntegerLiteralConvertible {
	public init(integerLiteral value: IntegerLiteralType) {
		self = .Count(value)
	}
}

extension LogsPerCacheCount: StringRepresentable {
	var stringValue: String {
		switch self {
		case .All: return "all"
		case .Count(let count): return String(count)
		}
	}
}
