import Testing

@testable import StripeKit

@Suite struct QueryEncodingTests {

    @Test func simpleQueryEncodedProperly() {
        let query = ["email": "accounting+furnitures@hmm.test"]
        #expect(query.queryParameters == "email=accounting%2Bfurnitures@hmm.test")
    }

    @Test func nestedDictionaryQueryEncodedProperly() {
        let query: [String: Any] = ["shipping": ["name": "Hamlin, Hamlin & McGill"]]
        #expect(query.queryParameters == "shipping[name]=Hamlin,%20Hamlin%20%26%20McGill")
    }

    @Test func nestedArrayQueryEncodedProperly() {
        let query: [String: Any] = ["items": [["plan": "plan_b"], ["plan": "plan_nine"]]]
        #expect(query.queryParameters == "items[0][plan]=plan_b&items[1][plan]=plan_nine")
    }
}
