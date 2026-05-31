//
//  CustomerFundingInstructions.swift
//  stripe-kit
//

import Foundation

/// [Funding Instructions](https://docs.stripe.com/api/customer_balance/funding_instructions)
///
/// Funding instructions for a customer cash balance.
public struct CustomerFundingInstructions: Codable {
    /// String representing the object's type.
    public var object: String
    /// The `bank_transfer` object for funding.
    public var bankTransfer: CustomerFundingInstructionsBankTransfer?
    /// Three-letter ISO currency code.
    public var currency: Currency?
    /// The `funding_type` of the returned instructions.
    public var fundingType: String?
    /// Has the value `true` if the object exists in live mode.
    public var livemode: Bool?
}

public struct CustomerFundingInstructionsBankTransfer: Codable {
    /// The country of the bank account to fund.
    public var country: String?
    /// A list of financial addresses that can be used to fund a particular balance.
    public var financialAddresses: [CustomerFundingInstructionsFinancialAddress]?
    /// The bank_transfer type.
    public var type: String?
}

public struct CustomerFundingInstructionsFinancialAddress: Codable {
    /// The payment networks supported by this address.
    public var supportedNetworks: [String]?
    /// The type of financial address.
    public var type: String?
    /// An IBAN-based FinancialAddress.
    public var iban: CustomerFundingInstructionsIBAN?
    /// A Sort Code-based FinancialAddress.
    public var sortCode: CustomerFundingInstructionsSortCode?
    /// A SPEI-based FinancialAddress.
    public var spei: CustomerFundingInstructionsSPEI?
    /// A Zengin-based FinancialAddress.
    public var zengin: CustomerFundingInstructionsZengin?
}

public struct CustomerFundingInstructionsIBAN: Codable {
    public var accountHolderName: String?
    public var bic: String?
    public var country: String?
    public var iban: String?
}

public struct CustomerFundingInstructionsSortCode: Codable {
    public var accountHolderName: String?
    public var accountNumber: String?
    public var sortCode: String?
}

public struct CustomerFundingInstructionsSPEI: Codable {
    public var bankCode: String?
    public var bankName: String?
    public var clabe: String?
}

public struct CustomerFundingInstructionsZengin: Codable {
    public var accountHolderName: String?
    public var accountNumber: String?
    public var accountType: String?
    public var bankCode: String?
    public var bankName: String?
    public var branchCode: String?
    public var branchName: String?
}
