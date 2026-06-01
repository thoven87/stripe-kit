//
//  Meter.swift
//  stripe-kit
//

import Foundation

/// The [Meter Object](https://docs.stripe.com/api/billing/meter/object).
///
/// Meters specify how to aggregate meter events over a billing period. Meter events represent the
/// actions that customers take in your system. Meters attach to prices and form the basis of the bill.
public struct Meter: Codable, Sendable {
    /// Unique identifier for the object.
    public var id: String
    /// String representing the object's type. Objects of the same type share the same value.
    public var object: String
    /// Time at which the object was created. Measured in seconds since the Unix epoch.
    public var created: Date?
    /// Fields that specify how to map a meter event to a customer.
    public var customerMapping: MeterCustomerMapping
    /// The default settings to aggregate a meter's events with.
    public var defaultAggregation: MeterDefaultAggregation
    /// The meter's name.
    public var displayName: String
    /// The name of the meter event to record usage for. Corresponds with the `event_name` field on meter events.
    public var eventName: String
    /// The time window to pre-aggregate meter events for, if any.
    public var eventTimeWindow: MeterEventTimeWindow?
    /// Has the value `true` if the object exists in live mode or the value `false` if the object exists in test mode.
    public var livemode: Bool?
    /// The meter's status.
    public var status: MeterStatus
    /// The timestamps at which the meter status changed.
    public var statusTransitions: MeterStatusTransitions?
    /// Time at which the object was last updated. Measured in seconds since the Unix epoch.
    public var updated: Date
    /// Fields that specify how to calculate a meter event's value.
    public var valueSettings: MeterValueSettings

    public init(
        id: String,
        object: String,
        created: Date? = nil,
        customerMapping: MeterCustomerMapping,
        defaultAggregation: MeterDefaultAggregation,
        displayName: String,
        eventName: String,
        eventTimeWindow: MeterEventTimeWindow? = nil,
        livemode: Bool? = nil,
        status: MeterStatus,
        statusTransitions: MeterStatusTransitions? = nil,
        updated: Date,
        valueSettings: MeterValueSettings
    ) {
        self.id = id
        self.object = object
        self.created = created
        self.customerMapping = customerMapping
        self.defaultAggregation = defaultAggregation
        self.displayName = displayName
        self.eventName = eventName
        self.eventTimeWindow = eventTimeWindow
        self.livemode = livemode
        self.status = status
        self.statusTransitions = statusTransitions
        self.updated = updated
        self.valueSettings = valueSettings
    }
}

public struct MeterCustomerMapping: Codable, Sendable {
    /// The key in the meter event payload to use for mapping the event to a customer.
    public var eventPayloadKey: String
    /// The method for mapping a meter event to a customer.
    public var type: MeterCustomerMappingType

    public init(eventPayloadKey: String, type: MeterCustomerMappingType) {
        self.eventPayloadKey = eventPayloadKey
        self.type = type
    }
}

public enum MeterCustomerMappingType: String, Codable, Sendable {
    /// Map a meter event to a customer by passing a customer ID in the event's payload.
    case byID = "by_id"
}

public enum MeterEventTimeWindow: String, Codable, Sendable {
    /// Events are pre-aggregated in daily buckets.
    case day
    /// Events are pre-aggregated in hourly buckets.
    case hour
}

public enum MeterStatus: String, Codable, Sendable {
    /// The meter is active.
    case active
    /// The meter is inactive. No more events for this meter will be accepted. The meter cannot be attached to a price.
    case inactive
}

public struct MeterStatusTransitions: Codable, Sendable {
    /// The time the meter was deactivated, if any. Measured in seconds since Unix epoch.
    public var deactivatedAt: Date?

    public init(deactivatedAt: Date? = nil) {
        self.deactivatedAt = deactivatedAt
    }
}

public struct MeterValueSettings: Codable, Sendable {
    /// The key in the meter event payload to use as the value for this meter.
    public var eventPayloadKey: String

    public init(eventPayloadKey: String) {
        self.eventPayloadKey = eventPayloadKey
    }
}

public struct MeterDefaultAggregation: Codable, Sendable {
    public var formula: MeterDefaultAggregationFormula

    public init(formula: MeterDefaultAggregationFormula) {
        self.formula = formula
    }
}

public enum MeterDefaultAggregationFormula: String, Codable, Sendable {
    /// Count the number of events.
    case count
    /// Sum each event's value.
    case sum
    /// Use the last event's value in the period.
    case last
    /// Use the maximum event's value in the period.
    case max
}

public struct MeterList: Codable, Sendable {
    public var object: String
    public var hasMore: Bool?
    public var url: String?
    public var data: [Meter]?

    public init(
        object: String,
        hasMore: Bool? = nil,
        url: String? = nil,
        data: [Meter]? = nil
    ) {
        self.object = object
        self.hasMore = hasMore
        self.url = url
        self.data = data
    }
}
