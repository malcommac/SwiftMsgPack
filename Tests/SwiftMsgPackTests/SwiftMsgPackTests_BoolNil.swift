/*
* SwiftMsgPack
* Lightweight MsgPack for Swift
*
* Created by:	Daniele Margutti
* Email:			hello@danielemargutti.com
* Web:			http://www.danielemargutti.com
* Twitter:		@danielemargutti
*
* Copyright © 2017 Daniele Margutti
*
*
* Permission is hereby granted, free of charge, to any person obtaining a copy
* of this software and associated documentation files (the "Software"), to deal
* in the Software without restriction, including without limitation the rights
* to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
* copies of the Software, and to permit persons to whom the Software is
* furnished to do so, subject to the following conditions:
*
* The above copyright notice and this permission notice shall be included in
* all copies or substantial portions of the Software.
*
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
* AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
* LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
* OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
* THE SOFTWARE.
*
*/

import Foundation

import XCTest
@testable import SwiftMsgPack

class SwiftMsgPackTests_BoolNil: XCTestCase {
	
	override func setUp() {
		super.setUp()
	}
	
	override func tearDown() {
		super.tearDown()
	}
	
	// MARK: - Test `bool` type
	
	/// Test boolean `true` value
	func testBoolean_true() {
		performBooleanTest(name: "Test True", value: true, expected: UInt8(0xc3))
	}
	
	/// Test boolean `false` value
	func testBoolean_false() {
		performBooleanTest(name: "Test False", value: false, expected: UInt8(0xc2))
	}
	
	// MARK: - Test `nil` value type
	
	func testNil() {
		let data: Any? = nil
		performNilTest(name: "Nil Test", value: data, expected: UInt8(0xc0))
	}
	
	// MARK: Helper Functions
	
	func performNilTest(name testName: String, value: Any?, expected byte: UInt8) {
		var packed = Data()
		do {
			try packed.pack(value)
			
			guard packed.count == 1 else {
				XCTFail("[\(testName)] Nil pack should contains only 1 byte (\(packed.count) bytes found)")
				return
			}
			
			guard packed[0] == byte else {
				XCTFail("[\(testName)] Nil pack is different from expected")
				return
			}
			
			if let _ = try packed.unpack() {
				XCTFail("[\(testName)] A value is found while unpacking a nil value")
				return
			}
			
		} catch let err {
			// Something went wrong while packing data
            XCTFail("[\(testName)] Failed to pack nil: \(err) (src='\(String(describing: value))')")
			return
		}
	}
	
	func performBooleanTest(name testName: String, value: Bool, expected byte: UInt8) {
		var packed = Data()
		do {
			// Pack data
			try packed.pack(value)
			
			guard packed.count == 1 else {
				XCTFail("[\(testName)] Boolean pack should contains only 1 byte (\(packed.count) bytes found)")
				return
			}
			
			guard packed[0] == byte else {
				XCTFail("[\(testName)] Boolean pack is different from expected")
				return
			}
			
			guard let unpacked_value = try packed.unpack() else {
				XCTFail("[\(testName)] Failed to unpack boolean value")
				return
			}
			
			guard let bool_val = unpacked_value as? Bool else {
				XCTFail("[\(testName)] Failed to cast read value from pack to a valid Boolean type")
				return
			}
			
			guard bool_val == value else {
				XCTFail("[\(testName)] Packed boolean value is not valid")
				return
			}
			
		} catch let err {
			// Something went wrong while packing data
			XCTFail("[\(testName)] Failed to pack boolean: \(err) (src='\(value)')")
			return
		}
	}

}
