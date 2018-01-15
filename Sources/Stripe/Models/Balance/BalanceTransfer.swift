//
//  BalanceTransfer.swift
//  Stripe
//
//  Created by Anthony Castelli on 4/14/17.
//
//

/**
 Balance transfer is the body object of available array.
 https://stripe.com/docs/api/curl#balance_object
 */

public protocol BalanceTransfer {
    var currency: StripeCurrency? { get }
    var amount: Int? { get }
    var sourceTypes: [SourceType: Int] { get }
}

public struct StripeBalanceTransfer: BalanceTransfer, StripeModelProtocol {
    public var currency: StripeCurrency?
    public var amount: Int?
    public var sourceTypes: [SourceType: Int] = [:]
    
    enum CodingKeys: String, CodingKey {
        case currency
        case amount
        case sourceTypes = "source_types"
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        currency = try container.decode(StripeCurrency.self, forKey: .currency)
        amount = try container.decode(Int.self, forKey: .amount)
    
        let tempTypes = try container.decode([String: Int].self, forKey: .sourceTypes)
        
        tempTypes.forEach { (key, value) in
            let newKey = SourceType(rawValue: key)
            // TODO: Figure out a way around this force unwrap.
            sourceTypes[newKey!] = value
        }
    }
}
