public enum OrderableCacheField: String {
	case Code = "code"
	case Name = "name"
	case Founds = "founds"
	case Recommendations = "rcmds"
	case RecommendationsRatio = "rcmds%"
}

extension OrderableCacheField: StringRepresentable {
	var stringValue: String {
		return self.rawValue
	}
}
