import Nimble
import OKAPIKit
import UIKit
import XCTest
import MapKit

extension String {
	var UTF8Data: NSData {
		let data = self.utf8.map { UInt8($0) }
		return NSData(bytes: data, length: data.count)
	}
}

func MakeAndSetup<T>(object: T, @noescape configure: (inout object: T) -> ()) -> T {
	var object = object
	configure(object: &object)
	return object
}

let consumerKey = "bD5Gbs3AzfaUR5AvyLh8"
let consumerSecret = "6LPRfAW5bHEccAJdSCDgHE2rztLX5TWZvCGA3uw5"
let tokenKey = "HZVtXmWdJcs5vLQx4Awk"
let tokenSecret = "CJsBv7ukP8xnYhFMutQ4v8YQKEcE6yPy86Yu4hEH"

let consumerCredentials = Credentials(consumerKey: consumerKey, consumerSecret: consumerSecret)

let consumerAndTokenCredentials = Credentials(
	consumerKey: consumerKey,
	consumerSecret: consumerSecret,
	tokenKey: tokenKey,
	tokenSecret: tokenSecret
)

let defaultHTTPBaseString = "http://opencaching.pl/okapi"

func expectRequest(request: Request,
                   toHaveBaseURLString baseURLString: String,
                                       path: String,
                                       httpMethod: String,
                                       query: [String: String],
                                       authenticationLevel: AuthenticationLevel) {

	expect(request.baseURLString) == baseURLString
	expect(request.path) == path
	expect(request.httpMethod) == httpMethod
	expect(request.query) == query
	expect(request.authenticationLevel) == authenticationLevel
}

class Services_OAuth_RequestToken_Tests: XCTestCase {
	func testRequest() {
		let oauthCallback = "okapi://authorization"
		let request = Services_OAuth_RequestToken(baseURLString: defaultHTTPBaseString, oauthCallback: oauthCallback)
		expectRequest(request,
		              toHaveBaseURLString: defaultHTTPBaseString,
		              path: "services/oauth/request_token",
		              httpMethod: "GET",
		              query: [
										"oauth_callback": oauthCallback,
			],
		              authenticationLevel: .Level2)
	}

	func testResult() {
		let mockSuccessResponse = ("oauth_token=huK2U5atYrNUDNyXLMVv"
			+ "&oauth_token_secret=QWSD9Cv2sc9zxKshEtBvJeedTC2wfNQWAysz2Lsh"
			+ "&oauth_callback_confirmed=true")
		let resultData = mockSuccessResponse.dataUsingEncoding(NSUTF8StringEncoding)!
		let result = try! Services_OAuth_RequestToken.resultFromData(resultData)

		expect(result.oauthToken) == "huK2U5atYrNUDNyXLMVv"
		expect(result.oauthTokenSecret) == "QWSD9Cv2sc9zxKshEtBvJeedTC2wfNQWAysz2Lsh"
		expect(result.oauthCallbackConfirmed) == true
	}
}

class Services_OAuth_Authorize_Tests: XCTestCase {
	func testRequest() {
		let oauthToken = "vVy43CktSpqJfyJHnzFX"

		var request = Services_OAuth_Authorize(baseURLString: defaultHTTPBaseString,
		                                       oauthToken: oauthToken,
		                                       interactivity: .Minimal,
		                                       languagePreferences: ["pl", "en"])

		expectRequest(request,
		              toHaveBaseURLString: defaultHTTPBaseString,
		              path: "services/oauth/authorize",
		              httpMethod: "GET",
		              query: [
										"oauth_token": oauthToken,
										"interactivity": "minimal",
										"langpref": "pl|en",
			],
		              authenticationLevel: .Level0)

		request.languagePreferences = nil
		expectRequest(request,
		              toHaveBaseURLString: defaultHTTPBaseString,
		              path: "services/oauth/authorize",
		              httpMethod: "GET",
		              query: [
										"oauth_token": oauthToken,
										"interactivity": "minimal",
			],
		              authenticationLevel: .Level0)

		request.interactivity = Interactivity.ConfirmUser
		expectRequest(request,
		              toHaveBaseURLString: defaultHTTPBaseString,
		              path: "services/oauth/authorize",
		              httpMethod: "GET",
		              query: [
										"oauth_token": oauthToken,
										"interactivity": "confirm_user",
			],
		              authenticationLevel: .Level0)

		request.interactivity = nil
		expectRequest(request,
		              toHaveBaseURLString: defaultHTTPBaseString,
		              path: "services/oauth/authorize",
		              httpMethod: "GET",
		              query: [
										"oauth_token": oauthToken,
			],
		              authenticationLevel: .Level0)
	}

