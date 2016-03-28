public struct Services_OAuth_Authorize: Request {
	public var baseURLString: String
	public let path = "services/oauth/authorize"
	public let httpMethod = "GET"
	public let authenticationLevel = AuthenticationLevel.Level0

	public var oauthToken: String
	public var interactivity: Interactivity?
	public var languagePreferences: [String]?

	public var query: [String: String] {
		var query: [String: String] = [:]
		query["oauth_token"] = self.oauthToken
		query["interactivity"] = self.interactivity?.stringValue
		query["langpref"] = self.languagePreferences?.joinWithSeparator("|")
		return query
	}

	public init(baseURLString: String, oauthToken: String, interactivity: Interactivity? = nil, languagePreferences: [String]? = nil) {
		self.baseURLString = baseURLString
		self.oauthToken = oauthToken
		self.interactivity = interactivity
		self.languagePreferences = languagePreferences
	}

	public enum Result {
		case Authorized(oauthToken: String, oauthVerifier: String)
		case Denied(oauthToken: String, error: String)

		public init(string: String) throws {
			guard let url = NSURL(string: string) else { throw defaultError }
			guard let queryString = url.query else { throw defaultError }

			let query = try queryString.query()
			guard let oauthToken = query["oauth_token"] else { throw defaultError }

			if let oauthVerifier = query["oauth_verifier"] {
				self = .Authorized(oauthToken: oauthToken, oauthVerifier: oauthVerifier)
			}
			else if let error = query["error"] {
				self = .Denied(oauthToken: oauthToken, error: error)
			}
			else {
				throw defaultError
			}
		}
	}
}

extension Services_OAuth_Authorize.Result: Equatable { }

public func ==(lhs: Services_OAuth_Authorize.Result, rhs: Services_OAuth_Authorize.Result) -> Bool {
	switch (lhs, rhs) {
	case (let .Authorized(oauthTokenA, oauthVerifierA), let .Authorized(oauthTokenB, oauthVerifierB)):
		return oauthTokenA == oauthTokenB && oauthVerifierA == oauthVerifierB
	case (let .Denied(oauthTokenA, errorA), let .Denied(oauthTokenB, errorB)):
		return oauthTokenA == oauthTokenB && errorA == errorB
	default:
		return false
	}
}
