import Rosetta

public struct Trackable: JSONConvertible {
	public var code: String?
	public var name: String?
	public var URL: NSURL?

	public init() { }

	public static func map(inout object: Trackable, json: Rosetta) {
		object.code <~ json["code"]
		object.name <~ json["name"]
		object.URL <~ json["url"] ~ NSURLBridge
	}
}