	func testResult() {
		typealias Result = Services_OAuth_Authorize.Result
		let successString = "okapi://authorization/?oauth_token=vVy43CktSpqJfyJHnzFX&oauth_verifier=98996734"
		let errorString = "okapi://authorization/?error=access_denied&oauth_token=vVy43CktSpqJfyJHnzFX"

		let successResult = try! Result(string: successString)
		let errorResult = try! Result(string: errorString)

		expect(successResult) == Result.Authorized(oauthToken: "vVy43CktSpqJfyJHnzFX", oauthVerifier: "98996734")
		expect(errorResult) == Result.Denied(oauthToken: "vVy43CktSpqJfyJHnzFX", error: "access_denied")
	}
}

class Services_OAuth_AccessToken_Tests: XCTestCase {
	func testRequest() {
		let oauthVerifier = "654352156"
		let request = Services_OAuth_AccessToken(baseURLString: defaultHTTPBaseString, oauthVerifier: oauthVerifier)
		expectRequest(request,
		              toHaveBaseURLString: defaultHTTPBaseString,
		              path: "services/oauth/access_token",
		              httpMethod: "GET",
		              query: [
										"oauth_verifier": oauthVerifier,
			],
		              authenticationLevel: .Level3)
	}

	func testResult() {
		let mockSuccessResponse = ("oauth_token=huK2U5atYrNUDNyXLMVv"
			+ "&oauth_token_secret=QWSD9Cv2sc9zxKshEtBvJeedTC2wfNQWAysz2Lsh")
		let resultData = mockSuccessResponse.dataUsingEncoding(NSUTF8StringEncoding)!
		let result = try! Services_OAuth_AccessToken.resultFromData(resultData)

		expect(result.oauthToken) == "huK2U5atYrNUDNyXLMVv"
		expect(result.oauthTokenSecret) == "QWSD9Cv2sc9zxKshEtBvJeedTC2wfNQWAysz2Lsh"
	}
}

class Services_Caches_Search_All_Tests: XCTestCase {
	func testRequest() {
		var request = Services_Caches_Search_All(baseURLString: defaultHTTPBaseString)

		request.types = .Exclude([.Traditional, .Quiz])
		request.statuses = [.Archived, .Available]
		request.ownerUUIDs = .Exclude(["UUID1", "UUID2"])
		request.name = "Name"
		request.terrain = 1...3
		request.difficulty = 2...4
		request.sizes = [.Nano, .Micro, .Large]
		request.rating = RatingParameter(includingUnrated: 1...4)
		request.minimumRecommendations = .Proportional(100)
		request.minimumFounds = 5
		request.maximumFounds = 10
		request.modifiedSince = NSDate(timeIntervalSince1970: 1000)
		request.foundStatus = .FoundOnly
		request.foundBy = ["FoundByUUID1", "FoundByUUID2"]
		request.notFoundBy = ["NotFoundByUUID1", "NotFoundByUUID2"]
		request.watchedOnly = true
		request.ignoredStatus = .IgnoredOnly
		request.excludeMyOwn = true
		request.withTrackablesOnly = true
		request.ftfHunter = true
		request.powertrailOnly = true
		request.powertrailIDs = ["PowertrailID1", "PowertrailID2"]
		request.setAnd = "SetAndUUID"
		request.limit = 100
		request.offset = 50
		request.orderBy = [.Ascending(.RecommendationsRatio), .Descending(.Name)]

		let URLRequest = try! request.URLRequestWithCredentials(consumerAndTokenCredentials)
		print(URLRequest)

		expectRequest(request,
		              toHaveBaseURLString: defaultHTTPBaseString,
		              path: "services/caches/search/all",
		              httpMethod: "GET",
		              query: [
										"type": "-Traditional|Quiz",
										"status": "Archived|Available",
										"owner_uuid": "-UUID1|UUID2",
										"name": "Name",
										"terrain": "1-3",
										"difficulty": "2-4",
										"size2": "nano|micro|large",
										"rating": "1-4|X",
										"min_rcmds": "%100",
										"min_founds": "5",
										"max_founds": "10",
										"modified_since": "1970-01-01T01:16:40+01:00",
										"found_status": "found_only",
										"found_by": "FoundByUUID1|FoundByUUID2",
										"notfound_by": "NotFoundByUUID1|NotFoundByUUID2",
										"watched_only": "true",
										"ignored_status": "ignored_only",
										"exclude_my_own": "true",
										"with_trackables_only": "true",
										"ftf_hunter": "true",
										"powertrail_only": "true",
										"powertrail_ids": "PowertrailID1|PowertrailID2",
										"set_and": "SetAndUUID",
										"limit": "100",
										"offset": "50",
										"order_by": "+rcmds%|-name",
			],
		              authenticationLevel: AuthenticationLevel.Level3
		)
	}

