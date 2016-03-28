import Foundation

extension NSCharacterSet {

	/// Returns the character set for characters allowed in the individual parameters within a query URL component.
	///
	/// The query component of a URL is the component immediately following a question mark (?).
	/// For example, in the URL `http://www.example.com/index.php?key1=value1#jumpLink`, the query
	/// component is `key1=value1`. The individual parameters of that query would be the key `key1`
	/// and its associated value `value1`.
	///
	/// According to RFC 3986, the set of unreserved characters includes
	///
	/// `ALPHA / DIGIT / "-" / "." / "_" / "~"`


	class func URLQueryParameterAllowedCharacterSet() -> Self {
		return self.init(charactersInString: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789-._~")
	}
	
}

protocol StringProtocol {
	var string: String { get }
}
extension String: StringProtocol {
	var string: String { return self }
}

extension Dictionary where Key: StringProtocol, Value: StringProtocol {
	func dictionaryByQueryPercentEncodingKeysAndValues() throws -> [String: String] {
		var encodedQuery: [String: String] = [:]
		for (key, value) in self {
			let encodedKey = try key.string.percentEncodedString()
			let encodedValue = try value.string.percentEncodedString()
			encodedQuery[encodedKey] = encodedValue
		}
		return encodedQuery
	}

	func queryString() throws -> String {
		var query: [String] = []
		for (key, value) in try self.dictionaryByQueryPercentEncodingKeysAndValues() {
			query.append(key + "=" + value)
		}
		return query.joinWithSeparator("&")
	}
}

extension String {
	private func decodedQueryKeyValuePair() throws -> (key: String, value: String) {
		let pair = self.componentsSeparatedByString("=")
		if pair.count != 2 { throw defaultError }
		return (key: pair[0], value: pair[1])
	}

	func query() throws -> [String: String] {
		var query: [String: String] = [:]

		let pairs = self.stringByReplacingOccurrencesOfString("+", withString: " ").componentsSeparatedByString("&")
		for pair in pairs {
			let decodedPair = try pair.decodedQueryKeyValuePair()
			query[decodedPair.key] = decodedPair.value
		}

		return query
	}
}

public extension String {
	public func percentEncodedString() throws -> String {
		let allowedCharacters = NSCharacterSet.URLQueryParameterAllowedCharacterSet()
		guard let encoded = self.stringByAddingPercentEncodingWithAllowedCharacters(allowedCharacters) else {
			throw defaultError
		}
		return encoded
  }
  
  public func percentDecodedString() throws -> String {
		guard let decoded = self.stringByRemovingPercentEncoding else {
			throw defaultError
		}
		return decoded
  }
}
