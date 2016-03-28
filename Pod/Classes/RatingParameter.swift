public struct RatingParameter {
	public var includesUnrated: Bool
	public var rating: ClosedInterval<Rating>

	public init(includingUnrated rating: ClosedInterval<Rating>) {
		self.includesUnrated = true
		self.rating = rating
	}

	public init(excludingUnrated rating: ClosedInterval<Rating>) {
		self.includesUnrated = false
		self.rating = rating
	}
}

extension RatingParameter: StringRepresentable {
	var stringValue: String {
		return self.rating.stringValue + (self.includesUnrated ? "|X" : "")
	}
}