	func testAuthenticationLevel() {
		do {
			var request = Services_Caches_Search_All(baseURLString: defaultHTTPBaseString)
			request.foundStatus = .FoundOnly
			expect(request.authenticationLevel) == AuthenticationLevel.Level3
		}
		do {
			var request = Services_Caches_Search_All(baseURLString: defaultHTTPBaseString)
			request.watchedOnly = true
			expect(request.authenticationLevel) == AuthenticationLevel.Level3
		}
		do {
			var request = Services_Caches_Search_All(baseURLString: defaultHTTPBaseString)
			request.ignoredStatus = .IgnoredOnly
			expect(request.authenticationLevel) == AuthenticationLevel.Level3
		}
		do {
			var request = Services_Caches_Search_All(baseURLString: defaultHTTPBaseString)
			request.excludeMyOwn = true
			expect(request.authenticationLevel) == AuthenticationLevel.Level3
		}
		do {
			var request = Services_Caches_Search_All(baseURLString: defaultHTTPBaseString)
			request.types = .Exclude([.Traditional, .Quiz])
			request.statuses = [.Archived, .Available]
			request.ownerUUIDs = .Exclude(["UUID1", "UUID2"])
			request.name = "Name"
			request.terrain = 1...3
			request.difficulty = 2...4
			request.sizes = [.Nano, .Micro, .Large]
			request.rating = RatingParameter(includingUnrated: 1...4)
			request.minimumRecommendations = .Proportional(100)
			request.minimumFounds = 5
			request.maximumFounds = 10
			request.modifiedSince = NSDate(timeIntervalSince1970: 1000)
			request.foundBy = ["FoundByUUID1", "FoundByUUID2"]
			request.notFoundBy = ["NotFoundByUUID1", "NotFoundByUUID2"]
			request.withTrackablesOnly = true
			request.ftfHunter = true
			request.powertrailOnly = true
			request.powertrailIDs = ["PowertrailID1", "PowertrailID2"]
			request.setAnd = "SetAndUUID"
			request.limit = 100
			request.offset = 50
			request.orderBy = [.Ascending(.RecommendationsRatio), .Descending(.Name)]
			expect(request.authenticationLevel) == AuthenticationLevel.Level1
		}
	}

	func testResult() {
		do {
			let resultString = "{\"results\":[],\"more\":true}"
			let result = try? Services_Caches_Search_All.resultFromData(resultString.UTF8Data)
			expect(result).toNot(beNil())
			expect(result?.more) == true
			expect(result?.results).notTo(beNil())
		}
		do {
			let resultString = "{\"more\":true}"
			let result = try? Services_Caches_Search_All.resultFromData(resultString.UTF8Data)
			expect(result).to(beNil())
		}
		do {
			let resultString = "{\"results\":[]}"
			let result = try? Services_Caches_Search_All.resultFromData(resultString.UTF8Data)
			expect(result).to(beNil())
		}
	}
}

