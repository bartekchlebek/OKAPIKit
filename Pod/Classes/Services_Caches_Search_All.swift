import Rosetta

public struct Services_Caches_Search_All: RequestWithResult {
	public var baseURLString: String
	public let path = "services/caches/search/all"
	public let httpMethod = "GET"
	public var authenticationLevel: AuthenticationLevel {
		get {
			if (self.foundStatus != nil || self.watchedOnly != nil || self.ignoredStatus != nil || self.excludeMyOwn != nil) {
				return .Level3
			}
			return .Level1
		}
	}

	public var types: FilterParameter<CacheType>?
	public var statuses: [CacheStatus]?
	public var ownerUUIDs: FilterParameter<String>?
	public var name: String?
	public var terrain: ClosedInterval<Rating>?
	public var difficulty: ClosedInterval<Rating>?
	public var sizes: [Size]?
	public var rating: RatingParameter?
	public var minimumRecommendations: Amount?
	public var minimumFounds: Int?
	public var maximumFounds: Int?
	public var modifiedSince: NSDate?
	public var foundStatus: FoundStatus? // Level 3 Authentication required
	public var foundBy: [String]?
	public var notFoundBy: [String]?
	public var watchedOnly: Bool? // Level 3 Authentication required
	public var ignoredStatus: IgnoredStatus?
	public var excludeMyOwn: Bool? // Level 3 Authentication required
	public var withTrackablesOnly: Bool?
	public var ftfHunter: Bool?
	public var powertrailOnly: Bool?
	public var powertrailIDs: [String]?
	public var setAnd: String?
	public var limit: Int?
	public var offset: Int?
	public var orderBy: [OrderedParameter<OrderableCacheField>]?

	public var query: [String: String] {
		var query: [String: String] = [:]

		query["type"] = self.types?.stringValue
		query["status"] = self.statuses?.flatMap { $0.rawValue }.joinWithSeparator("|")
		query["owner_uuid"] = self.ownerUUIDs?.stringValue
		query["name"] = self.name
		query["terrain"] = self.terrain?.stringValue
		query["difficulty"] = self.difficulty?.stringValue
		query["size2"] = self.sizes?.map { $0.rawValue }.joinWithSeparator("|")
		query["rating"] = self.rating?.stringValue
		query["min_rcmds"] = self.minimumRecommendations?.stringValue
		query["min_founds"] = self.minimumFounds.map(String.init)
		query["max_founds"] = self.maximumFounds.map(String.init)
		query["modified_since"] = self.modifiedSince?.ISO8601String
		query["found_status"] = self.foundStatus?.rawValue
		query["found_by"] = self.foundBy?.joinWithSeparator("|")
		query["notfound_by"] = self.notFoundBy?.joinWithSeparator("|")
		query["watched_only"] = self.watchedOnly?.stringValue
		query["ignored_status"] = self.ignoredStatus?.stringValue
		query["exclude_my_own"] = self.excludeMyOwn?.stringValue
		query["with_trackables_only"] = self.withTrackablesOnly?.stringValue
		query["ftf_hunter"] = self.ftfHunter?.stringValue
		query["powertrail_only"] = self.powertrailOnly?.stringValue
		query["powertrail_ids"] = self.powertrailIDs?.joinWithSeparator("|")
		query["set_and"] = self.setAnd
		query["limit"] = self.limit.map(String.init)
		query["offset"] = self.offset.map(String.init)
		query["order_by"] = self.orderBy?.map { $0.stringValue }.joinWithSeparator("|")

		return query
	}

	public init(baseURLString: String) {
		self.baseURLString = baseURLString
	}

	public static func resultFromData(data: NSData) throws -> Result {
		return try Rosetta().decode(data)
	}

	public struct Result: JSONConvertible {
		public var results: [Geocache] = []
		public var more: Bool = false

		public init() { }

		public static func map(inout object: Result, json: Rosetta) {
			object.results <- json["results"]
			object.more <- json["more"]
		}
	}
}

extension Services_Caches_Search_All: SearchRequestType {}
