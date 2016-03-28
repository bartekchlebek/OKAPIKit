public enum AttributionAppendageMode: String {
	case Full = "full"
	case None = "none"
	case Static = "static"
}

extension AttributionAppendageMode: StringRepresentable {
	var stringValue: String {
		return self.rawValue
	}
}
