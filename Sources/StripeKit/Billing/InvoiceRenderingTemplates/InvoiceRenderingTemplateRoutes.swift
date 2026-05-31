//
//  InvoiceRenderingTemplateRoutes.swift
//  stripe-kit
//

import Foundation
import NIO
import NIOHTTP1

public protocol InvoiceRenderingTemplateRoutes: StripeAPIRoute {
    /// Retrieves an invoice rendering template with the given ID.
    ///
    /// - Parameters:
    ///   - id: The ID of the invoice rendering template.
    ///   - expand: Specifies which fields in the response should be expanded.
    func retrieve(id: String, expand: [String]?) async throws -> InvoiceRenderingTemplate

    /// List all templates, ordered by creation date.
    ///
    /// - Parameter filter: A dictionary of query parameters.
    func listAll(filter: [String: Any]?) async throws -> InvoiceRenderingTemplateList

    /// Updates the status of an invoice rendering template to 'archived'.
    ///
    /// - Parameters:
    ///   - id: The ID of the invoice rendering template.
    ///   - expand: Specifies which fields in the response should be expanded.
    func archive(id: String, expand: [String]?) async throws -> InvoiceRenderingTemplate

    /// Unarchives an invoice rendering template.
    ///
    /// - Parameters:
    ///   - id: The ID of the invoice rendering template.
    ///   - expand: Specifies which fields in the response should be expanded.
    func unarchive(id: String, expand: [String]?) async throws -> InvoiceRenderingTemplate
}

public struct StripeInvoiceRenderingTemplateRoutes: InvoiceRenderingTemplateRoutes {
    public var headers: HTTPHeaders = [:]

    private let apiHandler: StripeAPIHandler
    private let templates = APIBase + APIVersion + "invoice_rendering_templates"

    init(apiHandler: StripeAPIHandler) {
        self.apiHandler = apiHandler
    }

    public func retrieve(id: String, expand: [String]? = nil) async throws
        -> InvoiceRenderingTemplate
    {
        var queryParams = ""
        if let expand { queryParams = ["expand": expand].queryParameters }
        return try await apiHandler.send(
            method: .GET, path: "\(templates)/\(id)", query: queryParams, headers: headers)
    }

    public func listAll(filter: [String: Any]? = nil) async throws -> InvoiceRenderingTemplateList {
        var queryParams = ""
        if let filter { queryParams = filter.queryParameters }
        return try await apiHandler.send(
            method: .GET, path: templates, query: queryParams, headers: headers)
    }

    public func archive(id: String, expand: [String]? = nil) async throws
        -> InvoiceRenderingTemplate
    {
        var body: [String: Any] = [:]
        if let expand { body["expand"] = expand }
        return try await apiHandler.send(
            method: .POST, path: "\(templates)/\(id)/archive", body: .string(body.queryParameters),
            headers: headers)
    }

    public func unarchive(id: String, expand: [String]? = nil) async throws
        -> InvoiceRenderingTemplate
    {
        var body: [String: Any] = [:]
        if let expand { body["expand"] = expand }
        return try await apiHandler.send(
            method: .POST, path: "\(templates)/\(id)/unarchive",
            body: .string(body.queryParameters), headers: headers)
    }
}
