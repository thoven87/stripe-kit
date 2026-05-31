//
//  ActiveEntitlementRoutes.swift
//  stripe-kit
//

import Foundation
import NIO
import NIOHTTP1

public protocol ActiveEntitlementRoutes: StripeAPIRoute {
    /// Retrieve an active entitlement.
    ///
    /// - Parameters:
    ///  - id: The ID of the entitlement.
    ///
    ///  - Returns: Returns an active entitlement
    func retrieve(id: String) async throws -> ActiveEntitlement

    /// List all active entitlements.
    ///
    /// Retrieve a list of active entitlements for a customer
    ///
    /// - Parameters:
    ///  - customer: The ID of the customer.
    ///  - filter: A dictionary that will be used for the query parameters.
    ///
    ///  - Returns: Returns a list of active entitlements for a customer
    func listAll(customer: String, filter: [String: Any]?) async throws -> ActiveEntitlementList
}

public struct StripeActiveEntitlementRoutes: ActiveEntitlementRoutes {
    public var headers: HTTPHeaders = [:]

    private let apiHandler: StripeAPIHandler
    private let activeEntitlements = APIBase + APIVersion + "entitlements/active_entitlements"

    init(apiHandler: StripeAPIHandler) {
        self.apiHandler = apiHandler
    }

    public func retrieve(id: String) async throws -> ActiveEntitlement {
        try await apiHandler.send(
            method: .GET, path: "\(activeEntitlements)/\(id)", headers: headers)
    }

    public func listAll(customer: String, filter: [String: Any]?) async throws
        -> ActiveEntitlementList
    {
        var queryParams = ""
        var combinedFilter = filter ?? [:]
        combinedFilter["customer"] = customer
        queryParams = combinedFilter.queryParameters

        return try await apiHandler.send(
            method: .GET, path: activeEntitlements, query: queryParams, headers: headers)
    }
}
