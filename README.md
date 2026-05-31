# StripeKit

[![Swift](https://img.shields.io/badge/Swift-6.2-orange.svg?style=flat)](https://swift.org)
[![SwiftNIO](https://img.shields.io/badge/SwiftNIO-2-blue.svg?style=flat)](https://github.com/apple/swift-nio)
[![CI](https://github.com/vapor-community/stripe-kit/workflows/CI/badge.svg)](https://github.com/vapor-community/stripe-kit/actions)
[![License](https://img.shields.io/badge/license-MIT-green.svg?style=flat)](LICENSE)

A Swift package for communicating with the [Stripe API](https://stripe.com) in Server Side Swift applications.

## Stripe API Version

`2026-05-27`

## Requirements

- Swift 6.2+
- Linux, macOS 12+ / iOS 15+ / tvOS 15+ / watchOS 8+

## Installation

Add StripeKit to your `Package.swift`:

```swift
.package(url: "https://github.com/vapor-community/stripe-kit.git", from: "22.0.0")
```

Then add it as a target dependency:

```swift
.target(name: "MyTarget", dependencies: [
    .product(name: "StripeKit", package: "stripe-kit")
])
```

## Getting Started

Initialize a `StripeClient` with an `HTTPClient` and your Stripe API key:

```swift
import AsyncHTTPClient
import StripeKit

let httpClient = HTTPClient(eventLoopGroupProvider: .singleton)
let stripe = StripeClient(httpClient: httpClient, apiKey: "sk_live_...")
```

Each API is accessed as a property on the client:

```swift
let charge = try await stripe.charges.create(
    amount: 2500,
    currency: .usd,
    description: "A server written in Swift.",
    source: "tok_visa"
)

if charge.status == .succeeded {
    print("Payment succeeded 🎉")
}
```

## Expandable Objects

StripeKit supports [expandable objects](https://stripe.com/docs/api/expanding_objects) via three property wrappers: `@Expandable`, `@DynamicExpandable`, and `@ExpandableCollection`.

All API routes that can return expanded objects accept an `expand: [String]?` parameter.

### `@Expandable`

```swift
// Expand a single field
let paymentIntent = try await stripe.paymentIntents.create(
    amount: 2500, currency: .usd, expand: ["customer"]
)
paymentIntent.$customer?.email // "user@example.com"

// Expand multiple fields
let paymentIntent = try await stripe.paymentIntents.create(
    amount: 2500, currency: .usd, expand: ["customer", "payment_method"]
)
paymentIntent.$customer?.email          // "user@example.com"
paymentIntent.$paymentMethod?.card?.last4 // "4242"

// Expand nested fields
let paymentIntent = try await stripe.paymentIntents.create(
    amount: 2500, currency: .usd, expand: ["payment_method.customer"]
)
paymentIntent.$paymentMethod?.card?.last4    // "4242"
paymentIntent.$paymentMethod?.$customer?.email // "user@example.com"
```

> **Note:** For list operations, [expanded fields must start with `data`](https://stripe.com/docs/api/expanding_objects?lang=curl):
> ```swift
> let list = try await stripe.paymentIntents.listAll(filter: ["expand[]": "data.customer"])
> list.data?.first?.$customer?.email // "user@example.com"
> ```

### `@DynamicExpandable`

Some objects can expand into one of several types. For example, `ApplicationFee.originatingTransaction` can be either a `Charge` or a `Transfer`:

```swift
let fee = try await stripe.applicationFees.retrieve(
    fee: "fee_1234", expand: ["originating_transaction"]
)
fee.$originatingTransaction(as: Charge.self)?.amount      // 2500
fee.$originatingTransaction(as: Transfer.self)?.destination // "acct_..."
```

### `@ExpandableCollection`

```swift
let invoice = try await stripe.invoices.retrieve(invoice: "in_12345", expand: ["discounts"])

invoice.discounts           // ["di_1", "di_2", ...]  (String IDs)
invoice.$discounts?[0].id  // "di_1"  (expanded Discount objects)
```

## Custom Headers

Use the builder-style `addHeaders(_:)` API to attach per-request headers such as `Stripe-Account` for Connect or `Idempotency-Key`:

```swift
// Connected account
let charge = try await stripe.charges
    .addHeaders(["Stripe-Account": "acct_12345"])
    .create(amount: 2500, currency: .usd, source: "tok_visa")

// Idempotency key
let refund = try await stripe.refunds
    .addHeaders(["Idempotency-Key": UUID().uuidString])
    .create(charge: "ch_12345", reason: .requestedByCustomer)
```

> **Note:** Modified headers persist on the route instance for the lifetime of the reference. When accessing the `StripeClient` inside a request scope (e.g. a Vapor route handler), headers are not retained between requests.

## Webhooks

Verify and decode Stripe webhook events:

```swift
func handleStripeWebhook(req: Request) async throws -> Response {
    let signature = req.headers.first(name: "Stripe-Signature") ?? ""
    try StripeClient.verifySignature(
        payload: Data(req.body.readableBytesView),
        header: signature,
        secret: "whsec_..."
    )

    let decoder = JSONDecoder()
    decoder.dateDecodingStrategy = .secondsSince1970
    decoder.keyDecodingStrategy = .convertFromSnakeCase

    let event = try decoder.decode(Event.self, from: Data(req.body.readableBytesView))

    switch (event.type, event.data?.object) {
    case (.paymentIntentSucceeded, .paymentIntent(let paymentIntent)):
        print("Payment succeeded: \(paymentIntent.id)")
        return Response(status: .ok)
    default:
        return Response(status: .ok)
    }
}
```

## Using with Vapor

```swift
import Vapor
import StripeKit

extension Application {
    public var stripe: StripeClient {
        guard let key = Environment.get("STRIPE_API_KEY") else {
            fatalError("STRIPE_API_KEY environment variable is required")
        }
        return StripeClient(httpClient: self.http.client.shared, apiKey: key)
    }
}

extension Request {
    private struct StripeKey: StorageKey {
        typealias Value = StripeClient
    }

    public var stripe: StripeClient {
        if let existing = application.storage[StripeKey.self] {
            return existing
        }
        guard let key = Environment.get("STRIPE_API_KEY") else {
            fatalError("STRIPE_API_KEY environment variable is required")
        }
        let client = StripeClient(httpClient: application.http.client.shared, apiKey: key)
        application.storage[StripeKey.self] = client
        return client
    }
}
```

### Webhook Signature Verification with Vapor

```swift
extension StripeClient {
    /// Verifies a Stripe webhook signature from a Vapor `Request`.
    /// - Parameters:
    ///   - req: The incoming `Request`.
    ///   - secret: The webhook endpoint secret (`whsec_...`).
    ///   - tolerance: Maximum age of the timestamp in seconds (default: 300).
    public static func verifySignature(
        for req: Request,
        secret: String,
        tolerance: Double = 300
    ) throws {
        guard let header = req.headers.first(name: "Stripe-Signature") else {
            throw StripeSignatureError.unableToParseHeader
        }
        guard let body = req.body.data else {
            throw StripeSignatureError.noMatchingSignatureFound
        }
        try StripeClient.verifySignature(
            payload: Data(body.readableBytesView),
            header: header,
            secret: secret,
            tolerance: tolerance
        )
    }
}

extension StripeSignatureError: AbortError {
    public var reason: String {
        switch self {
        case .unableToParseHeader:    return "Unable to parse Stripe-Signature header"
        case .noMatchingSignatureFound: return "No matching signature was found"
        case .timestampNotTolerated:  return "Timestamp was not tolerated"
        }
    }

    public var status: HTTPResponseStatus { .badRequest }
}
```

## Implemented APIs

### Core Resources
* [x] Balance
* [x] Balance Transactions
* [x] Charges
* [x] Customers
* [x] Customer Sessions
* [x] Disputes
* [x] Events
* [x] Files
* [x] File Links
* [x] Mandates
* [x] Payment Intents
* [x] Setup Intents
* [x] Setup Attempts
* [x] Payouts
* [x] Refunds
* [x] Confirmation Tokens
* [x] Tokens
* [x] Ephemeral Keys
---
### Payment Methods
* [x] Payment Methods
* [x] Payment Method Configurations
* [x] Payment Method Domains
* [x] Bank Accounts
* [x] Cash Balance
* [x] Cash Balance Transactions
* [x] Cards
* [x] Sources
---
### Products
* [x] Products
* [x] Prices
* [x] Coupons
* [x] Promotion Codes
* [x] Discounts
* [x] Tax Codes
* [x] Tax Rates
* [x] Shipping Rates
---
### Checkout
* [x] Sessions
---
### Payment Links
* [x] Payment Links
---
### Billing
* [x] Alerts
* [x] Credit Notes
* [x] Credit Grants
* [x] Credit Balance Summary
* [x] Credit Balance Transactions
* [x] Customer Balance Transactions
* [x] Customer Portal
* [x] Customer Tax IDs
* [x] Invoices
* [x] Invoice Items
* [x] Invoice Rendering Templates
* [x] Meters
* [x] Meter Events
* [x] Meter Event Adjustments
* [x] Plans
* [x] Quotes
* [x] Quote Line Items
* [x] Subscriptions
* [x] Subscription Items
* [x] Subscription Schedule
* [x] Test Clocks
* [x] Usage Records
---
### Entitlements
* [x] Features
* [x] Product Features
* [x] Active Entitlements
---
### Connect
* [x] Account
* [x] Account Login Links
* [x] Account Links
* [x] Account Sessions
* [x] Application Fees
* [x] Application Fee Refunds
* [x] Capabilities
* [x] Country Specs
* [x] External Accounts
* [x] Persons
* [x] Top-ups
* [x] Transfers
* [x] Transfer Reversals
* [x] Secret Management
---
### Fraud
* [x] Early Fraud Warnings
* [x] Reviews
* [x] Value Lists
* [x] Value List Items
---
### Issuing
* [x] Authorizations
* [x] Cardholders
* [x] Cards
* [x] Disputes
* [x] Funding Instructions
* [x] Transactions
---
### Terminal
* [x] Connection Tokens
* [x] Locations
* [x] Readers
* [x] Hardware Orders
* [x] Hardware Products
* [x] Hardware SKUs
* [x] Hardware Shipping Methods
* [x] Configurations
---
### Sigma
* [x] Scheduled Queries
---
### Reporting
* [x] Report Runs
* [x] Report Types
---
### Identity
* [x] Verification Sessions
* [x] Verification Reports
---
### Webhooks
* [x] Webhook Endpoints
* [x] Signature Verification

## License

StripeKit is available under the MIT license. See [LICENSE](LICENSE) for details.
