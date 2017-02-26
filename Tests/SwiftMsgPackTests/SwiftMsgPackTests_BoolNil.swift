//
//  SwiftMsgPackTests_BoolNil.swift
//  SwiftMsgPack
//
//  Created by Daniele Margutti on 26/02/2017.
//  Copyright © 2017 moka. All rights reserved.
//

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
			XCTFail("[\(testName)] Failed to pack nil: \(err) (src='\(value)')")
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
