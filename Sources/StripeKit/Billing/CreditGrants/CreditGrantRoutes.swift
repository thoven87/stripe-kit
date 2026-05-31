//
//  CreditGrantRoutes.swift
//  stripe-kit
//

import Foundation
import NIO
import NIOHTTP1

public protocol CreditGrantRoutes: StripeAPIRoute {
    /// Creates a credit grant.
    ///
    /// - Parameters:
    ///   - amount: Amount of this credit grant.
    ///   - applicabilityConfig: Configuration specifying what this credit grant applies to.
    ///   - category: The category of this credit grant.
    ///   - customer: ID of the customer to receive the billing credits.
    ///   - effectiveAt: The time when the billing credits become effective.
    ///   - expiresAt: The time when the billing credits will expire.
    ///   - metadata: Set of key-value pairs you can attach to an object.
    ///   - name: A descriptive name shown in the Dashboard.
    ///   - expand: Specifies which fields in the response should be expanded.
    func create(
        amount: [String: Any],
        applicabilityConfig: [String: Any],
        category: CreditGrantCategory,
        customer: String,
        effectiveAt: Date?,
        expiresAt: Date?,
        metadata: [String: String]?,
        name: String?,
        expand: [String]?
    ) async throws -> CreditGrant

    /// Updates a credit grant.
    func update(
        id: String,
        expiresAt: Date?,
        metadata: [String: String]?,
        expand: [String]?
    ) async throws -> CreditGrant

    /// Retrieves a credit grant.
    func retrieve(id: String, expand: [String]?) async throws -> CreditGrant

    /// Lists credit grants.
    func listAll(filter: [String: Any]?) async throws -> CreditGrantList

    /// Expires a credit grant.
    func expire(id: String, expand: [String]?) async throws -> CreditGrant

    /// Voids a credit grant.
    func void(id: String, expand: [String]?) async throws -> CreditGrant

    /// Retrieves the credit balance summary for a customer.
    func retrieveCreditBalanceSummary(customer: String, filter: [String: Any]?) async throws
        -> CreditBalanceSummary

    /// Retrieves a credit balance transaction.
    func retrieveCreditBalanceTransaction(id: String, expand: [String]?) async throws
        -> CreditBalanceTransaction

    /// Lists credit balance transactions.
    func listCreditBalanceTransactions(filter: [String: Any]?) async throws
        -> CreditBalanceTransactionList
}

public struct StripeCreditGrantRoutes: CreditGrantRoutes {
    public var headers: HTTPHeaders = [:]

    private let apiHandler: StripeAPIHandler
    private let creditGrants = APIBase + APIVersion + "billing/credit_grants"
    private let creditBalanceSummary = APIBase + APIVersion + "billing/credit_balance_summary"
    private let creditBalanceTransactions =
        APIBase + APIVersion + "billing/credit_balance_transactions"

    init(apiHandler: StripeAPIHandler) {
        self.apiHandler = apiHandler
    }

    public func create(
        amount: [String: Any],
        applicabilityConfig: [String: Any],
        category: CreditGrantCategory,
        customer: String,
        effectiveAt: Date? = nil,
        expiresAt: Date? = nil,
        metadata: [String: String]? = nil,
        name: String? = nil,
        expand: [String]? = nil
    ) async throws -> CreditGrant {
        var body: [String: Any] = ["customer": customer, "category": category.rawValue]
        amount.forEach { body["amount[\($0)]"] = $1 }
        applicabilityConfig.forEach { body["applicability_config[\($0)]"] = $1 }
        if let effectiveAt { body["effective_at"] = Int(effectiveAt.timeIntervalSince1970) }
        if let expiresAt { body["expires_at"] = Int(expiresAt.timeIntervalSince1970) }
        if let metadata { metadata.forEach { body["metadata[\($0)]"] = $1 } }
        if let name { body["name"] = name }
        if let expand { body["expand"] = expand }
        return try await apiHandler.send(
            method: .POST, path: creditGrants, body: .string(body.queryParameters), headers: headers
        )
    }

    public func update(
        id: String,
        expiresAt: Date? = nil,
        metadata: [String: String]? = nil,
        expand: [String]? = nil
    ) async throws -> CreditGrant {
        var body: [String: Any] = [:]
        if let expiresAt { body["expires_at"] = Int(expiresAt.timeIntervalSince1970) }
        if let metadata { metadata.forEach { body["metadata[\($0)]"] = $1 } }
        if let expand { body["expand"] = expand }
        return try await apiHandler.send(
            method: .POST, path: "\(creditGrants)/\(id)", body: .string(body.queryParameters),
            headers: headers)
    }

    public func retrieve(id: String, expand: [String]? = nil) async throws -> CreditGrant {
        var queryParams = ""
        if let expand { queryParams = ["expand": expand].queryParameters }
        return try await apiHandler.send(
            method: .GET, path: "\(creditGrants)/\(id)", query: queryParams, headers: headers)
    }

    public func listAll(filter: [String: Any]? = nil) async throws -> CreditGrantList {
        var queryParams = ""
        if let filter { queryParams = filter.queryParameters }
        return try await apiHandler.send(
            method: .GET, path: creditGrants, query: queryParams, headers: headers)
    }

    public func expire(id: String, expand: [String]? = nil) async throws -> CreditGrant {
        var body: [String: Any] = [:]
        if let expand { body["expand"] = expand }
        return try await apiHandler.send(
            method: .POST, path: "\(creditGrants)/\(id)/expire",
            body: .string(body.queryParameters), headers: headers)
    }

    public func void(id: String, expand: [String]? = nil) async throws -> CreditGrant {
        var body: [String: Any] = [:]
        if let expand { body["expand"] = expand }
        return try await apiHandler.send(
            method: .POST, path: "\(creditGrants)/\(id)/void", body: .string(body.queryParameters),
            headers: headers)
    }

    public func retrieveCreditBalanceSummary(customer: String, filter: [String: Any]? = nil)
        async throws -> CreditBalanceSummary
    {
        var queryParams = "customer=\(customer)"
        if let filter { queryParams += "&" + filter.queryParameters }
        return try await apiHandler.send(
            method: .GET, path: creditBalanceSummary, query: queryParams, headers: headers)
    }

    public func retrieveCreditBalanceTransaction(id: String, expand: [String]? = nil) async throws
        -> CreditBalanceTransaction
    {
        var queryParams = ""
        if let expand { queryParams = ["expand": expand].queryParameters }
        return try await apiHandler.send(
            method: .GET, path: "\(creditBalanceTransactions)/\(id)", query: queryParams,
            headers: headers)
    }

    public func listCreditBalanceTransactions(filter: [String: Any]? = nil) async throws
        -> CreditBalanceTransactionList
    {
        var queryParams = ""
        if let filter { queryParams = filter.queryParameters }
        return try await apiHandler.send(
            method: .GET, path: creditBalanceTransactions, query: queryParams, headers: headers)
    }
}
