//
//  CreditGrant.swift
//  stripe-kit
//

import Foundation

/// [The Credit Grant Object](https://docs.stripe.com/api/billing/credit-grant/object)
///
/// A credit grant is an API resource that documents the allocation of some billing credits to a customer.
public struct CreditGrant: Codable, Sendable {
    /// Unique identifier for the object.
    public var id: String
    /// String representing the object's type.
    public var object: String
    /// Amount of this credit grant.
    public var amount: CreditGrantAmount?
    /// Configuration specifying what this credit grant applies to.
    public var applicabilityConfig: CreditGrantApplicabilityConfig?
    /// The category of this credit grant.
    public var category: CreditGrantCategory?
    /// Time at which the object was created.
    public var created: Date?
    /// ID of the customer receiving the credit grant.
    @Expandable<Customer> public var customer: String?
    /// The time when the billing credits become effective — when they're eligible for use.
    public var effectiveAt: Date?
    /// The time when the billing credits expire.
    public var expiresAt: Date?
    /// Has the value `true` if the object exists in live mode.
    public var livemode: Bool?
    /// Set of key-value pairs you can attach to an object.
    public var metadata: [String: String]?
    /// A descriptive name shown in the Dashboard.
    public var name: String?
    /// ID of the test clock this credit grant belongs to.
    public var testClock: String?
    /// The time when this credit grant was voided.
    public var voidedAt: Date?
}

public struct CreditGrantAmount: Codable, Sendable {
    /// The monetary amount.
    public var monetary: CreditGrantMonetaryAmount?
    /// The type of this amount. Only `monetary` is currently supported.
    public var type: String?
}

public struct CreditGrantMonetaryAmount: Codable, Sendable {
    /// Three-letter ISO currency code.
    public var currency: Currency?
    /// A positive integer representing the amount.
    public var value: Int?
}

public struct CreditGrantApplicabilityConfig: Codable, Sendable {
    /// Specifies the scope of the applicable billing credits.
    public var scope: CreditGrantApplicabilityScope?
}

public struct CreditGrantApplicabilityScope: Codable, Sendable {
    /// The price type to which credit grants can apply.
    public var priceType: String?
}

public enum CreditGrantCategory: String, Codable, Sendable {
    case paid
    case promotional
}

public struct CreditGrantList: Codable, Sendable {
    public var object: String
    public var hasMore: Bool?
    public var url: String?
    public var data: [CreditGrant]?
}

/// [The Credit Balance Summary Object](https://docs.stripe.com/api/billing/credit-balance-summary/object)
public struct CreditBalanceSummary: Codable, Sendable {
    /// String representing the object's type.
    public var object: String
    /// The credit balances of the customer.
    public var balances: [CreditBalance]?
    /// The customer the balance is for.
    @Expandable<Customer> public var customer: String?
    /// Has the value `true` if the object exists in live mode.
    public var livemode: Bool?
}

public struct CreditBalance: Codable, Sendable {
    /// The available monetary balance of the customer.
    public var availableBalance: CreditGrantAmount?
    /// The ledger balance of the customer.
    public var ledgerBalance: CreditGrantAmount?
}

/// [The Credit Balance Transaction Object](https://docs.stripe.com/api/billing/credit-balance-transaction/object)
public struct CreditBalanceTransaction: Codable, Sendable {
    /// Unique identifier for the object.
    public var id: String
    /// String representing the object's type.
    public var object: String
    /// Time at which the object was created.
    public var created: Date?
    /// Credit details for this balance transaction (when type is `credit`).
    public var credit: CreditBalanceTransactionCredit?
    /// The customer balance transaction related to this credit balance transaction.
    @Expandable<Customer> public var customer: String?
    /// The effective time of the credit or debit.
    public var effectiveAt: Date?
    /// The credit grant associated with this balance transaction.
    @Expandable<CreditGrant> public var creditGrant: String?
    /// Has the value `true` if the object exists in live mode.
    public var livemode: Bool?
    /// The net impact on the customer's balance.
    public var netAmount: CreditGrantAmount?
    /// Debit details (when type is `debit`).
    public var debit: CreditBalanceTransactionDebit?
    /// The type of this balance transaction (`credit` or `debit`).
    public var type: CreditBalanceTransactionType?
}

public struct CreditBalanceTransactionCredit: Codable, Sendable {
    /// The amount of the credit.
    public var amount: CreditGrantAmount?
    /// The credit grant type.
    public var type: String?
}

public struct CreditBalanceTransactionDebit: Codable, Sendable {
    /// The amount of the debit.
    public var amount: CreditGrantAmount?
    /// The debit type.
    public var type: String?
}

public enum CreditBalanceTransactionType: String, Codable, Sendable {
    case credit
    case debit
}

public struct CreditBalanceTransactionList: Codable, Sendable {
    public var object: String
    public var hasMore: Bool?
    public var url: String?
    public var data: [CreditBalanceTransaction]?
}
