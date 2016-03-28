public enum Amount {
	case Absolute(Int)
	case Proportional(Int)
}

extension Amount: StringRepresentable {
	var stringValue: String {
		switch self {
		case .Absolute(let amount): return amount.stringValue
		case .Proportional(let amount): return "%" + amount.stringValue
		}
	}
}

extension Amount: IntegerLiteralConvertible {
	public init(integerLiteral value: IntegerLiteralType) {
		self = .Absolute(value)
	}
}
