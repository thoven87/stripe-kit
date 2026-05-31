//
//  BillingAlertRoutes.swift
//  stripe-kit
//

import Foundation
import NIO
import NIOHTTP1

public protocol BillingAlertRoutes: StripeAPIRoute {
    /// Creates a billing alert.
    ///
    /// - Parameters:
    ///   - title: The title of the alert.
    ///   - alertType: Defines the type of the alert.
    ///   - usageThreshold: The configuration of the usage threshold.
    ///   - expand: Specifies which fields in the response should be expanded.
    func create(
        title: String,
        alertType: BillingAlertType,
        usageThreshold: [String: Any]?,
        expand: [String]?
    ) async throws -> BillingAlert

    /// Retrieves a billing alert.
    ///
    /// - Parameters:
    ///   - id: The ID of the billing alert.
    ///   - expand: Specifies which fields in the response should be expanded.
    func retrieve(id: String, expand: [String]?) async throws -> BillingAlert

    /// Lists billing alerts.
    ///
    /// - Parameter filter: A dictionary of query parameters.
    func listAll(filter: [String: Any]?) async throws -> BillingAlertList

    /// Archives a billing alert, removing it from the list view and disabling its functionality.
    ///
    /// - Parameters:
    ///   - id: The ID of the billing alert.
    ///   - expand: Specifies which fields in the response should be expanded.
    func archive(id: String, expand: [String]?) async throws -> BillingAlert

    /// Unarchives a billing alert.
    ///
    /// - Parameters:
    ///   - id: The ID of the billing alert.
    ///   - expand: Specifies which fields in the response should be expanded.
    func activate(id: String, expand: [String]?) async throws -> BillingAlert
}

public struct StripeBillingAlertRoutes: BillingAlertRoutes {
    public var headers: HTTPHeaders = [:]

    private let apiHandler: StripeAPIHandler
    private let alerts = APIBase + APIVersion + "billing/alerts"

    init(apiHandler: StripeAPIHandler) {
        self.apiHandler = apiHandler
    }

    public func create(
        title: String,
        alertType: BillingAlertType,
        usageThreshold: [String: Any]? = nil,
        expand: [String]? = nil
    ) async throws -> BillingAlert {
        var body: [String: Any] = [
            "title": title,
            "alert_type": alertType.rawValue,
        ]
        if let usageThreshold {
            usageThreshold.forEach { body["usage_threshold[\($0)]"] = $1 }
        }
        if let expand { body["expand"] = expand }
        return try await apiHandler.send(
            method: .POST, path: alerts, body: .string(body.queryParameters), headers: headers)
    }

    public func retrieve(id: String, expand: [String]? = nil) async throws -> BillingAlert {
        var queryParams = ""
        if let expand { queryParams = ["expand": expand].queryParameters }
        return try await apiHandler.send(
            method: .GET, path: "\(alerts)/\(id)", query: queryParams, headers: headers)
    }

    public func listAll(filter: [String: Any]? = nil) async throws -> BillingAlertList {
        var queryParams = ""
        if let filter { queryParams = filter.queryParameters }
        return try await apiHandler.send(
            method: .GET, path: alerts, query: queryParams, headers: headers)
    }

    public func archive(id: String, expand: [String]? = nil) async throws -> BillingAlert {
        var body: [String: Any] = [:]
        if let expand { body["expand"] = expand }
        return try await apiHandler.send(
            method: .POST, path: "\(alerts)/\(id)/archive", body: .string(body.queryParameters),
            headers: headers)
    }

    public func activate(id: String, expand: [String]? = nil) async throws -> BillingAlert {
        var body: [String: Any] = [:]
        if let expand { body["expand"] = expand }
        return try await apiHandler.send(
            method: .POST, path: "\(alerts)/\(id)/activate", body: .string(body.queryParameters),
            headers: headers)
    }
}
