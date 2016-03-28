private func StringRepresentationOfQuery(query: [String: String]) -> String {
	let keyValuePairs = query.map { "\"\($0)\":\"\($1)\"" }.sort(<)
	return "{" + keyValuePairs.joinWithSeparator(",") + "}"
}

public struct Services_Caches_Shortcuts_SearchAndRetreive
	<SearchRequest: SearchRequestType, RetrieveRequest: RequestWithResult
where RetrieveRequest: RetrieveRequestType>: RequestWithResult {

	public var baseURLString: String
	public let path = "services/caches/shortcuts/search_and_retrieve"
	public let httpMethod = "GET"
	public var authenticationLevel: AuthenticationLevel {
		get {
			return max(self.searchRequest.authenticationLevel, self.retrieveRequest.authenticationLevel)
		}
	}

	public var searchRequest: SearchRequest
	public var retrieveRequest: RetrieveRequest
	public var wrap: Bool

	public var query: [String: String] {
		var query: [String: String] = [:]

		var retrieveRequestQuery = self.retrieveRequest.query
		retrieveRequestQuery["cache_codes"] = nil

		query["search_method"] = self.searchRequest.path
		query["search_params"] = StringRepresentationOfQuery(self.searchRequest.query)
		query["retr_method"] = self.retrieveRequest.path
		query["retr_params"] = StringRepresentationOfQuery(retrieveRequestQuery)
		query["wrap"] = self.wrap.stringValue

		return query
	}

	public init(baseURLString: String, searchRequest: SearchRequest, retrieveRequest: RetrieveRequest, wrap: Bool) {
		self.baseURLString = baseURLString
		self.searchRequest = searchRequest
		self.retrieveRequest = retrieveRequest
		self.wrap = wrap
	}

	public static func resultFromData(data: NSData) throws -> RetrieveRequest.Result {
		return try RetrieveRequest.resultFromData(data)
	}
}
