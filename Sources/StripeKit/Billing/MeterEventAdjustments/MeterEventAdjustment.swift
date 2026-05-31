//
//  MeterEventAdjustment.swift
//  stripe-kit
//

import Foundation

/// [The Meter Event Adjustment Object](https://docs.stripe.com/api/billing/meter-event-adjustments/object)
///
/// A billing meter event adjustment is a resource that allows you to cancel a meter event.
public struct MeterEventAdjustment: Codable, Sendable {
    /// String representing the object's type.
    public var object: String
    /// Specifies which event to cancel.
    public var cancel: MeterEventAdjustmentCancel?
    /// The name of the meter event being adjusted.
    public var eventName: String?
    /// Has the value `true` if the object exists in live mode.
    public var livemode: Bool?
    /// The meter event adjustment's status.
    public var status: MeterEventAdjustmentStatus?
    /// Specifies whether to cancel a single event or a range of events for a time period.
    public var type: MeterEventAdjustmentType?
}

public struct MeterEventAdjustmentCancel: Codable, Sendable {
    /// Unique identifier for the event.
    public var identifier: String?
}

public enum MeterEventAdjustmentStatus: String, Codable, Sendable {
    case complete
    case pending
}

public enum MeterEventAdjustmentType: String, Codable, Sendable {
    case cancel
}
