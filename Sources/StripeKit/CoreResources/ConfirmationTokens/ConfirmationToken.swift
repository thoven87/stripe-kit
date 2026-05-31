//
//  ConfirmationToken.swift
//  stripe-kit
//

import Foundation

/// [The ConfirmationToken Object](https://docs.stripe.com/api/confirmation_tokens/object)
///
/// ConfirmationTokens help transport client side data collected by Stripe.js or the Elements web UI
/// to your server for confirming a PaymentIntent or SetupIntent.
public struct ConfirmationToken: Codable {
    /// Unique identifier for the object.
    public var id: String
    /// String representing the object's type.
    public var object: String
    /// Time at which the object was created.
    public var created: Date?
    /// Time at which this ConfirmationToken expires.
    public var expiresAt: Date?
    /// Has the value `true` if the object exists in live mode.
    public var livemode: Bool?
    /// ID of the PaymentIntent that this ConfirmationToken was used to confirm, or null if not yet used.
    public var paymentIntent: String?
    /// Payment details collected by the Payment Element, used to create a PaymentMethod when a PaymentIntent or SetupIntent is confirmed with this ConfirmationToken.
    public var paymentMethodPreview: ConfirmationTokenPaymentMethodPreview?
    /// Return URL used to confirm the Intent.
    public var returnUrl: String?
    /// Indicates that you intend to make future payments with this ConfirmationToken's payment method.
    public var setupFutureUsage: ConfirmationTokenSetupFutureUsage?
    /// ID of the SetupIntent that this ConfirmationToken was used to confirm, or null if not yet used.
    public var setupIntent: String?
    /// Shipping information collected on this ConfirmationToken.
    public var shipping: ConfirmationTokenShipping?
    /// Indicates whether the Stripe SDK is used to handle confirmation flow.
    public var useStripeSdk: Bool?
}

public struct ConfirmationTokenPaymentMethodPreview: Codable {
    /// The type of payment method.
    public var type: String?
    /// Billing information associated with the PaymentMethod.
    public var billingDetails: BillingDetails?
}

public struct ConfirmationTokenShipping: Codable {
    /// Recipient name.
    public var name: String?
    /// Recipient phone (including extension).
    public var phone: String?
    /// The delivery address.
    public var address: Address?
}

public enum ConfirmationTokenSetupFutureUsage: String, Codable {
    case offSession = "off_session"
    case onSession = "on_session"
}
