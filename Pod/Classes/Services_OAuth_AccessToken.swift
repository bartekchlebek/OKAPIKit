public struct Services_OAuth_AccessToken: Request {
	public var baseURLString: String
	public let path = "services/oauth/access_token"
	public let httpMethod = "GET"
	public let authenticationLevel = AuthenticationLevel.Level3

	public var oauthVerifier: String

	public var query: [String: String] {
		return ["oauth_verifier": self.oauthVerifier]
	}

	public init(baseURLString: String, oauthVerifier: String) {
		self.baseURLString = baseURLString
		self.oauthVerifier = oauthVerifier
	}

	public static func resultFromData(data: NSData) throws -> Result {
		guard let string = String(data: data, encoding: NSUTF8StringEncoding) else { throw defaultError }
		return try Result(string: string)
	}

	public struct Result {
		public let oauthToken: String
		public let oauthTokenSecret: String

		public init(string: String) throws {
			let query = try string.query()

			guard let
				oauthToken = query["oauth_token"],
				oauthTokenSecret = query["oauth_token_secret"] else {
					throw defaultError
			}

			self.oauthToken = oauthToken
			self.oauthTokenSecret = oauthTokenSecret
		}
	}
}
