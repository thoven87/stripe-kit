//
//  Subscription.swift
//  Stripe
//
//  Created by Andrew Edwards on 6/6/17.
//
//

import Foundation

/// The [Subscription Object](https://stripe.com/docs/api/subscriptions/object).
public struct StripeSubscription: StripeModel {
    /// Unique identifier for the object.
    public var id: String
    /// String representing the object’s type. Objects of the same type share the same value.
    public var object: String
    /// A non-negative decimal between 0 and 100, with at most two decimal places. This represents the percentage of the subscription invoice subtotal that will be transferred to the application owner’s Stripe account.
    public var applicationFeePercent: Decimal?
    /// Determines the date of the first full invoice, and, for plans with `month` or `year` intervals, the day of the month for subsequent invoices.
    public var billingCycleAnchor: Date?
    /// Define thresholds at which an invoice will be sent, and the subscription advanced to a new billing period
    public var billingThresholds: StripeSubscriptionBillingThresholds?
    /// If the subscription has been canceled with the `at_period_end` flag set to `true`, `cancel_at_period_end` on the subscription will be `true`. You can use this attribute to determine whether a subscription that has a status of active is scheduled to be canceled at the end of the current period.
    public var cancelAtPeriodEnd: Bool?
    /// If the subscription has been canceled, the date of that cancellation. If the subscription was canceled with `cancel_at_period_end`, `canceled_at` will still reflect the date of the initial cancellation request, not the end of the subscription period when the subscription is automatically moved to a canceled state.
    public var canceledAt: Date?
    /// Either `charge_automatically`, or `send_invoice`. When charging automatically, Stripe will attempt to pay this subscription at the end of the cycle using the default source attached to the customer. When sending an invoice, Stripe will email your customer an invoice with payment instructions.
    public var collectionMethod: StripeInvoiceCollectionMethod?
    /// Time at which the object was created. Measured in seconds since the Unix epoch.
    public var created: Date
    /// End of the current period that the subscription has been invoiced for. At the end of this period, a new invoice will be created.
    public var currentPeriodEnd: Date?
    /// Start of the current period that the subscription has been invoiced for.
    public var currentPeriodStart: Date?
    /// ID of the customer who owns the subscription.
    @Expandable<StripeCustomer> public var customer: String?
    /// Number of days a customer has to pay invoices generated by this subscription. This value will be `null` for subscriptions where `billing=charge_automatically`.
    public var daysUntilDue: Int?
    /// ID of the default payment method for the subscription. It must belong to the customer associated with the subscription. If not set, invoices will use the default payment method in the customer’s invoice settings.
    @Expandable<StripePaymentMethod> public var defaultPaymentMethod: String?
    /// ID of the default payment source for the subscription. It must belong to the customer associated with the subscription and be in a chargeable state. If not set, defaults to the customer’s default source.
    @Expandable<StripeSource> public var defaultSource: String?
    /// The tax rates that will apply to any subscription item that does not have tax_rates set. Invoices created will have their default_tax_rates populated from the subscription.
    public var defaultTaxRates: [StripeTaxRate]?
    /// Describes the current discount applied to this subscription, if there is one. When billing, a discount applied to a subscription overrides a discount applied on a customer-wide basis.
    public var discount: StripeDiscount?
    /// If the subscription has ended, the date the subscription ended.
    public var endedAt: Date?
    /// Settings controlling the behavior of applied customer balances on invoices generated by this subscription.
    public var invoiceCustomerBalanceSettings: StripeSubscriptionInvoiceCustomerBalanceSettings?
    /// List of subscription items, each with an attached plan.
    public var items: StripeSubscriptionItemList?
    /// The most recent invoice this subscription has generated.
    @Expandable<StripeInvoice> public var latestInvoice: String?
    /// Has the value true if the object exists in live mode or the value false if the object exists in test mode.
    public var livemode: Bool?
    /// Set of key-value pairs that you can attach to an object. This can be useful for storing additional information about the object in a structured format.
    public var metadata: [String: String]?
    /// Specifies the approximate timestamp on which any pending invoice items will be billed according to the schedule provided at pending_invoice_item_interval.
    public var nextPendingInvoiceItemInvoice: Date?
    /// Specifies an interval for how often to bill for any pending invoice items. It is analogous to calling Create an invoice for the given subscription at the specified interval.
    public var pendingInvoiceItemInterval: StripeSubscriptionPendingInvoiceInterval?
    /// You can use this SetupIntent to collect user authentication when creating a subscription without immediate payment or updating a subscription’s payment method, allowing you to optimize for off-session payments. Learn more in the SCA Migration Guide.
    @Expandable<StripePaymentIntent> public var pendingSetupIntent: String?
    /// If specified, [pending updates](https://stripe.com/docs/billing/subscriptions/pending-updates) that will be applied to the subscription once the`latest_invoice` has been paid.
    public var pendingUpdate: StripeSubscriptionPendingUpdate?
    /// Hash describing the plan the customer is subscribed to. Only set if the subscription contains a single plan.
    public var plan: StripePlan?
    /// The quantity of the plan to which the customer is subscribed. For example, if your plan is $10/user/month, and your customer has 5 users, you could pass 5 as the quantity to have the customer charged $50 (5 x $10) monthly. Only set if the subscription contains a single plan.
    public var quantity: Int?
    /// The schedule attached to the subscription
    @Expandable<StripeSubscriptionSchedule> public var schedule: String?
    /// Date when the subscription was first created. The date might differ from the `created` date due to backdating.
    public var startDate: Date?
    /// Possible values are incomplete, incomplete_expired, trialing, active, past_due, canceled, or unpaid. /n For billing=charge_automatically a subscription moves into incomplete if the initial payment attempt fails. A subscription in this state can only have metadata and default_source updated. Once the first invoice is paid, the subscription moves into an active state. If the first invoice is not paid within 23 hours, the subscription transitions to incomplete_expired. This is a terminal state, the open invoice will be voided and no further invoices will be generated. /n A subscription that is currently in a trial period is trialing and moves to active when the trial period is over. /n If subscription billing=charge_automatically it becomes past_due when payment to renew it fails and canceled or unpaid (depending on your subscriptions settings) when Stripe has exhausted all payment retry attempts. /n If subscription billing=send_invoice it becomes past_due when its invoice is not paid by the due date, and canceled or unpaid if it is still not paid by an additional deadline after that. Note that when a subscription has a status of unpaid, no subsequent invoices will be attempted (invoices will be created, but then immediately automatically closed). After receiving updated payment information from a customer, you may choose to reopen and pay their closed invoices.
    public var status: StripeSubscriptionStatus?
    /// If the subscription has a trial, the end of that trial.
    public var trialEnd: Date?
    /// If the subscription has a trial, the beginning of that trial.
    public var trialStart: Date?
}

