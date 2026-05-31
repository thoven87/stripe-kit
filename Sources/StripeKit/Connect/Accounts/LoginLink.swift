//
//  LoginLink.swift
//  stripe-kit
//

import Foundation

/// [The LoginLink Object](https://docs.stripe.com/api/accounts/create_login_link)
///
/// Login Links are single-use URLs for a connected account to access the Express Dashboard.
public struct LoginLink: Codable, Sendable {
    /// String representing the object's type.
    public var object: String
    /// Time at which the object was created.
    public var created: Date?
    /// The URL for the login link.
    public var url: String?
}
