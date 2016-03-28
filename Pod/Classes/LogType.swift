import Rosetta

public enum LogType {
	case FoundIt
	case DidNotFindIt
	case Comment
	case WillAttend
	case Attended
	case TemporarilyUnavailable
	case ReadyToSearch
	case Archived
	case Locked
	case NeedsMaintenance
	case MaintenancePerformed
	case Moved
	case OCTeamComment
	case Other(String)

	var stringValue: String {
		switch self {
		case .FoundIt: return "Found It"
		case .DidNotFindIt: return "Didn't find it"
		case .Comment: return "Comment"
		case .WillAttend: return "Will attend"
		case .Attended: return "Attended"
		case .TemporarilyUnavailable: return "Temporarily unavailable"
		case .ReadyToSearch: return "Ready to search"
		case .Archived: return "Archived"
		case .Locked: return "Locked"
		case .NeedsMaintenance: return "Needs maintenance"
		case .MaintenancePerformed: return "Maintenance performed"
		case .Moved: return "Moved"
		case .OCTeamComment: return "OC Team comment"
		case .Other(let value): return value
		}
	}
}

extension LogType: Bridgeable {
	private init(stringValue: String) {
		switch stringValue {
		case "Found It": self = .FoundIt
		case "Didn't find it": self = .DidNotFindIt
		case "Comment": self = .Comment
		case "Will attend": self = .WillAttend
		case "Attended": self = .Attended
		case "Temporarily unavailable": self = .TemporarilyUnavailable
		case "Ready to search": self = .ReadyToSearch
		case "Archived": self = .Archived
		case "Locked": self = .Locked
		case "Needs maintenance": self = .NeedsMaintenance
		case "Maintenance performed": self = .MaintenancePerformed
		case "Moved": self = .Moved
		case "OC Team comment": self = .OCTeamComment
		default: self = .Other(stringValue)
		}
	}

	public static func bridge() -> Bridge<LogType, NSString> {
		return BridgeString(
			decoder: { LogType(stringValue: $0 as String) },
			encoder: { $0.stringValue }
		)
	}
}
