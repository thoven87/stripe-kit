//
//  BillingAlert.swift
//  stripe-kit
//

import Foundation

/// [The Billing Alert Object](https://docs.stripe.com/api/billing/alerts/object)
///
/// A billing alert is a resource that notifies you when a certain usage threshold on a meter is crossed.
public struct BillingAlert: Codable {
    /// Unique identifier for the object.
    public var id: String
    /// String representing the object's type.
    public var object: String
    /// Defines the type of the alert.
    public var alertType: BillingAlertType?
    /// Has the value `true` if the object exists in live mode.
    public var livemode: Bool?
    /// Status of the alert. This can be `active`, `triggered`, or `archived`.
    public var status: BillingAlertStatus?
    /// Title of the alert.
    public var title: String?
    /// Encapsulates configuration of the alert to monitor usage on a specific Billing Meter.
    public var usageThreshold: BillingAlertUsageThreshold?
}

public enum BillingAlertType: String, Codable {
    case usageThreshold = "usage_threshold"
}

public enum BillingAlertStatus: String, Codable {
    case active
    case triggered
    case archived
}

public struct BillingAlertUsageThreshold: Codable {
    /// The filters allow limiting the scope of this usage alert.
    public var filters: [BillingAlertFilter]?
    /// The Billing Meter to which the alert applies.
    @Expandable<Meter> public var meter: String?
    /// Defines how the alert will behave.
    public var recurrence: BillingAlertRecurrence?
    /// The value at which this alert will trigger.
    public var gte: Int?
}

public struct BillingAlertFilter: Codable {
    /// Limit the scope of the alert to this customer ID.
    public var customer: String?
    /// What the alert filter type is.
    public var type: String?
}

public enum BillingAlertRecurrence: String, Codable {
    case oneTime = "one_time"
}

public struct BillingAlertList: Codable {
    public var object: String
    public var hasMore: Bool?
    public var url: String?
    public var data: [BillingAlert]?
}
