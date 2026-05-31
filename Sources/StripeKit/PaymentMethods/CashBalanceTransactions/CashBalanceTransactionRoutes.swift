//
//  CashBalanceTransactionRoutes.swift
//  stripe-kit
//

import Foundation
import NIO
import NIOHTTP1

public protocol CashBalanceTransactionRoutes: StripeAPIRoute {
    /// Retrieves a specific cash balance transaction, which updated the customer's cash balance.
    ///
    /// - Parameters:
    ///   - customer: The ID of the customer.
    ///   - transaction: The ID of the cash balance transaction.
    ///   - expand: Specifies which fields in the response should be expanded.
    func retrieve(customer: String, transaction: String, expand: [String]?) async throws
        -> CashBalanceTransaction

    /// Returns a list of transactions that modified the customer's cash balance.
    ///
    /// - Parameters:
    ///   - customer: The ID of the customer.
    ///   - filter: A dictionary of query parameters.
    func listAll(customer: String, filter: [String: Any]?) async throws
        -> CashBalanceTransactionList
}

public struct StripeCashBalanceTransactionRoutes: CashBalanceTransactionRoutes {
    public var headers: HTTPHeaders = [:]

    private let apiHandler: StripeAPIHandler
    private let customers = APIBase + APIVersion + "customers"

    init(apiHandler: StripeAPIHandler) {
        self.apiHandler = apiHandler
    }

    public func retrieve(customer: String, transaction: String, expand: [String]? = nil)
        async throws -> CashBalanceTransaction
    {
        var queryParams = ""
        if let expand { queryParams = ["expand": expand].queryParameters }
        return try await apiHandler.send(
            method: .GET,
            path: "\(customers)/\(customer)/cash_balance_transactions/\(transaction)",
            query: queryParams,
            headers: headers)
    }

    public func listAll(customer: String, filter: [String: Any]? = nil) async throws
        -> CashBalanceTransactionList
    {
        var queryParams = ""
        if let filter { queryParams = filter.queryParameters }
        return try await apiHandler.send(
            method: .GET,
            path: "\(customers)/\(customer)/cash_balance_transactions",
            query: queryParams,
            headers: headers)
    }
}
