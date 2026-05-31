//
//  MeterRoutes.swift
//  stripe-kit
//

import Foundation
import NIO
import NIOHTTP1

/// Meters specify how to aggregate meter events over a billing period. Meter events represent the
/// actions that customers take in your system. Meters attach to prices and form the basis of the bill.
///
/// Related guide: [Usage based billing](https://docs.stripe.com/billing/subscriptions/usage-based).
public protocol MeterRoutes: StripeAPIRoute {
    /// Creates a billing meter.
    ///
    /// - Parameters:
    ///  - defaultAggregation: The default settings to aggregate a meter's events with.
    ///  - displayName: The meter's name. Not visible to the customer.
    ///  - eventName: The name of the meter event to record usage for. Corresponds with the `event_name` field on meter events.
    ///  - customerMapping: Fields that specify how to map a meter event to a customer.
    ///  - eventTimeWindow: The time window to pre-aggregate meter events for, if any.
    ///  - valueSettings: Fields that specify how to calculate a meter event's value.
    func create(
        defaultAggregation: MeterDefaultAggregation,
        displayName: String,
        eventName: String,
        customerMapping: MeterCustomerMapping?,
        eventTimeWindow: MeterEventTimeWindow?,
        valueSettings: MeterValueSettings?
    ) async throws -> Meter

    /// Updates a billing meter.
    ///
    /// - Parameters:
    ///  - id: Unique identifier for the object.
    ///  - displayName: The meter's name. Not visible to the customer.
    func update(id: String, displayName: String?) async throws -> Meter

    /// Retrieves a billing meter.
    ///
    /// - Parameters:
    ///  - id: Unique identifier for the object.
    func retrieve(id: String) async throws -> Meter

    /// Returns a list of your billing meters.
    func listAll() async throws -> MeterList

    /// Deactivates a billing meter.
    ///
    /// - Parameters:
    ///  - id: Unique identifier for the object.
    func deactivate(id: String) async throws -> Meter

    /// Reactivates a billing meter.
    ///
    /// - Parameters:
    ///  - id: Unique identifier for the object.
    func reactivate(id: String) async throws -> Meter

    /// Retrieve event summaries for a meter.
    ///
    /// - Parameters:
    ///  - customer: The customer for which to fetch event summaries.
    ///  - endTime: The timestamp from when to stop aggregating meter events (exclusive).
    ///  - id: The ID of the meter.
    ///  - startTime: The timestamp from when to start aggregating meter events (inclusive).
    ///  - valueGroupingWindow: Specifies what granularity to use when generating event summaries.
    ///  - endingBefore: A cursor for use in pagination.
    ///  - limit: A limit on the number of objects to be returned.
    ///  - startingAfter: A cursor for use in pagination.
    func eventSummaries(
        customer: String,
        endTime: Date,
        id: String,
        startTime: Date,
        valueGroupingWindow: MeterEventSummaryValueGroupingWindow?,
        endingBefore: String?,
        limit: Int?,
        startingAfter: String?
    ) async throws -> MeterEventSummaryList
}

public struct StripeMeterRoutes: MeterRoutes {
    public var headers: HTTPHeaders = [:]

    private let apiHandler: StripeAPIHandler
    private let meters = APIBase + APIVersion + "billing/meters"

    init(apiHandler: StripeAPIHandler) {
        self.apiHandler = apiHandler
    }

    public func create(
        defaultAggregation: MeterDefaultAggregation,
        displayName: String,
        eventName: String,
        customerMapping: MeterCustomerMapping?,
        eventTimeWindow: MeterEventTimeWindow?,
        valueSettings: MeterValueSettings?
    ) async throws -> Meter {
        var body: [String: Any] = [
            "default_aggregation[formula]": defaultAggregation.formula.rawValue,
            "display_name": displayName,
            "event_name": eventName,
        ]

        if let customerMapping {
            body["customer_mapping[event_payload_key]"] = customerMapping.eventPayloadKey
            body["customer_mapping[type]"] = customerMapping.type.rawValue
        }

        if let eventTimeWindow {
            body["event_time_window"] = eventTimeWindow.rawValue
        }

        if let valueSettings {
            body["value_settings[event_payload_key]"] = valueSettings.eventPayloadKey
        }

        return try await apiHandler.send(
            method: .POST,
            path: meters,
            body: .string(body.queryParameters),
            headers: headers)
    }

    public func update(id: String, displayName: String?) async throws -> Meter {
        var body: [String: Any] = [:]

        if let displayName {
            body["display_name"] = displayName
        }

        return try await apiHandler.send(
            method: .POST,
            path: "\(meters)/\(id)",
            body: .string(body.queryParameters),
            headers: headers)
    }

    public func retrieve(id: String) async throws -> Meter {
        try await apiHandler.send(method: .GET, path: "\(meters)/\(id)", headers: headers)
    }

    public func listAll() async throws -> MeterList {
        try await apiHandler.send(method: .GET, path: meters, headers: headers)
    }

    public func deactivate(id: String) async throws -> Meter {
        try await apiHandler.send(
            method: .POST, path: "\(meters)/\(id)/deactivate", headers: headers)
    }

    public func reactivate(id: String) async throws -> Meter {
        try await apiHandler.send(
            method: .POST, path: "\(meters)/\(id)/reactivate", headers: headers)
    }

    public func eventSummaries(
        customer: String,
        endTime: Date,
        id: String,
        startTime: Date,
        valueGroupingWindow: MeterEventSummaryValueGroupingWindow?,
        endingBefore: String?,
        limit: Int?,
        startingAfter: String?
    ) async throws -> MeterEventSummaryList {
        var queryParams: [String: Any] = [
            "customer": customer,
            "end_time": Int(endTime.timeIntervalSince1970),
            "start_time": Int(startTime.timeIntervalSince1970),
        ]

        if let valueGroupingWindow {
            queryParams["value_grouping_window"] = valueGroupingWindow.rawValue
        }

        if let endingBefore {
            queryParams["ending_before"] = endingBefore
        }

        if let limit {
            queryParams["limit"] = limit
        }

        if let startingAfter {
            queryParams["starting_after"] = startingAfter
        }

        return try await apiHandler.send(
            method: .GET,
            path: "\(meters)/\(id)/event_summaries",
            query: queryParams.queryParameters,
            headers: headers)
    }
}
