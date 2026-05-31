//
//  ConfirmationTokenRoutes.swift
//  stripe-kit
//

import Foundation
import NIO
import NIOHTTP1

public protocol ConfirmationTokenRoutes: StripeAPIRoute {
    /// Retrieves an existing ConfirmationToken object.
    ///
    /// - Parameter id: The ID of the ConfirmationToken to retrieve.
    /// - Returns: Returns a ConfirmationToken object.
    func retrieve(id: String) async throws -> ConfirmationToken
}

public struct StripeConfirmationTokenRoutes: ConfirmationTokenRoutes {
    public var headers: HTTPHeaders = [:]

    private let apiHandler: StripeAPIHandler
    private let confirmationTokens = APIBase + APIVersion + "confirmation_tokens"

    init(apiHandler: StripeAPIHandler) {
        self.apiHandler = apiHandler
    }

    public func retrieve(id: String) async throws -> ConfirmationToken {
        try await apiHandler.send(
            method: .GET, path: "\(confirmationTokens)/\(id)", headers: headers)
    }
}
