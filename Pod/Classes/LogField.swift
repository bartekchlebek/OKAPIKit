public enum LogField: String {
	case UUID = "uuid"
	case CacheCode = "cache_code"
	case Date = "date"
	case User = "user"
	case Type = "type"
	case OCTeamEntry = "oc_team_entry"
	case WasRecommended = "was_recommended"
	case NeedsMaintenance = "needs_maintenance2"
	case ListingIsOutdated = "listing_is_outdated"
	case Comment = "comment"
	case Images = "images"
	case InternalID = "internal_id"
}

extension LogField: StringRepresentable {
	var stringValue: String {
		return self.rawValue
	}
}
