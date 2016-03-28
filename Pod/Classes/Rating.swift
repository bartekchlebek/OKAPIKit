import Rosetta

public struct Rating {
	public var value: Double {
		didSet {
			self.value = Rating.validatedValue(self.value)
		}
	}

	public init(_ value: Double) {
		self.value = Rating.validatedValue(value)
	}

	private static func validatedValue(value: Double) -> Double {
		return min(max(value, 1), 5)
	}
}

extension Rating: FloatLiteralConvertible {
	public init(floatLiteral value: FloatLiteralType) {
		self.value = value
	}
}

extension Rating: IntegerLiteralConvertible {
	public init(integerLiteral value: IntegerLiteralType) {
		self.value = Double(value)
	}
}

extension Rating: Comparable { }

public func ==(lhs: Rating, rhs: Rating) -> Bool {
	return lhs.value == rhs.value
}

public func <(lhs: Rating, rhs: Rating) -> Bool {
	return lhs.value < rhs.value
}

extension Rating: StringRepresentable {
	var stringValue: String {
		return String(Int(round(self.value)))
	}
}

extension Rating: Bridgeable {
	public static func bridge() -> Bridge<Rating, NSNumber> {
		return BridgeNumber(
			decoder: { Rating($0 as Double) },
			encoder: { $0.value	}
		)
	}
}