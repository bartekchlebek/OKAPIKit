extension ClosedInterval where Bound: StringRepresentable {
	var stringValue: String { return self.start.stringValue + "-" + self.end.stringValue }
}