public struct StripeSubscriptionBillingThresholds: StripeModel {
    /// Monetary threshold that triggers the subscription to create an invoice
    public var amountGte: Int?
    /// Indicates if the `billing_cycle_anchor` should be reset when a threshold is reached. If true, `billing_cycle_anchor` will be updated to the date/time the threshold was last reached; otherwise, the value will remain unchanged. This value may not be `true` if the subscription contains items with plans that have `aggregate_usage=last_ever`.
    public var resetBillingCycleAnchor: Bool?
}

public struct StripeSubscriptionPendingInvoiceInterval: StripeModel {
    /// Specifies invoicing frequency. Either `day`, `week`, `month` or `year`.
    public var interval: StripePlanInterval?
    /// The number of intervals between invoices. For example, `interval=month` and `interval_count=3` bills every 3 months. Maximum of one year interval allowed (1 year, 12 months, or 52 weeks).
    public var intervalCount: Int?
}

public enum StripeSubscriptionStatus: String, StripeModel {
    case incomplete
    case incompleteExpired = "incomplete_expired"
    case trialing
    case active
    case pastDue = "past_due"
    case canceled
    case unpaid
}

public struct StripeSubscriptionList: StripeModel {
    public var object: String
    public var hasMore: Bool?
    public var url: String?
    public var data: [StripeSubscription]?
}

public struct StripeSubscriptionInvoiceCustomerBalanceSettings: StripeModel {
    /// Controls whether a customer balance applied to this invoice should be consumed and not credited or debited back to the customer if voided.
    public var consumeAppliedBalanceOnVoid: Bool?
}

public enum StripeSubscriptionPaymentBehavior: String, StripeModel {
    case allowComplete = "allow_complete"
    case errorIfIncomplete = "error_if_complete"
}

public enum StripeSubscriptionProrationBehavior: String, StripeModel {
    case createProrations = "create_prorations"
    case none
}

public struct StripeSubscriptionPendingUpdate: StripeModel {
    /// If the update is applied, determines the date of the first full invoice, and, for plans with `month` or `year` intervals, the day of the month for subsequent invoices.
    public var billingCycleAnchor: Date?
    /// The point after which the changes reflected by this update will be discarded and no longer applied.
    public var expiresAt: Date?
    /// List of subscription items, each with an attached plan, that will be set if the update is applied.
    public var subscriptionItems: [StripeSubscriptionItem]?
    /// Unix timestamp representing the end of the trial period the customer will get before being charged for the first time, if the update is applied.
    public var trialEnd: Date?
    /// Indicates if a plan’s `trial_period_days` should be applied to the subscription. Setting `trial_end` per subscription is preferred, and this defaults to `false`. Setting this flag to `true` together with `trial_end` is not allowed.
    public var trialFromPlan: Bool?
}
