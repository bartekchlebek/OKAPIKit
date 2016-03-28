import Rosetta

public enum Bearing {
	case N
	case NNE
	case NE
	case ENE
	case E
	case ESE
	case SE
	case SSE
	case S
	case SSW
	case SW
	case WSW
	case W
	case WNW
	case NW
	case NNW
}

extension Bearing: Bridgeable {
	private init?(stringValue: String) {
		switch stringValue {
		case "N": self = .N
		case "NNE": self = .NNE
		case "NE": self = .NE
		case "ENE": self = .ENE
		case "E": self = .E
		case "ESE": self = .ESE
		case "SE": self = .SE
		case "SSE": self = .SSE
		case "S": self = .S
		case "SSW": self = .SSW
		case "SW": self = .SW
		case "WSW": self = .WSW
		case "W": self = .W
		case "WNW": self = .WNW
		case "NW": self = .NW
		case "NNW": self = .NNW
		default: return nil
		}
	}

	private var stringValue: String {
		switch self {
		case .N: return "N"
		case .NNE: return "NNE"
		case .NE: return "NE"
		case .ENE: return "ENE"
		case .E: return "E"
		case .ESE: return "ESE"
		case .SE: return "SE"
		case .SSE: return "SSE"
		case .S: return "S"
		case .SSW: return "SSW"
		case .SW: return "SW"
		case .WSW: return "WSW"
		case .W: return "W"
		case .WNW: return "WNW"
		case .NW: return "NW"
		case .NNW: return "NNW"
		}
	}

	public static func bridge() -> Bridge<Bearing, NSString> {
		return BridgeString(
			decoder: { Bearing(stringValue: ($0 as String)) },
			encoder: { $0.stringValue	}
		)
	}
}
