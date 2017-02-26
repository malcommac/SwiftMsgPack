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


import XCTest
@testable import SwiftMsgPack

class SwiftMsgPackTests_Array: XCTestCase {
	
	override func setUp() {
		super.setUp()
	}
	
	override func tearDown() {
		super.tearDown()
	}
	
	// MARK: - Test on Array type
	
	
	/// Test small array
	func testSmallArray() {
		let len = 15
		let (array,exp) = generateTestArray(len)
		performTestOnArray(name: "Test Small Array", value: array, expected: exp)
	}
	
	/// Test medium array
	func testMediumArray() {
		let len = UInt16(UInt16.max - 1)
		let (array,exp) = generateTestArray(Int(len))
		performTestOnArray(name: "Test Medium Array", value: array, expected: exp)
	}
	
	/// Test long array
	func testLongArray() {
		let len = UInt32(UInt16.max) + 1
		let (array,exp) = generateTestArray(Int(len))
		performTestOnArray(name: "Test Long Array", value: array, expected: exp)
	}
	
	// MARK: Helper Functions

	func generateTestArray(_ count: Int) -> ([Any?],[UInt8]) {
		var array: [Any?] = []
		var bytes: [UInt8] = []
		
		// Generate Header for Array
		if count < 16 {
			// Header + Length
			bytes.append(UInt8(0x90 + count))
		}
		else if count < Int(UInt16.max) {
			// Header
			bytes.append(UInt8(0xdc))
			// Length (big endian)
			bytes.append(UInt8((count >> 8) & 0xff))
			bytes.append(UInt8(count & 0xff))
		}
		else if count < Int(UInt32.max) {
			// Header
			bytes.append(UInt8(0xdd))
			// Length (big endian)
			bytes.append(UInt8((count >> 24) & 0xff))
			bytes.append(UInt8((count >> 16) & 0xff))
			bytes.append(UInt8((count >> 8) & 0xff))
			bytes.append(UInt8(count & 0xff))
		}
		
		// Append items to array
		for _ in 0..<count {
			let (generatedItem,itemBytes) = generateRandomArrayType()
			// Append item to our array
			array.append(generatedItem)
			// Add stream to the bytes array
			bytes.append(contentsOf: itemBytes)
		}
		
		return (array,bytes)
	}
	
	
	/// Generate random type and return bytes stream which describe it
	///
	/// - Returns: item, byte which describe it
	func generateRandomArrayType() -> (Any?,[UInt8]) {
		let type = randomValue(min: 0, max: 1)
		var item: Any?
		var bytes: [UInt8] = []
		
		// Just to test some types
		switch type {
		case 0: // nil
			item = nil
			
			let header: UInt8 = UInt8(0xc0)
			bytes.append(header)
		case 1: // Boolean
			let bool_val = randomValue(min: 0, max: 1)
			item = (bool_val == 0 ? false : true)
			
			let header: UInt8 = (item as! Bool == true ? UInt8(0xc3) : UInt8(0xc2))
			bytes.append(header)
		case 2: // Int
			let int8Num = randomValue(min: 0, max: Int(Int8.max))
			item = int8Num
			
			let header: UInt8 = UInt8(int8Num & 0x7f)
			bytes.append(header)
		case 3: // Fixed String
			let random_len = randomValue(min: 1, max: 20)
			let str = randomString(length: random_len)
			item = str
			
			let header: UInt8 = UInt8(UInt8(0xa0) + UInt8(random_len))
			bytes.append(header)
		default:
			break
		}

		return (item,bytes)
	}
	
	/// Generate a random string with passed length
	///
	/// - Parameter length: length of the string
	/// - Returns: random alphanumeric string
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
	
	
	/// Generate a random number in a range
	///
	/// - Parameters:
	///   - min: min value
	///   - max: max value
	/// - Returns: random value
	func randomValue(min: Int, max: Int) -> Int {
		return Int(arc4random_uniform(UInt32(max) - UInt32(min)) + UInt32(min))
	}
	
	func performTestOnArray(name testName: String, value: [Any?], expected bytes: [UInt8]) {
		var packed = Data()
		
		do {
			try packed.pack(value)
			
			guard packed.count == bytes.count else {
				XCTFail("[\(testName)] Pack failed because number of bytes is different from expected: \(packed.count), \(bytes.count) expected")
				return
			}
			
			var idx = 0
			for byte in packed {
				guard byte == bytes[idx] else {
					XCTFail("[\(testName)] Byte \(idx) is different from expected (\(byte), \(bytes[idx]) expected")
					return
				}
				idx += 1
			}
			
			
		} catch let err {
			// Something went wrong while packing data
			XCTFail("[\(testName)] Failed to pack Array: \(err) (src='\(value)')")
			return
		}
	}
}