class Services_Caches_Search_Nearest_Tests: XCTestCase {
	func testRequest() {
		let myLocation = CLLocationCoordinate2D(latitude: 20, longitude: 50)
		var request = Services_Caches_Search_Nearest(baseURLString: defaultHTTPBaseString, center: myLocation)

		request.radius = 10
		request.types = .Exclude([.Traditional, .Quiz])
		request.statuses = [.Archived, .Available]
		request.ownerUUIDs = .Exclude(["UUID1", "UUID2"])
		request.name = "Name"
		request.terrain = 1...3
		request.difficulty = 2...4
		request.sizes = [.Nano, .Micro, .Large]
		request.rating = RatingParameter(includingUnrated: 1...4)
		request.minimumRecommendations = .Proportional(100)
		request.minimumFounds = 5
		request.maximumFounds = 10
		request.modifiedSince = NSDate(timeIntervalSince1970: 1000)
		request.foundStatus = .FoundOnly
		request.foundBy = ["FoundByUUID1", "FoundByUUID2"]
		request.notFoundBy = ["NotFoundByUUID1", "NotFoundByUUID2"]
		request.watchedOnly = true
		request.ignoredStatus = .IgnoredOnly
		request.excludeMyOwn = true
		request.withTrackablesOnly = true
		request.ftfHunter = true
		request.powertrailOnly = true
		request.powertrailIDs = ["PowertrailID1", "PowertrailID2"]
		request.setAnd = "SetAndUUID"
		request.limit = 100
		request.offset = 50
		request.orderBy = [.Ascending(.RecommendationsRatio), .Descending(.Name)]

		let URLRequest = try! request.URLRequestWithCredentials(consumerAndTokenCredentials)
		print(URLRequest)

		expectRequest(request,
		              toHaveBaseURLString: defaultHTTPBaseString,
		              path: "services/caches/search/nearest",
		              httpMethod: "GET",
		              query: [
										"center": "20.0|50.0",
										"radius": "10.0",
										"type": "-Traditional|Quiz",
										"status": "Archived|Available",
										"owner_uuid": "-UUID1|UUID2",
										"name": "Name",
										"terrain": "1-3",
										"difficulty": "2-4",
										"size2": "nano|micro|large",
										"rating": "1-4|X",
										"min_rcmds": "%100",
										"min_founds": "5",
										"max_founds": "10",
										"modified_since": "1970-01-01T01:16:40+01:00",
										"found_status": "found_only",
										"found_by": "FoundByUUID1|FoundByUUID2",
										"notfound_by": "NotFoundByUUID1|NotFoundByUUID2",
										"watched_only": "true",
										"ignored_status": "ignored_only",
										"exclude_my_own": "true",
										"with_trackables_only": "true",
										"ftf_hunter": "true",
										"powertrail_only": "true",
										"powertrail_ids": "PowertrailID1|PowertrailID2",
										"set_and": "SetAndUUID",
										"limit": "100",
										"offset": "50",
										"order_by": "+rcmds%|-name",
			],
		              authenticationLevel: AuthenticationLevel.Level3
		)
	}

	func testAuthenticationLevel() {
		let myLocation = CLLocationCoordinate2D(latitude: 20, longitude: 50)
		do {
			var request = Services_Caches_Search_Nearest(baseURLString: defaultHTTPBaseString, center: myLocation)
			request.foundStatus = .FoundOnly
			expect(request.authenticationLevel) == AuthenticationLevel.Level3
		}
		do {
			var request = Services_Caches_Search_Nearest(baseURLString: defaultHTTPBaseString, center: myLocation)
			request.watchedOnly = true
			expect(request.authenticationLevel) == AuthenticationLevel.Level3
		}
		do {
			var request = Services_Caches_Search_Nearest(baseURLString: defaultHTTPBaseString, center: myLocation)
			request.ignoredStatus = .IgnoredOnly
			expect(request.authenticationLevel) == AuthenticationLevel.Level3
		}
		do {
			var request = Services_Caches_Search_Nearest(baseURLString: defaultHTTPBaseString, center: myLocation)
			request.excludeMyOwn = true
			expect(request.authenticationLevel) == AuthenticationLevel.Level3
		}
		do {
			var request = Services_Caches_Search_Nearest(baseURLString: defaultHTTPBaseString, center: myLocation)
			request.radius = 10
			request.types = .Exclude([.Traditional, .Quiz])
			request.statuses = [.Archived, .Available]
			request.ownerUUIDs = .Exclude(["UUID1", "UUID2"])
			request.name = "Name"
			request.terrain = 1...3
			request.difficulty = 2...4
			request.sizes = [.Nano, .Micro, .Large]
			request.rating = RatingParameter(includingUnrated: 1...4)
			request.minimumRecommendations = .Proportional(100)
			request.minimumFounds = 5
			request.maximumFounds = 10
			request.modifiedSince = NSDate(timeIntervalSince1970: 1000)
			request.foundBy = ["FoundByUUID1", "FoundByUUID2"]
			request.notFoundBy = ["NotFoundByUUID1", "NotFoundByUUID2"]
			request.withTrackablesOnly = true
			request.ftfHunter = true
			request.powertrailOnly = true
			request.powertrailIDs = ["PowertrailID1", "PowertrailID2"]
			request.setAnd = "SetAndUUID"
			request.limit = 100
			request.offset = 50
			request.orderBy = [.Ascending(.RecommendationsRatio), .Descending(.Name)]
			expect(request.authenticationLevel) == AuthenticationLevel.Level1
		}
	}

