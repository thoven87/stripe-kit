//
//  CustomerSessionRoutes.swift
//  stripe-kit
//

import Foundation
import NIO
import NIOHTTP1

public protocol CustomerSessionRoutes: StripeAPIRoute {
    /// Creates a Customer Session object that includes a single-use client secret that you can use on your front-end to grant client-side API access for certain customer resources.
    ///
    /// - Parameters:
    ///   - components: Configuration for each component. At least 1 component must be enabled.
    ///   - customer: The ID of an existing customer for which to create the Customer Session.
    ///   - expand: Specifies which fields in the response should be expanded.
    /// - Returns: Returns a CustomerSession object.
    func create(
        components: [String: Any],
        customer: String,
        expand: [String]?
    ) async throws -> CustomerSession
}

public struct StripeCustomerSessionRoutes: CustomerSessionRoutes {
    public var headers: HTTPHeaders = [:]

    private let apiHandler: StripeAPIHandler
    private let customerSessions = APIBase + APIVersion + "customer_sessions"

    init(apiHandler: StripeAPIHandler) {
        self.apiHandler = apiHandler
    }

    public func create(
        components: [String: Any],
        customer: String,
        expand: [String]? = nil
    ) async throws -> CustomerSession {
        var body: [String: Any] = [:]
        components.forEach { body[$0] = $1 }
        body["customer"] = customer

        if let expand {
            body["expand"] = expand
        }

        return try await apiHandler.send(
            method: .POST, path: customerSessions, body: .string(body.queryParameters),
            headers: headers)
    }
}
