import Rosetta

public enum CacheStatus: String {
	case Available = "Available"
	case TemporarilyUnavailable = "Temporarily unavailable"
	case Archived = "Archived"
}

extension CacheStatus: Bridgeable {
	public static func bridge() -> Bridge<CacheStatus, NSString> {
		return BridgeString(
			decoder: { CacheStatus(rawValue: ($0 as String)) },
			encoder: { $0.rawValue	}
		)
	}
}
