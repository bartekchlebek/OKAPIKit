import Rosetta

public enum CacheType {
	case Traditional
	case Multi
	case Quiz
	case Virtual
	case Event
	case Custom(String)
}

extension CacheType: StringRepresentable {
	var stringValue: String {
		switch self {
		case .Traditional: return "Traditional"
		case .Multi: return "Multi"
		case .Quiz: return "Quiz"
		case .Virtual: return "Virtual"
		case .Event: return "Event"
		case .Custom(let string): return string
		}
	}
}

extension CacheType: Bridgeable {
	private init(stringValue: String) {
		switch stringValue {
		case "Traditional": self = .Traditional
		case "Multi": self = .Multi
		case "Quiz": self = .Quiz
		case "Virtual": self = .Virtual
		case "Event": self = .Event
		default: self = .Custom(stringValue)
		}
	}

	public static func bridge() -> Bridge<CacheType, NSString> {
		return BridgeString(
			decoder: { CacheType(stringValue: ($0 as String)) },
			encoder: { $0.stringValue	}
		)
	}
}
