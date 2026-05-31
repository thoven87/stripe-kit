//
//  CustomerSession.swift
//  stripe-kit
//

import Foundation

/// [The CustomerSession Object](https://docs.stripe.com/api/customer_sessions/object)
///
/// A Customer Session allows you to grant Stripe's frontend SDKs client-side access control over a Customer.
public struct CustomerSession: Codable {
    /// The client secret of this CustomerSession. Used on the client to set up secure access to the given customer.
    public var clientSecret: String
    /// Time at which the object was created.
    public var created: Date?
    /// Configuration for the components supported by this Customer Session.
    public var components: CustomerSessionComponents?
    /// The Customer the Customer Session was created for.
    @Expandable<Customer> public var customer: String?
    /// The timestamp at which this Customer Session will expire.
    public var expiresAt: Date?
    /// Has the value `true` if the object exists in live mode or the value `false` if the object exists in test mode.
    public var livemode: Bool?
    /// String representing the object's type.
    public var object: String
}

public struct CustomerSessionComponents: Codable {
    /// Configuration for the buy button component.
    public var buyButton: CustomerSessionComponentConfig?
    /// Configuration for the pricing table component.
    public var pricingTable: CustomerSessionComponentConfig?
    /// Configuration for the Payment Element.
    public var paymentElement: CustomerSessionPaymentElementConfig?
}

public struct CustomerSessionComponentConfig: Codable {
    /// Whether the component is enabled.
    public var enabled: Bool
}

public struct CustomerSessionPaymentElementConfig: Codable {
    /// Whether the Payment Element is enabled.
    public var enabled: Bool
    /// Configuration for the Payment Element features.
    public var features: CustomerSessionPaymentElementFeatures?
}

public struct CustomerSessionPaymentElementFeatures: Codable {
    /// Controls whether the Payment Element displays the option to remove a saved payment method.
    public var paymentMethodRedisplay: String?
    /// Controls whether the Payment Element offers to save payment methods.
    public var paymentMethodSave: String?
    /// Controls whether the Payment Element offers a default save checkbox.
    public var paymentMethodSaveUsage: String?
    /// Controls whether the Payment Element displays the option to set a payment method as the default.
    public var paymentMethodSetAsDefault: String?
}
