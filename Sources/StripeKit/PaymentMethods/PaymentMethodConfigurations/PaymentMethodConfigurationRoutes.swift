//
//  PaymentMethodConfigurationRoutes.swift
//  stripe-kit
//

import Foundation
import NIO
import NIOHTTP1

public protocol PaymentMethodConfigurationRoutes: StripeAPIRoute {
    /// Creates a payment method configuration.
    ///
    /// - Parameters:
    ///   - name: Configuration name. Required unless parent is provided.
    ///   - parent: Configuration's parent configuration. Required unless name is provided.
    ///   - params: A dictionary of payment-method-specific configuration. Each key is a payment method type (e.g. "card", "alipay") with a display_preference hash.
    ///   - expand: Specifies which fields in the response should be expanded.
    func create(
        name: String?,
        parent: String?,
        params: [String: Any]?,
        expand: [String]?
    ) async throws -> PaymentMethodConfiguration

    /// Update payment method configuration.
    ///
    /// - Parameters:
    ///   - id: The configuration ID.
    ///   - active: Whether the configuration can be used for new payments.
    ///   - name: Configuration name.
    ///   - params: A dictionary of payment-method-specific configuration.
    ///   - expand: Specifies which fields in the response should be expanded.
    func update(
        id: String,
        active: Bool?,
        name: String?,
        params: [String: Any]?,
        expand: [String]?
    ) async throws -> PaymentMethodConfiguration

    /// Retrieve a payment method configuration.
    ///
    /// - Parameters:
    ///   - id: The configuration ID.
    ///   - expand: Specifies which fields in the response should be expanded.
    func retrieve(id: String, expand: [String]?) async throws -> PaymentMethodConfiguration

    /// List payment method configurations.
    ///
    /// - Parameter filter: A dictionary of query parameters.
    func listAll(filter: [String: Any]?) async throws -> PaymentMethodConfigurationList
}

public struct StripePaymentMethodConfigurationRoutes: PaymentMethodConfigurationRoutes {
    public var headers: HTTPHeaders = [:]

    private let apiHandler: StripeAPIHandler
    private let configurations = APIBase + APIVersion + "payment_method_configurations"

    init(apiHandler: StripeAPIHandler) {
        self.apiHandler = apiHandler
    }

    public func create(
        name: String? = nil,
        parent: String? = nil,
        params: [String: Any]? = nil,
        expand: [String]? = nil
    ) async throws -> PaymentMethodConfiguration {
        var body: [String: Any] = [:]

        if let name { body["name"] = name }
        if let parent { body["parent"] = parent }
        if let params { params.forEach { body[$0] = $1 } }
        if let expand { body["expand"] = expand }

        return try await apiHandler.send(
            method: .POST, path: configurations, body: .string(body.queryParameters),
            headers: headers)
    }

    public func update(
        id: String,
        active: Bool? = nil,
        name: String? = nil,
        params: [String: Any]? = nil,
        expand: [String]? = nil
    ) async throws -> PaymentMethodConfiguration {
        var body: [String: Any] = [:]

        if let active { body["active"] = active }
        if let name { body["name"] = name }
        if let params { params.forEach { body[$0] = $1 } }
        if let expand { body["expand"] = expand }

        return try await apiHandler.send(
            method: .POST, path: "\(configurations)/\(id)", body: .string(body.queryParameters),
            headers: headers)
    }

    public func retrieve(id: String, expand: [String]? = nil) async throws
        -> PaymentMethodConfiguration
    {
        var queryParams = ""
        if let expand { queryParams = ["expand": expand].queryParameters }
        return try await apiHandler.send(
            method: .GET, path: "\(configurations)/\(id)", query: queryParams, headers: headers)
    }

    public func listAll(filter: [String: Any]? = nil) async throws -> PaymentMethodConfigurationList
    {
        var queryParams = ""
        if let filter { queryParams = filter.queryParameters }
        return try await apiHandler.send(
            method: .GET, path: configurations, query: queryParams, headers: headers)
    }
}
