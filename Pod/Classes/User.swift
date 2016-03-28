import Rosetta
import MapKit

public struct User: JSONConvertible {
	var UUID: String?
	var username: String?
	var profileURL: NSURL?
	var isAdmin: Bool?
	var internalID: String?
	var dateRegistered: NSDate?
	var cachesFoundCount: Int?
	var cachesNotFoundCount: Int?
	var cachesHiddenCount: Int?
	var recommendationsGivenCount: Int?
	var homeLocation: CLLocationCoordinate2D?

	public init() { }

	public static func map(inout object: User, json: Rosetta) {
		object.UUID <~ json["uuid"]
		object.username <~ json["username"]
		object.profileURL <~ json["profile_url"] ~ NSURLBridge
		object.isAdmin <~ json["is_admin"]
		object.internalID <~ json["internal_id"]
		object.dateRegistered <~ json["date_registered"] ~ NSDateISO8601Bridge()
		object.cachesFoundCount <~ json["caches_found"]
		object.cachesNotFoundCount <~ json["caches_notfound"]
		object.cachesHiddenCount <~ json["caches_hidden"]
		object.recommendationsGivenCount <~ json["rcmds_given"]
		object.homeLocation <~ json["home_location"]
	}
}
