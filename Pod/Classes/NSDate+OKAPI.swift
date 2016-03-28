import Foundation
import Rosetta

extension NSDate {
	var ISO8601String: String {
		return NSDateFormatter.ISO8601Formatter.stringFromDate(self)
	}
}

func NSDateISO8601Bridge() -> Bridge<NSDate, NSString> {
	return BridgeString(
		decoder: { NSDateFormatter.ISO8601Formatter.dateFromString($0 as String) },
		encoder: { NSDateFormatter.ISO8601Formatter.stringFromDate($0) }
	)
}
