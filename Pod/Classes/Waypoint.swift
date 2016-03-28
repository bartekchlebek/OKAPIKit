import Rosetta
import MapKit

public struct Waypoint: JSONConvertible {
	public var name: String?
	public var location: CLLocationCoordinate2D?
	public var type: WaypointType?
	public var typeName: String?
	public var symbol: String?
	public var description: String?

	public init() { }

	public static func map(inout object: Waypoint, json: Rosetta) {
		object.name <~ json["name"]
		object.location <~ json["location"]
		object.type <~ json["type"]
		object.typeName <~ json["type_name"]
		object.symbol <~ json["sym"]
		object.description <~ json["description"]
	}
}
