import Rosetta
import MapKit

public struct Services_Caches_Geocaches: RequestWithResult {
	public var baseURLString: String
	public let path = "services/caches/geocaches"
	public let httpMethod = "GET"
	public var authenticationLevel: AuthenticationLevel {
		return max(.Level1, self.minimumAuthenticationLevelForCacheFields)
	}

	public var cacheCodes: [String]
	public var languagePreference: [String]?
	public var fields: [CacheField]?
	public var attributionAppendage: AttributionAppendageMode?
	public var logsPerCache: LogsPerCacheCount?
	public var logFields: [LogField]?
	public var myLocation: CLLocationCoordinate2D?
	public var userUUID: String?

	public var query: [String: String] {
		var query: [String: String] = [:]

		query["cache_codes"] = self.cacheCodes.joinWithSeparator("|")
		query["langpref"] = self.languagePreference?.joinWithSeparator("|")
		query["fields"] = self.fields?.map { $0.stringValue }.joinWithSeparator("|")
		query["attribution_append"] = self.attributionAppendage?.stringValue
		query["lpc"] = self.logsPerCache?.stringValue
		query["log_fields"] = self.logFields?.map { $0.stringValue }.joinWithSeparator("|")
		query["my_location"] = self.myLocation?.stringValue
		query["user_uuid"] = self.userUUID

		return query
	}

	public init(baseURLString: String, cacheCodes: [String]) {
		self.baseURLString = baseURLString
		self.cacheCodes = cacheCodes
	}

	public static func resultFromData(data: NSData) throws -> [String: Geocache] {
		return try Rosetta().decode(data)
	}

	private var minimumAuthenticationLevelForCacheFields: AuthenticationLevel {
		guard let fields = self.fields else { return .Level0 }
		let authenticationLevels = fields.map { $0.minimumAuthenticationLevel() }
		return authenticationLevels.reduce(AuthenticationLevel.Level0, combine: max)
	}
}

extension Services_Caches_Geocaches: RetrieveRequestType {}
