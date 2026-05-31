//
//  InvoiceRenderingTemplate.swift
//  stripe-kit
//

import Foundation

/// [The InvoiceRenderingTemplate Object](https://docs.stripe.com/api/invoice_rendering_templates/object)
///
/// Invoice Rendering Templates are used to configure how invoices are rendered on Stripe-hosted pages.
public struct InvoiceRenderingTemplate: Codable {
    /// Unique identifier for the object.
    public var id: String
    /// String representing the object's type.
    public var object: String
    /// Time at which the object was created.
    public var created: Date?
    /// Has the value `true` if the object exists in live mode.
    public var livemode: Bool?
    /// Set of key-value pairs you can attach to an object.
    public var metadata: [String: String]?
    /// A brief description of the template, hidden from customers.
    public var nickname: String?
    /// The status of the template, one of `active` or `archived`.
    public var status: InvoiceRenderingTemplateStatus?
    /// Version of this template.
    public var version: Int?
}

public enum InvoiceRenderingTemplateStatus: String, Codable {
    case active
    case archived
}

public struct InvoiceRenderingTemplateList: Codable {
    public var object: String
    public var hasMore: Bool?
    public var url: String?
    public var data: [InvoiceRenderingTemplate]?
}
