import Rosetta

public struct ProtectionArea: JSONConvertible {
	public var type: String?
	public var name: String?

	public init() { }

	public static func map(inout object: ProtectionArea, json: Rosetta) {
		object.type <~ json["type"]
		object.name <~ json["name"]
	}
}
