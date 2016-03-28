import Rosetta
import MapKit

public struct Geocache: JSONConvertible {
	public var code: String?
	public var name: String?
	public var names: [String: String]?
	public var location: CLLocationCoordinate2D?
	public var type: CacheType?
	public var status: CacheStatus?
	public var needsMaintenance: Bool?
	public var URL: NSURL?
	public var owner: User?
	public var geocachingCode: String?
	public var distance: Double?
	public var bearing: Double?
	public var bearing2: Bearing?
	public var bearing3: Bearing?
	public var isFound: Bool?
	public var isNotFound: Bool?
	public var isWatched: Bool?
	public var isIgnored: Bool?
	public var foundsCount: Int?
	public var notFoundsCount: Int?
	public var willAttendsCount: Int?
	public var size: Size?
	public var oxSize: Rating?
	public var difficulty: Rating?
	public var terrain: Rating?
	public var tripTime: NSTimeInterval?
	public var tripDistance: Double?
	public var rating: Rating?
	public var ratingVotesCount: Int?
	public var recommendationsCount: Int?
	public var requiresPassword: Bool?
	public var shortDescription: String?
	public var description: String?
	public var descriptions: [String: String]?
	public var hint: String?
	public var hints: [String: String]?
	public var images: [Image]?
	public var previewImage: Image?
	public var attributeCodes: String?
	public var attributeNames: [String]?
	public var attributionNote: String?
	public var latesLogs: [Log]?
	public var myNotes: String?
	public var trackablesCount: Int?
	public var trackables: [Trackable]?
	public var alternateWaypoints: [Waypoint]?
	public var country: String?
	public var state: String?
	public var protectionAreas: [ProtectionArea]?
	public var lastFoundDate: NSDate?
	public var lastModifiedDate: NSDate?
	public var creationDate: NSDate?
	public var hidingDate: NSDate?
	public var internalID: String?

	public init() { }

	public static func map(inout object: Geocache, json: Rosetta) {
//		let start = CFAbsoluteTimeGetCurrent()
//		defer { print(CFAbsoluteTimeGetCurrent() - start) }
		object.code <~ json["code"]
		object.name <~ json["name"]
		object.names <~ json["names"]
		object.location <~ json["location"]
		object.type <~ json["type"]
		object.status <~ json["status"]
		object.needsMaintenance <~ json["needs_maintenance"]
		object.URL <~ json["url"] ~ NSURLBridge
		object.owner <~ json["owner"]
		object.geocachingCode <~ json["gc_code"]
		object.distance <~ json["distance"]
		object.bearing <~ json["bearing"]
		object.bearing2 <~ json["bearing2"]
		object.bearing3 <~ json["bearing3"]
		object.isFound <~ json["is_found"]
		object.isNotFound <~ json["is_not_found"]
		object.isWatched <~ json["is_watched"]
		object.isIgnored <~ json["is_ignored"]
		object.foundsCount <~ json["founds"]
		object.notFoundsCount <~ json["notfounds"]
		object.willAttendsCount <~ json["willattends"]
		object.size <~ json["size2"]
		object.oxSize <~ json["oxSize"]
		object.difficulty <~ json["difficulty"]
		object.terrain <~ json["terrain"]
		object.tripTime <~ json["trip_time"]
		object.tripDistance <~ json["trip_distance"]
		object.rating <~ json["rating"]
		object.ratingVotesCount <~ json["rating_votes"]
		object.recommendationsCount <~ json["recommendations"]
		object.requiresPassword <~ json["req_passwd"]
		object.shortDescription <~ json["short_description"]
		object.description <~ json["description"]
		object.descriptions <~ json["descriptions"]
		object.hint <~ json["hint2"]
		object.hints <~ json["hints2"]
		object.images <~ json["images"]
		object.previewImage <~ json["preview_image"]
		object.attributeCodes <~ json["attr_acodes"]
		object.attributeNames <~ json["attrnames"]
		object.attributionNote <~ json["attribution_note"]
		object.latesLogs <~ json["latest_logs"]
		object.myNotes <~ json["my_notes"]
		object.trackablesCount <~ json["trackables_count"]
		object.trackables <~ json["trackables"]
		object.alternateWaypoints <~ json["alt_wpts"]
		object.country <~ json["country"]
		object.state <~ json["state"]
		object.protectionAreas <~ json["protection_areas"]
		object.lastFoundDate <~ json["last_found"] ~ NSDateISO8601Bridge()
		object.lastModifiedDate <~ json["last_modified"] ~ NSDateISO8601Bridge()
		object.creationDate <~ json["date_created"] ~ NSDateISO8601Bridge()
		object.hidingDate <~ json["date_hidden"] ~ NSDateISO8601Bridge()
		object.internalID <~ json["internal_id"]
	}
}
