//
//  PaymentMethodConfiguration.swift
//  stripe-kit
//

import Foundation

/// [The Payment Method Configuration Object](https://docs.stripe.com/api/payment_method_configurations/object)
///
/// PaymentMethodConfigurations control which payment methods are displayed to your customers
/// when you don't explicitly specify payment method types.
public struct PaymentMethodConfiguration: Codable, Sendable {
    /// Unique identifier for the object.
    public var id: String
    /// String representing the object's type.
    public var object: String
    /// Whether the configuration can be used for new payments.
    public var active: Bool?
    /// For child configs, the Connect application associated with the configuration.
    public var application: String?
    /// The default configuration is used whenever a payment method configuration is not specified.
    public var isDefault: Bool?
    /// Has the value `true` if the object exists in live mode.
    public var livemode: Bool?
    /// The configuration's name.
    public var name: String?
    /// For child configs, the configuration's parent configuration.
    public var parent: String?
}

public struct PaymentMethodConfigurationList: Codable, Sendable {
    public var object: String
    public var hasMore: Bool?
    public var url: String?
    public var data: [PaymentMethodConfiguration]?
}
