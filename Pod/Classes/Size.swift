import Rosetta

public enum Size: String {
	case None = "none"
	case Nano = "nano"
	case Micro = "micro"
	case Small = "small"
	case Regular = "regular"
	case Large = "large"
	case XLarge = "xlarge"
	case Other = "other"
}

extension Size: Bridgeable {
	public static func bridge() -> Bridge<Size, NSString> {
		return BridgeString(
			decoder: { Size.init(rawValue: $0 as String) },
			encoder: { $0.rawValue }
		)
	}
}
