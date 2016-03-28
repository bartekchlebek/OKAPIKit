public enum Interactivity {
	case Minimal
	case ConfirmUser

	var stringValue: String {
		switch self {
		case .Minimal: return "minimal"
		case .ConfirmUser: return "confirm_user"
		}
	}
}
