//
//  SwiftMsgPackTests.swift
//  SwiftMsgPackTests
//
//  Created by Daniele Margutti on 26/02/2017.
//  Copyright © 2017 moka. All rights reserved.
//

import XCTest
@testable import SwiftMsgPack

class SwiftMsgPackTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
	
	// MARK: - Tests
	
	// Test empty string
	func test_emptyString() {
		performTest(name: "Empty String", string: "", expected: [0xa0])
	}
	
	// Test a short string (less than 32)
	func test_tinyString() {
		let (src,expectedValues) = generateTestString(25)
		performTest(name: "Tiny String", string: src, expected: expectedValues)
	}
	
	// Test a short string (UInt8.max - 1)
	func test_shortString() {
		let length: Int = Int( (UInt8.max - 1) )
		let (src,expectedValues) = generateTestString(length)
		performTest(name: "Short String", string: src, expected: expectedValues)
	}
	
	// Test a short string UInt16(UInt16.max - 1)
	func test_mediumString() {
		let length: Int = Int( UInt16(UInt16.max - 1) )
		let (src,expectedValues) = generateTestString(length)
		performTest(name: "Medium String", string: src, expected: expectedValues)
	}
	
	// Test a short string UInt32(UInt16.max) + 1
	func test_longString() {
		let length: Int = Int( UInt32(UInt16.max) + 1 )
		let (src,expectedValues) = generateTestString(length)
		performTest(name: "Long String", string: src, expected: expectedValues)
	}
	
	// MARK: - Helper Functions
	
	/// Generare a string to test
	///
	/// - Parameter length: length of the string
	/// - Returns: random string and expected bytes of the sequence
	func generateTestString(_ length: Int) -> (String,[UInt8]) {
		// generate a random string and put it in an array of UInt8
		let src_string = randomString(length: length)
		var bytes: [UInt8] = []
		
		// Append correct header to the start of bytes sequence
		if length < 32 {
			// Header + Length
			bytes.append(UInt8(0xa0 + length))
		}
		else if length < Int(UInt8.max) {
			// Header
			bytes.append(UInt8(0xd9))
			
			// Length of the data
			bytes.append(UInt8(length))
		}
		else if length < Int(UInt16.max) {
			// Header
			bytes.append(UInt8(0xda))
			
			// Length of the data
			bytes.append(UInt8((length >> 8) & 0xff))
			bytes.append(UInt8(length & 0xff))
		}
		else if length < Int(UInt32.max) {
			// Header
			bytes.append(UInt8(0xdb))
			
			// Length of the data
			bytes.append(UInt8((length >> 24) & 0xff))
			bytes.append(UInt8((length >> 16) & 0xff))
			bytes.append(UInt8((length >> 8) & 0xff))
			bytes.append(UInt8(length & 0xff))
		}
		
		// Append data
		bytes.append(contentsOf: [UInt8](src_string.utf8))
		return (src_string,bytes)
	}
	
	
	/// Generate a random string with passed length
	///
	/// - Parameter length: length of the string
	/// - Returns: randome alphanumeric string
	func randomString(length: Int) -> String {
		let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
		let len = UInt32(letters.length)
		var randomString = ""
		for _ in 0 ..< length {
			let rand = arc4random_uniform(len)
			var nextChar = letters.character(at: Int(rand))
			randomString += NSString(characters: &nextChar, length: 1) as String
		}
		return randomString
	}
	
	
	/// Perform test on string and validate result
	///
	/// - Parameters:
	///   - testName: name of the test
	///   - value: source string
	///   - bytes: expected packed bytes to validate
	func performTest(name testName: String, string value: String, expected bytes: [UInt8]) {
		var packed = Data()
		do {
			// Try to pack data
			try packed.pack(value)
			
			// Validate the number of bytes between packed version and expected version
			guard packed.count == bytes.count else {
				XCTFail("[\(testName)] Pack failed, different number of bytes than expected - \(packed.count), \(bytes.count) expected")
				return
			}
			
			// Now validates each byte
			var idx = 0
			for byte in packed {
				guard byte == packed[idx] else {
					XCTFail("[\(testName)] Pack failed, byte \(idx) is different from expected (\(packed[idx]) != \(byte))")
					return
				}
				idx += 1
			}
			
			// Try to unpack and validate the result
			guard let unpacked = try packed.unpack() else {
				XCTFail("[\(testName)] Failed to unpack packed data")
				return
			}
			guard let str_value = unpacked as? String else {
				XCTFail("[\(testName)] Failed to cast unpacked data to a valid String instance")
				return
			}
			guard str_value.characters.count == value.characters.count else {
				XCTFail("[\(testName)] Unpacked string has a different number of characters than source")
				return
			}
			guard str_value == value else {
				XCTFail("[\(testName)] Unpacked string is different from source")
				return
			}
			
		} catch let error {
			// Something went wrong while packing data
			XCTFail("[\(testName)] Failed to pack string: \(error) (src='\(value)')")
			return
		}
	}
	
}
