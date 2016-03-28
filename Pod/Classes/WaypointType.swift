import Rosetta

public enum WaypointType {
	case Parking
	case Path
	case Stage
	case PhysicalStage
	case VirtualStage
	case Final
	case POI
	case UserCoords
	case Other(String)

	init(stringValue: String) {
		switch stringValue {
		case "parking": self = .Parking
		case "path": self = .Path
		case "stage": self = .Stage
		case "physical-stage": self = .PhysicalStage
		case "virtual-stage": self = .VirtualStage
		case "final": self = .Final
		case "poi": self = .POI
		case "user-coords": self = .UserCoords
		default: self = .Other(stringValue)
		}
	}

	var stringValue: String {
		switch self {
		case .Parking: return "parking"
		case .Path: return "path"
		case .Stage: return "stage"
		case .PhysicalStage: return "physical-stage"
		case .VirtualStage: return "virtual-stage"
		case .Final: return "final"
		case .POI: return "poi"
		case .UserCoords: return "user-coords"
		case .Other(let string): return string
		}
	}
}

extension WaypointType: Bridgeable {
	public static func bridge() -> Bridge<WaypointType, NSString> {
		return BridgeString(
			decoder: { WaypointType(stringValue: $0 as String) },
			encoder: { $0.stringValue }
		)
	}
}