	func testResult() {
		do {
			let resultString = "{\"results\":[],\"more\":true}"
			let result = try? Services_Caches_Search_Nearest.resultFromData(resultString.UTF8Data)
			expect(result).toNot(beNil())
			expect(result?.more) == true
			expect(result?.results).notTo(beNil())
		}
		do {
			let resultString = "{\"more\":true}"
			let result = try? Services_Caches_Search_Nearest.resultFromData(resultString.UTF8Data)
			expect(result).to(beNil())
		}
		do {
			let resultString = "{\"results\":[]}"
			let result = try? Services_Caches_Search_Nearest.resultFromData(resultString.UTF8Data)
			expect(result).to(beNil())
		}
	}
}

class Services_Caches_Geocache_Tests: XCTestCase {
	func testRequest() {
		var request = Services_Caches_Geocache(baseURLString: defaultHTTPBaseString, cacheCode: "CacheCode1")

		request.languagePreference = ["pl", "en"]
		request.fields = [.Name, .Rating]
		request.attributionAppendage = .Full
		request.logsPerCache = .All
		request.logFields = [.CacheCode, .Date]
		request.myLocation = CLLocationCoordinate2D(latitude: 20, longitude: 50)
		request.userUUID = "UserUUID"

		expectRequest(request,
		              toHaveBaseURLString: defaultHTTPBaseString,
		              path: "services/caches/geocache",
		              httpMethod: "GET",
		              query: [
										"cache_code": "CacheCode1",
										"langpref": "pl|en",
										"fields": "name|rating",
										"attribution_append": "full",
										"lpc": "all",
										"log_fields": "cache_code|date",
										"my_location": "20.0|50.0",
										"user_uuid": "UserUUID",
			],
		              authenticationLevel: AuthenticationLevel.Level1
		)
	}

	func testAuthenticationLevel() {
		for field in CacheField.allCases {
			var request = Services_Caches_Geocache(baseURLString: defaultHTTPBaseString, cacheCode: "CacheCode1")
			request.fields = [field]

			let expectedAuthenticationLevel: AuthenticationLevel
			switch field {
			case .IsFound: fallthrough
			case .IsNotFound: fallthrough
			case .IsWatched: fallthrough
			case .MyNotes: fallthrough
			case .IsIgnored: expectedAuthenticationLevel = .Level3
			default: expectedAuthenticationLevel = .Level1
			}

			expect(request.authenticationLevel) == expectedAuthenticationLevel
		}
	}

	func testResult() {
		do {
			let resultString = "{}"
			let result = try? Services_Caches_Geocache.resultFromData(resultString.UTF8Data)
			expect(result).toNot(beNil())
		}
		do {
			let resultString = "[]"
			let result = try? Services_Caches_Geocache.resultFromData(resultString.UTF8Data)
			expect(result).to(beNil())
		}
	}
}

