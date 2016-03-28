import Rosetta

public struct Log: JSONConvertible {
	public var UUID: String?
	public var cacheCode: String?
	public var date: NSDate?
	public var user: User?
	public var type: LogType?
	public var isOCTeamEntry: Bool?
	public var wasRecommended: Bool?
	public var needsMaintenance: Bool?
	public var isListingOutdated: Bool?
	public var comment: String?
	public var images: [Image]?
	public var internalID: String?

	public init() { }

	public static func map(inout object: Log, json: Rosetta) {
		object.UUID <~ json["uuid"]
		object.cacheCode <~ json["cache_code"]
		object.date <~ json["date"] ~ NSDateISO8601Bridge()
		object.user <~ json["user"]
		object.type <~ json["type"]
		object.isOCTeamEntry <~ json["oc_team_entry"]
		object.wasRecommended <~ json["was_recommended"]
		object.needsMaintenance <~ json["needs_maintenance2"]
		object.isListingOutdated <~ json["listing_is_outdated"]
		object.comment <~ json["comment"]
		object.images <~ json["images"]
		object.internalID <~ json["internal_id"]
	}
}