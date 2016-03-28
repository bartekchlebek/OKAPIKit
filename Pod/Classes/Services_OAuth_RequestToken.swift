public struct Services_OAuth_RequestToken: Request {
	public var baseURLString: String
	public let path = "services/oauth/request_token"
	public let httpMethod = "GET"
	public let authenticationLevel = AuthenticationLevel.Level2

	public var oauthCallback: String

	public var query: [String: String] {
		var query: [String: String] = [:]
		query["oauth_callback"] = self.oauthCallback
		return query
	}

	public init(baseURLString: String, oauthCallback: String) {
		self.baseURLString = baseURLString
		self.oauthCallback = oauthCallback
	}

	public static func resultFromData(data: NSData) throws -> Result {
		guard let string = String(data: data, encoding: NSUTF8StringEncoding) else { throw defaultError }
		return try Result(string: string)
	}

	public struct Result {
		public let oauthToken: String
		public let oauthTokenSecret: String
		public let oauthCallbackConfirmed: Bool

		public init(string: String) throws {
			let query = try string.query()

			guard let
				oauthToken = query["oauth_token"],
				oauthTokenSecret = query["oauth_token_secret"],
				oauthCallbackConfirmed = query["oauth_callback_confirmed"] else {
					throw defaultError
			}

			self.oauthToken = oauthToken
			self.oauthTokenSecret = oauthTokenSecret

			switch oauthCallbackConfirmed {
			case "true": self.oauthCallbackConfirmed = true
			case "false": self.oauthCallbackConfirmed = false
			default: throw defaultError
			}
		}
	}
}
