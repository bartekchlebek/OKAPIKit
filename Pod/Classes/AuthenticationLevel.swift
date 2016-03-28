public enum AuthenticationLevel {
	case Level0
	case Level1
	case Level2
	case Level3
}

extension AuthenticationLevel: Comparable {
	private var integerValueForComparable: Int {
		switch self {
		case .Level0: return 0
		case .Level1: return 1
		case .Level2: return 2
		case .Level3: return 3
		}
	}
}

public func <(lhs: AuthenticationLevel, rhs: AuthenticationLevel) -> Bool {
	return lhs.integerValueForComparable < rhs.integerValueForComparable
}

public func ==(lhs: AuthenticationLevel, rhs: AuthenticationLevel) -> Bool {
	return lhs.integerValueForComparable == rhs.integerValueForComparable
}
