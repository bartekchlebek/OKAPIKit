import Foundation
import Rosetta

public struct Image: JSONConvertible {
	public var UUID: String?
	public var URL: NSURL?
	public var thumbnailURL: NSURL?
	public var caption: String?
	public var uniqueCaption: String?
	public var isSpoiler: Bool?

	public init() { }

	public static func map(inout object: Image, json: Rosetta) {
		object.UUID <~ json["uuid"]
		object.URL <~ json["url"] ~ NSURLBridge
		object.thumbnailURL <~ json["thumb_url"] ~ NSURLBridge
		object.caption <~ json["caption"]
		object.uniqueCaption <~ json["unique_caption"]
		object.isSpoiler <~ json["is_spoiler"]
	}
}
