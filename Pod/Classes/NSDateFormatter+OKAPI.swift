import Foundation

let ISO8601DateFormatter: NSDateFormatter = {
	let formatter = NSDateFormatter()
	formatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
	formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
	return formatter
}()

extension NSDateFormatter {
	static var ISO8601Formatter: NSDateFormatter {
		return ISO8601DateFormatter
	}
}
