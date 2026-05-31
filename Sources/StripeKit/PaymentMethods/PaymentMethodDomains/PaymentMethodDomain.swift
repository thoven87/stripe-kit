//
//  PaymentMethodDomain.swift
//  stripe-kit
//

import Foundation

/// [The PaymentMethodDomain Object](https://docs.stripe.com/api/payment_method_domains/object)
///
/// A payment method domain represents a web domain that you have registered with Stripe.
/// Stripe Elements use registered payment method domains to control where certain payment methods are shown.
public struct PaymentMethodDomain: Codable {
    /// Unique identifier for the object.
    public var id: String
    /// String representing the object's type.
    public var object: String
    /// Indicates the status of a specific payment method on a payment method domain.
    public var amazonPay: PaymentMethodDomainResourcePaymentMethodStatus?
    /// Indicates the status of a specific payment method on a payment method domain.
    public var applePay: PaymentMethodDomainResourcePaymentMethodStatus?
    /// Time at which the object was created.
    public var created: Date?
    /// The domain name that this payment method domain object represents.
    public var domainName: String
    /// Whether this payment method domain is enabled.
    public var enabled: Bool?
    /// Indicates the status of a specific payment method on a payment method domain.
    public var googlePay: PaymentMethodDomainResourcePaymentMethodStatus?
    /// Indicates the status of a specific payment method on a payment method domain.
    public var klarna: PaymentMethodDomainResourcePaymentMethodStatus?
    /// Indicates the status of a specific payment method on a payment method domain.
    public var link: PaymentMethodDomainResourcePaymentMethodStatus?
    /// Has the value `true` if the object exists in live mode.
    public var livemode: Bool?
    /// Indicates the status of a specific payment method on a payment method domain.
    public var paypal: PaymentMethodDomainResourcePaymentMethodStatus?
}

public struct PaymentMethodDomainResourcePaymentMethodStatus: Codable {
    /// The status of the payment method on the domain.
    public var status: PaymentMethodDomainStatus?
    /// Contains additional details about the status of a payment method for a specific payment method domain.
    public var statusDetails: PaymentMethodDomainStatusDetails?
}

public enum PaymentMethodDomainStatus: String, Codable {
    case active
    case inactive
}

public struct PaymentMethodDomainStatusDetails: Codable {
    /// The error message associated with the status of the payment method on the domain.
    public var errorMessage: String?
}

public struct PaymentMethodDomainList: Codable {
    public var object: String
    public var hasMore: Bool?
    public var url: String?
    public var data: [PaymentMethodDomain]?
}
