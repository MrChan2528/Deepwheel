// Copyright (c) 2014-present, Facebook, Inc. All rights reserved.
//
// You are hereby granted a non-exclusive, worldwide, royalty-free license to use,
// copy, modify, and distribute this software in source code or binary form for use
// in connection with the web services and APIs provided by Facebook.
//
// As with any software that integrates with the Facebook platform, your use of
// this software is subject to the Facebook Developer Principles and Policies
// [http://developers.facebook.com/policy/]. This copyright notice shall be
// included in all copies or substantial portions of the software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
// FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
// COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
// IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
// CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

#if !os(tvOS)

import XCTest

class FBSDKSKAdNetworkEventTests: XCTestCase {

  func testValidCases() {
    var event = SKAdNetworkEvent(json: ["event_name": "fb_mobile_purchase"])
    XCTAssertTrue(event?.eventName == "fb_mobile_purchase")
    XCTAssertNil(event?.values)
    event = SKAdNetworkEvent(
      json: [
        "event_name": "fb_mobile_purchase",
        "values": [
          [
            "currency": "usd",
            "amount": 100
          ],
          [
            "currency": "JPY",
            "amount": 1000
          ]
        ]
      ]
    )
    XCTAssertTrue(event?.eventName == "fb_mobile_purchase")
    let expectedValues: [String: NSNumber] = [
      "USD": 100,
      "JPY": 1000
    ]
    XCTAssertTrue(event?.values == expectedValues)
  }

  func testInvalidCases() {
    var invalidData: [String: Any] = [:]
    XCTAssertNil(SKAdNetworkEvent(json: invalidData))
    invalidData = [
      "values": [
        [
          "currency": "usd",
          "amount": 100
        ],
        [
          "currency": "JPY",
          "amount": 1000
        ]
      ]
    ]
    XCTAssertNil(SKAdNetworkEvent(json: invalidData))
    invalidData = [
      "event_name": "fb_mobile_purchase",
      "values": [
        [
          "currency": 100,
          "amount": "usd"
        ],
        [
          "currency": 1000,
          "amount": "jpy"
        ]
      ]
    ]
    XCTAssertNil(SKAdNetworkEvent(json: invalidData))
  }
}

#endif
