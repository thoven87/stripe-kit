//
//  PaymentMethodDomainRoutes.swift
//  stripe-kit
//

import Foundation
import NIO
import NIOHTTP1

public protocol PaymentMethodDomainRoutes: StripeAPIRoute {
    /// Creates a payment method domain.
    ///
    /// - Parameters:
    ///   - domainName: The domain name that this payment method domain object represents.
    ///   - enabled: Whether this payment method domain is enabled.
    ///   - expand: Specifies which fields in the response should be expanded.
    func create(domainName: String, enabled: Bool?, expand: [String]?) async throws
        -> PaymentMethodDomain

    /// Updates an existing payment method domain.
    ///
    /// - Parameters:
    ///   - id: The payment method domain ID.
    ///   - enabled: Whether this payment method domain is enabled.
    ///   - expand: Specifies which fields in the response should be expanded.
    func update(id: String, enabled: Bool?, expand: [String]?) async throws -> PaymentMethodDomain

    /// Retrieves the details of an existing payment method domain.
    ///
    /// - Parameters:
    ///   - id: The payment method domain ID.
    ///   - expand: Specifies which fields in the response should be expanded.
    func retrieve(id: String, expand: [String]?) async throws -> PaymentMethodDomain

    /// Lists the details of existing payment method domains.
    ///
    /// - Parameter filter: A dictionary of query parameters.
    func listAll(filter: [String: Any]?) async throws -> PaymentMethodDomainList

    /// Validates an existing payment method domain.
    ///
    /// - Parameters:
    ///   - id: The payment method domain ID.
    ///   - expand: Specifies which fields in the response should be expanded.
    func validate(id: String, expand: [String]?) async throws -> PaymentMethodDomain
}

public struct StripePaymentMethodDomainRoutes: PaymentMethodDomainRoutes {
    public var headers: HTTPHeaders = [:]

    private let apiHandler: StripeAPIHandler
    private let domains = APIBase + APIVersion + "payment_method_domains"

    init(apiHandler: StripeAPIHandler) {
        self.apiHandler = apiHandler
    }

    public func create(domainName: String, enabled: Bool? = nil, expand: [String]? = nil)
        async throws -> PaymentMethodDomain
    {
        var body: [String: Any] = ["domain_name": domainName]
        if let enabled { body["enabled"] = enabled }
        if let expand { body["expand"] = expand }
        return try await apiHandler.send(
            method: .POST, path: domains, body: .string(body.queryParameters), headers: headers)
    }

    public func update(id: String, enabled: Bool? = nil, expand: [String]? = nil) async throws
        -> PaymentMethodDomain
    {
        var body: [String: Any] = [:]
        if let enabled { body["enabled"] = enabled }
        if let expand { body["expand"] = expand }
        return try await apiHandler.send(
            method: .POST, path: "\(domains)/\(id)", body: .string(body.queryParameters),
            headers: headers)
    }

    public func retrieve(id: String, expand: [String]? = nil) async throws -> PaymentMethodDomain {
        var queryParams = ""
        if let expand { queryParams = ["expand": expand].queryParameters }
        return try await apiHandler.send(
            method: .GET, path: "\(domains)/\(id)", query: queryParams, headers: headers)
    }

    public func listAll(filter: [String: Any]? = nil) async throws -> PaymentMethodDomainList {
        var queryParams = ""
        if let filter { queryParams = filter.queryParameters }
        return try await apiHandler.send(
            method: .GET, path: domains, query: queryParams, headers: headers)
    }

    public func validate(id: String, expand: [String]? = nil) async throws -> PaymentMethodDomain {
        var body: [String: Any] = [:]
        if let expand { body["expand"] = expand }
        return try await apiHandler.send(
            method: .POST, path: "\(domains)/\(id)/validate", body: .string(body.queryParameters),
            headers: headers)
    }
}
