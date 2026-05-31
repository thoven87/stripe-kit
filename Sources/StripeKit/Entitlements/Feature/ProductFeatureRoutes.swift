//
//  ProductFeatureRoutes.swift
//  stripe-kit
//

import Foundation
import NIO
import NIOHTTP1

public protocol ProductFeatureRoutes: StripeAPIRoute {
    /// List all features attached to a product.
    ///
    /// - Parameters:
    ///  - product: The ID of the product whose features will be retrieved.
    ///  - filter: A dictionary that will be used for the query parameters.
    /// - Returns: Returns a list of features for a product
    func listAll(product: String, filter: [String: Any]?) async throws -> ProductFeatureList

    /// Attach a feature to a product.
    ///
    /// Creates a product_feature, which represents a feature attachment to a product.
    ///
    /// - Parameters:
    ///  - product: The ID of the product to which the feature will be attached.
    ///  - entitlementFeature: The ID of the Feature object attached to this product.
    /// - Returns: Returns a product_feature
    func attachFeatureToProduct(
        product: String,
        entitlementFeature: String
    ) async throws -> ProductFeature

    /// Remove a feature from a product.
    ///
    /// Deletes the feature attachment to a product.
    ///
    /// - Parameters:
    ///  - product: The ID of the product.
    ///  - entitlementFeature: The ID of the product_feature to remove.
    /// - Returns: Returns an object with a deleted parameter on success.
    func removeFeatureFromProduct(
        product: String,
        entitlementFeature: String
    ) async throws -> DeletedObject
}

public struct StripeProductFeatureRoutes: ProductFeatureRoutes {
    public var headers: HTTPHeaders = [:]

    private let apiHandler: StripeAPIHandler
    private let products = APIBase + APIVersion + "products"

    init(apiHandler: StripeAPIHandler) {
        self.apiHandler = apiHandler
    }

    public func listAll(product: String, filter: [String: Any]?) async throws -> ProductFeatureList
    {
        var queryParams = ""
        if let filter {
            queryParams = filter.queryParameters
        }
        return try await apiHandler.send(
            method: .GET, path: "\(products)/\(product)/features", query: queryParams,
            headers: headers)
    }

    public func attachFeatureToProduct(
        product: String,
        entitlementFeature: String
    ) async throws -> ProductFeature {
        let body: [String: Any] = ["entitlement_feature": entitlementFeature]
        return try await apiHandler.send(
            method: .POST, path: "\(products)/\(product)/features",
            body: .string(body.queryParameters), headers: headers)
    }

    public func removeFeatureFromProduct(
        product: String,
        entitlementFeature: String
    ) async throws -> DeletedObject {
        try await apiHandler.send(
            method: .DELETE,
            path: "\(products)/\(product)/features/\(entitlementFeature)",
            headers: headers)
    }
}
