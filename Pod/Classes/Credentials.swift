public struct Credentials {
	public typealias KeySecretPair = (key: String, secret: String)
	public var consumer: KeySecretPair
	public var token: KeySecretPair?

	public init(consumerKey: String, consumerSecret: String) {
		self.consumer.key = consumerKey
		self.consumer.secret = consumerSecret
	}

	public init(consumerKey: String, consumerSecret: String, tokenKey: String, tokenSecret: String) {
		self.consumer.key = consumerKey
		self.consumer.secret = consumerSecret
		self.token = (key: tokenKey, secret: tokenSecret)
	}
}
