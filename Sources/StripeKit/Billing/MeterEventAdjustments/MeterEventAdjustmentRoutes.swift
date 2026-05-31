//
//  MeterEventAdjustmentRoutes.swift
//  stripe-kit
//

import Foundation
import NIO
import NIOHTTP1

public protocol MeterEventAdjustmentRoutes: StripeAPIRoute {
    /// Creates a billing meter event adjustment.
    ///
    /// - Parameters:
    ///   - eventName: The name of the meter event being adjusted.
    ///   - type: Specifies whether to cancel a single event or a range of events. Currently only `cancel` is supported.
    ///   - cancel: Specifies which event to cancel. Required if `type` is `cancel`.
    ///   - expand: Specifies which fields in the response should be expanded.
    func create(
        eventName: String,
        type: MeterEventAdjustmentType,
        cancel: [String: Any]?,
        expand: [String]?
    ) async throws -> MeterEventAdjustment
}

public struct StripeMeterEventAdjustmentRoutes: MeterEventAdjustmentRoutes {
    public var headers: HTTPHeaders = [:]

    private let apiHandler: StripeAPIHandler
    private let adjustments = APIBase + APIVersion + "billing/meter_event_adjustments"

    init(apiHandler: StripeAPIHandler) {
        self.apiHandler = apiHandler
    }

    public func create(
        eventName: String,
        type: MeterEventAdjustmentType,
        cancel: [String: Any]? = nil,
        expand: [String]? = nil
    ) async throws -> MeterEventAdjustment {
        var body: [String: Any] = [
            "event_name": eventName,
            "type": type.rawValue,
        ]
        if let cancel {
            cancel.forEach { body["cancel[\($0)]"] = $1 }
        }
        if let expand { body["expand"] = expand }
        return try await apiHandler.send(
            method: .POST, path: adjustments, body: .string(body.queryParameters), headers: headers)
    }
}
