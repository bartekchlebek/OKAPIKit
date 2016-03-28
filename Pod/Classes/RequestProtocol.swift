import Foundation
import CommonCrypto

public protocol Request {
	var baseURLString: String { get }
	var path: String { get }
	var httpMethod: String { get }
	var query: [String: String] { get }
	var authenticationLevel: AuthenticationLevel { get }
}

public protocol RequestWithResult: Request {
	typealias Result
	static func resultFromData(data: NSData) throws -> Result
}

extension Request {
	public func URLRequestWithCredentials(credentials: Credentials) throws -> NSURLRequest {

		guard let rootURL = NSURL(string: self.baseURLString) else { throw defaultError }
		guard let components = NSURLComponents(URL: rootURL, resolvingAgainstBaseURL: false) else { throw defaultError }
		guard let path = rootURL.URLByAppendingPathComponent(self.path).path else { throw defaultError }
		components.path = path
		guard let url = components.URL else { throw defaultError }

		var query = self.query

		let consumerKey = credentials.consumer.key
		let consumerSecret = credentials.consumer.secret

		switch authenticationLevel {
		case .Level0:
			break
		case .Level1:
			query["consumer_key"] = consumerKey
		case .Level2:
			query["oauth_consumer_key"] = consumerKey
			query["oauth_nonce"] = NSUUID().UUIDString
			query["oauth_signature_method"] = "HMAC-SHA1"
			query["oauth_timestamp"] = "\(Int(NSDate().timeIntervalSince1970))"
			query["oauth_version"] = "1.0"
			let signature = try oauthSignatureForURL(url, query: query, httpMethod: "GET", consumerSecret: consumerSecret)
			query["oauth_signature"] = signature
		case .Level3:
			guard let
				tokenKey = credentials.token?.key,
				tokenSecret = credentials.token?.secret
				else { throw defaultError }
			query["oauth_consumer_key"] = consumerKey
			query["oauth_nonce"] = NSUUID().UUIDString
			query["oauth_signature_method"] = "HMAC-SHA1"
			query["oauth_timestamp"] = "\(Int(NSDate().timeIntervalSince1970))"
			query["oauth_version"] = "1.0"
			query["oauth_token"] = tokenKey
			let signature = try oauthSignatureForURL(url, query: query, httpMethod: "GET", consumerSecret: consumerSecret, tokenSecret: tokenSecret)
			query["oauth_signature"] = signature
		}

		components.percentEncodedQuery = try query.queryString()
		guard let request = components.URL.flatMap({ NSURLRequest(URL: $0) }) else { throw defaultError }
		return request
	}
}

private func oauthSignatureForURL(
	url: NSURL,
	query: [String: String],
	httpMethod: String,
	consumerSecret: String,
	tokenSecret: String? = nil) throws -> String {

		let encodedURL = try url.absoluteString.percentEncodedString()
		let encodedQuery = try query.dictionaryByQueryPercentEncodingKeysAndValues()
		let encodedConsumerSecret = try consumerSecret.percentEncodedString()
		let encodedTokenSecret = try tokenSecret?.percentEncodedString() ?? ""

		let sortedKeys = Array(encodedQuery.keys).sort(<)
		let parametersString = sortedKeys.map { "\($0)=\(encodedQuery[$0]!)" }.joinWithSeparator("&")
		let encodedParametersString = try parametersString.percentEncodedString()

		// Create signature string with <HTTPMethod>&<URL>&<Parameters>
		let signatureBaseString = [
			httpMethod.uppercaseString,
			encodedURL,
			encodedParametersString
			].joinWithSeparator("&")

		// Create secret string with <consumerSecret>& or (if token secret available) <consumerSecret>&<tokenSecret>
		let signingKey = encodedConsumerSecret + "&" + encodedTokenSecret

		// Generate SHA1 digest from signatureBaseString with signingKey
		guard let
			keyData = signingKey.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false),
			inputData = signatureBaseString.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
			else { throw defaultError }

		// Generate SHA1 digest from signatureBaseString with signingKey
		let digestLength = Int(CC_SHA1_DIGEST_LENGTH)
		let result = UnsafeMutablePointer<Void>.alloc(digestLength)
		defer { result.dealloc(digestLength) }
		let algorithm = CCHmacAlgorithm(kCCHmacAlgSHA1)
		CCHmac(algorithm, keyData.bytes, keyData.length, inputData.bytes, inputData.length, result)

		// Base64 encode the SHA1 digest
		let options = NSDataBase64EncodingOptions.Encoding64CharacterLineLength
		return NSData(bytes: UnsafePointer<Void>(result), length:digestLength).base64EncodedStringWithOptions(options)
}