class Services_Caches_Geocaches_Tests: XCTestCase {
	func testRequest() {
		let cacheCodes = ["CacheCode1", "CacheCode2"]
		var request = Services_Caches_Geocaches(baseURLString: defaultHTTPBaseString, cacheCodes: cacheCodes)

		request.languagePreference = ["pl", "en"]
		request.fields = [.Name, .Rating]
		request.attributionAppendage = .Full
		request.logsPerCache = .All
		request.logFields = [.CacheCode, .Date]
		request.myLocation = CLLocationCoordinate2D(latitude: 20, longitude: 50)
		request.userUUID = "UserUUID"

		expectRequest(request,
		              toHaveBaseURLString: defaultHTTPBaseString,
		              path: "services/caches/geocaches",
		              httpMethod: "GET",
		              query: [
										"cache_codes": "CacheCode1|CacheCode2",
										"langpref": "pl|en",
										"fields": "name|rating",
										"attribution_append": "full",
										"lpc": "all",
										"log_fields": "cache_code|date",
										"my_location": "20.0|50.0",
										"user_uuid": "UserUUID",
			],
		              authenticationLevel: AuthenticationLevel.Level1
		)
	}

	func testAuthenticationLevel() {
		for field in CacheField.allCases {
			var request = Services_Caches_Geocaches(baseURLString: defaultHTTPBaseString, cacheCodes: [])
			request.fields = [field]

			let expectedAuthenticationLevel: AuthenticationLevel
			switch field {
			case .IsFound: fallthrough
			case .IsNotFound: fallthrough
			case .IsWatched: fallthrough
			case .MyNotes: fallthrough
			case .IsIgnored: expectedAuthenticationLevel = .Level3
			default: expectedAuthenticationLevel = .Level1
			}

			expect(request.authenticationLevel) == expectedAuthenticationLevel
		}
	}

	func testResult() {
		do {
			let resultString = "{\"CacheCode\":{}}"
			let result = try? Services_Caches_Geocaches.resultFromData(resultString.UTF8Data)
			expect(result).toNot(beNil())
		}
		do {
			let resultString = "[]"
			let result = try? Services_Caches_Geocaches.resultFromData(resultString.UTF8Data)
			expect(result).to(beNil())
		}
	}
}

class Services_Caches_Shortcuts_SearchAndRetreive_Tests: XCTestCase {
	func testRequest() {
		var searchRequest = Services_Caches_Search_All(baseURLString: "http://dont.use.this.url")
		searchRequest.foundStatus = .FoundOnly

		var retrieveRequest = Services_Caches_Geocaches(baseURLString: "http://dont.use.this.url", cacheCodes: [])
		retrieveRequest.fields = [
			.Code,
			.Bearing,
		]
		retrieveRequest.logsPerCache = .All

		let request = Services_Caches_Shortcuts_SearchAndRetreive(
			baseURLString: defaultHTTPBaseString,
			searchRequest: searchRequest,
			retrieveRequest: retrieveRequest,
			wrap: true
		)

		expectRequest(request,
		              toHaveBaseURLString: defaultHTTPBaseString,
		              path: "services/caches/shortcuts/search_and_retrieve",
		              httpMethod: "GET",
		              query: [
										"search_method": "services/caches/search/all",
										"search_params": "{\"found_status\":\"found_only\"}",
										"retr_method": "services/caches/geocaches",
										"retr_params": "{\"fields\":\"code|bearing\",\"lpc\":\"all\"}",
										"wrap": "true",
			],
		              authenticationLevel: AuthenticationLevel.Level3
		)
	}
	
	func testAuthenticationLevel() {
		do {
			var searchRequest = Services_Caches_Search_All(baseURLString: defaultHTTPBaseString)
			searchRequest.foundStatus = .FoundOnly
			
			let retrieveRequest = Services_Caches_Geocaches(baseURLString: defaultHTTPBaseString, cacheCodes: [])
			
			let request = Services_Caches_Shortcuts_SearchAndRetreive(
				baseURLString: defaultHTTPBaseString,
				searchRequest: searchRequest,
				retrieveRequest: retrieveRequest,
				wrap: true
			)
			
			expect(request.authenticationLevel) == AuthenticationLevel.Level3
		}
		do {
			let searchRequest = Services_Caches_Search_All(baseURLString: defaultHTTPBaseString)
			let retrieveRequest = Services_Caches_Geocaches(baseURLString: defaultHTTPBaseString, cacheCodes: [])
			
			let request = Services_Caches_Shortcuts_SearchAndRetreive(
				baseURLString: defaultHTTPBaseString,
				searchRequest: searchRequest,
				retrieveRequest: retrieveRequest,
				wrap: true
			)
			
			expect(request.authenticationLevel) == AuthenticationLevel.Level1
		}
	}
}
