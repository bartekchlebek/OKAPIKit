import MapKit
import Rosetta
import Foundation

extension CLLocationCoordinate2D: Bridgeable {
	public static func bridge() -> Bridge<CLLocationCoordinate2D, NSString> {
		return BridgeString(
			decoder: { (string) -> (CLLocationCoordinate2D?) in
				let components = string.componentsSeparatedByString("|")
				guard components.count == 2 else { return nil }
				guard let
					latitude = Double(components[0]),
					longitude = Double(components[1])
					else { return nil }
				return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
			},
			encoder: { (coordinate) -> (NSString?) in
				return "\(coordinate.latitude)|\(coordinate.longitude)"
			}
		)
	}
}

extension CLLocationCoordinate2D: StringRepresentable {
	var stringValue: String {
		return "\(self.latitude)|\(self.longitude)"
	}
}
