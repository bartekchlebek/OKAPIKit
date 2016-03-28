public enum IgnoredStatus {
	case IgnoredOnly
	case NotIgnoredOnly
	case Either
}

extension IgnoredStatus {
	var stringValue: String {
		switch self {
		case .IgnoredOnly: return "ignored_only"
		case .NotIgnoredOnly: return "notignored_only"
		case .Either: return "either"
		}
	}
}
