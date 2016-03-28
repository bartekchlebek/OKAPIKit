public enum CacheField: String {
	case Code = "code"
	case Name = "name"
	case Names = "names"
	case Location = "location"
	case Type = "type"
	case Status = "status"
	case URL = "url"
	case Owner = "owner"
	case GCCode = "gc_code"
	case Distance = "distance"
	case Bearing = "bearing"
	case Bearing2 = "bearing2"
	case Bearing3 = "bearing3"
	case IsFound = "is_found"
	case IsNotFound = "is_not_found"
	case IsWatched = "is_watched"
	case IsIgnored = "is_ignored"
	case Founds = "founds"
	case NotFounds = "notfounds"
	case WillAttends = "willattends"
	case Size = "size2"
	case OXSize = "oxsize"
	case Difficulty = "difficulty"
	case Terrain = "terrain"
	case TripTime = "trip_time"
	case TripDistance = "trip_distance"
	case Rating = "rating"
	case RatingVotes = "rating_votes"
	case Recommendations = "recommendations"
	case RequiresPassword = "req_passwd"
	case ShortDescription = "short_description"
	case ShortDescriptions = "short_descriptions"
	case Description = "description"
	case Descriptions = "descriptions"
	case Hint = "hint2"
	case Hints = "hints2"
	case Images = "images"
	case PreviewImage = "preview_image"
	case AttributeCodes = "attr_acodes"
	case AttributeNames = "attrnames"
	case AttributionNote = "attribution_note"
	case LatestLogs = "latest_logs"
	case MyNotes = "my_notes"
	case TrackablesCount = "trackables_count"
	case Trackables = "trackables"
	case AlternativeWaypoints = "alt_wpts"
	case Country = "country"
	case State = "state"
	case ProtectionAreas = "protection_areas"
	case LastFound = "last_found"
	case LastModified = "last_modified"
	case DateCreated = "date_created"
	case DateHidden = "date_hidden"
	case InternalID = "internal_id"
}

extension CacheField: StringRepresentable {
	var stringValue: String {
		return self.rawValue
	}
}

extension CacheField {
	public static var allCases: [CacheField] {
		return [
			.IsFound,
			.IsNotFound,
			.IsWatched,
			.MyNotes,
			.IsIgnored,
			.Code,
			.Name,
			.Names,
			.Location,
			.Type,
			.Status,
			.URL,
			.Owner,
			.GCCode,
			.Distance,
			.Bearing,
			.Bearing2,
			.Bearing3,
			.Founds,
			.NotFounds,
			.WillAttends,
			.Size,
			.OXSize,
			.Difficulty,
			.Terrain,
			.TripTime,
			.TripDistance,
			.Rating,
			.RatingVotes,
			.Recommendations,
			.RequiresPassword,
			.ShortDescription,
			.ShortDescriptions,
			.Description,
			.Descriptions,
			.Hint,
			.Hints,
			.Images,
			.PreviewImage,
			.AttributeCodes,
			.AttributeNames,
			.AttributionNote,
			.LatestLogs,
			.TrackablesCount,
			.Trackables,
			.AlternativeWaypoints,
			.Country,
			.State,
			.ProtectionAreas,
			.LastFound,
			.LastModified,
			.DateCreated,
			.DateHidden,
			.InternalID
		]
	}
}

extension CacheField {
	func minimumAuthenticationLevel() -> AuthenticationLevel {
		switch self {
		case IsFound: fallthrough
		case IsNotFound: fallthrough
		case IsWatched: fallthrough
		case MyNotes: fallthrough
		case IsIgnored: return .Level3

		case Code: fallthrough
		case Name: fallthrough
		case Names: fallthrough
		case Location: fallthrough
		case Type: fallthrough
		case Status: fallthrough
		case URL: fallthrough
		case Owner: fallthrough
		case GCCode: fallthrough
		case Distance: fallthrough
		case Bearing: fallthrough
		case Bearing2: fallthrough
		case Bearing3: fallthrough
		case Founds: fallthrough
		case NotFounds: fallthrough
		case WillAttends: fallthrough
		case Size: fallthrough
		case OXSize: fallthrough
		case Difficulty: fallthrough
		case Terrain: fallthrough
		case TripTime: fallthrough
		case TripDistance: fallthrough
		case Rating: fallthrough
		case RatingVotes: fallthrough
		case Recommendations: fallthrough
		case RequiresPassword: fallthrough
		case ShortDescription: fallthrough
		case ShortDescriptions: fallthrough
		case Description: fallthrough
		case Descriptions: fallthrough
		case Hint: fallthrough
		case Hints: fallthrough
		case Images: fallthrough
		case PreviewImage: fallthrough
		case AttributeCodes: fallthrough
		case AttributeNames: fallthrough
		case AttributionNote: fallthrough
		case LatestLogs: fallthrough
		case TrackablesCount: fallthrough
		case Trackables: fallthrough
		case AlternativeWaypoints: fallthrough
		case Country: fallthrough
		case State: fallthrough
		case ProtectionAreas: fallthrough
		case LastFound: fallthrough
		case LastModified: fallthrough
		case DateCreated: fallthrough
		case DateHidden: fallthrough
		case InternalID: return .Level1
		}
	}
}
