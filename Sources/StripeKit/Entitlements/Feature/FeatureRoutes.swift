//
//  FeatureRoutes.swift
//  stripe-kit
//

import Foundation
import NIO
import NIOHTTP1

public protocol FeatureRoutes: StripeAPIRoute {
    /// Creates a feature.
    ///
    /// - Parameters:
    ///  - lookupKey: A unique key you provide as your own system identifier. This may be up to 80 characters.
    ///  - name: The feature's name, for your own purpose, not meant to be displayable to the customer.
    ///  - metadata: Set of key-value pairs that you can attach to an object.
    /// - Returns: Returns a feature
    func create(
        lookupKey: String,
        name: String,
        metadata: [String: String]?
    ) async throws -> Feature

    /// Retrieve a list of features.
    ///
    /// - Parameters:
    ///  - filter: A dictionary that will be used for the query parameters.
    /// - Returns: Returns a list of your features
    func listAll(filter: [String: Any]?) async throws -> FeatureList

    /// Update a feature's metadata or permanently deactivate it.
    ///
    /// - Parameters:
    ///  - id: Unique identifier for the object.
    ///  - metadata: Set of key-value pairs that you can attach to an object.
    ///  - name: The feature's name, for your own purpose, not meant to be displayable to the customer.
    ///  - active: Inactive features cannot be attached to new products and will not be returned from the features list endpoint.
    /// - Returns: The updated feature
    func update(
        id: String,
        metadata: [String: String]?,
        name: String?,
        active: Bool?
    ) async throws -> Feature
}

public struct StripeFeatureRoutes: FeatureRoutes {
    public var headers: HTTPHeaders = [:]

    private let apiHandler: StripeAPIHandler
    private let features = APIBase + APIVersion + "entitlements/features"

    init(apiHandler: StripeAPIHandler) {
        self.apiHandler = apiHandler
    }

    public func create(
        lookupKey: String,
        name: String,
        metadata: [String: String]?
    ) async throws -> Feature {
        var body: [String: Any] = [
            "lookup_key": lookupKey,
            "name": name,
        ]

        if let metadata {
            metadata.forEach { body["metadata[\($0)]"] = $1 }
        }

        return try await apiHandler.send(
            method: .POST, path: features, body: .string(body.queryParameters), headers: headers)
    }

    public func listAll(filter: [String: Any]? = nil) async throws -> FeatureList {
        var queryParams = ""
        if let filter {
            queryParams = filter.queryParameters
        }
        return try await apiHandler.send(
            method: .GET, path: features, query: queryParams, headers: headers)
    }

    public func update(
        id: String,
        metadata: [String: String]?,
        name: String?,
        active: Bool?
    ) async throws -> Feature {
        var body: [String: Any] = [:]

        if let metadata {
            metadata.forEach { body["metadata[\($0)]"] = $1 }
        }

        if let name {
            body["name"] = name
        }

        if let active {
            body["active"] = active
        }

        return try await apiHandler.send(
            method: .POST, path: "\(features)/\(id)", body: .string(body.queryParameters),
            headers: headers)
    }
}
