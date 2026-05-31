import Crypto
import Foundation
import Testing

@testable import StripeKit

@Suite struct SignatureVerificationTests {
    let jsonData: Data = try! JSONEncoder().encode(["key": "value"])
    let secret = "SECRET"

    @Test func verificationWithSingleSignature() throws {
        let timestamp = String(Date().addingTimeInterval(-60).timeIntervalSince1970)
        let secretData = secret.data(using: .utf8)!
        let data = [timestamp, String(data: jsonData, encoding: .utf8)!]
            .joined(separator: ".")
            .data(using: .utf8)!
        let hash = Data(
            HMAC<SHA256>.authenticationCode(for: data, using: SymmetricKey(data: secretData))
        ).hexString
        let header = "t=\(timestamp),v1=\(hash)"
        try StripeClient.verifySignature(payload: jsonData, header: header, secret: secret)
    }

    @Test func verificationWithMultipleSignatures() throws {
        let header =
            "t=123,v1=7b15c7edc2183ad5be71922cc180f70b1ce4c0925c45abb6b1676ad43cb79173,v1=911b8d64f1a89c73cec478d4ace90345a6c268f5f60892060ea1af531b4fe97c"
        try StripeClient.verifySignature(
            payload: jsonData, header: header, secret: secret, tolerance: -1)
    }

    @Test func verificationWithInvalidHeaderThrows() {
        #expect(throws: StripeSignatureError.unableToParseHeader) {
            try StripeClient.verifySignature(
                payload: jsonData, header: "a", secret: secret, tolerance: -1)
        }
    }

    @Test func verificationWithWrongSignatureThrows() {
        #expect(throws: StripeSignatureError.noMatchingSignatureFound) {
            try StripeClient.verifySignature(
                payload: jsonData, header: "t=123,v1=abc", secret: secret, tolerance: -1)
        }
    }

    @Test func verificationWithNonToleratedTimestampThrows() throws {
        let timestamp = String(Date().addingTimeInterval(-360).timeIntervalSince1970)
        let secretData = secret.data(using: .utf8)!
        let data = [timestamp, String(data: jsonData, encoding: .utf8)!]
            .joined(separator: ".")
            .data(using: .utf8)!
        let hash = Data(
            HMAC<SHA256>.authenticationCode(for: data, using: SymmetricKey(data: secretData))
        ).hexString
        let header = "t=\(timestamp),v1=\(hash)"

        #expect(throws: StripeSignatureError.timestampNotTolerated) {
            try StripeClient.verifySignature(payload: jsonData, header: header, secret: secret)
        }
    }
}

extension Data {
    fileprivate var hexString: String {
        self.reduce("", { $0 + String(format: "%02x", $1) })
    }
}
