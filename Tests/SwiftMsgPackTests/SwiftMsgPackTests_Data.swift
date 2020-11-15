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

class SwiftMsgPackTests_Data: XCTestCase {
	
	override func setUp() {
		super.setUp()
	}
	
	override func tearDown() {
		super.tearDown()
	}
	
	// MARK: - Test Data

	func test_shortData() {
		let len = 6
		let (data,exp) = generateTestData(len)
		performTestData(name: "Test Short Data", value: data, expected: exp)
	}
	
	func test_mediumData() {
		let len = Int( UInt16(UInt16.max - 1) )
		let (data,exp) = generateTestData(len)
		performTestData(name: "Test Medium Data", value: data, expected: exp)
	}
	
	func test_bigData() {
		let len = Int( UInt32(UInt16.max) + 1 )
		let (data,exp) = generateTestData(len)
		performTestData(name: "Test Long Data", value: data, expected: exp)
	}
	
	// MARK: - Helper Functions
	
	func generateTestData(_ length: Int) -> (Data,[UInt8]) {
		var bytes: [UInt8] = []
		let data_sequence: [UInt8] = generateRandomNumberSequence(length)
		
		if length < Int(UInt8.max) {
			// Header
			bytes.append(UInt8(0xc4))
			// Length
			bytes.append(UInt8(length))
		}
		else if length < Int(UInt16.max) {
			// Header
			bytes.append(UInt8(0xc5))
			// Length (big endian)
			bytes.append(UInt8((length >> 8) & 0xff))
			bytes.append(UInt8(length & 0xff))
		}
		else if length < Int(UInt32.max) {
			bytes.append(UInt8(0xc6))
			// Length (big endian)
			bytes.append(UInt8((length >> 24) & 0xff))
			bytes.append(UInt8((length >> 16) & 0xff))
			bytes.append(UInt8((length >> 8) & 0xff))
			bytes.append(UInt8(length & 0xff))
		}
		// Append real data
		bytes.append(contentsOf: data_sequence)
		// Get generated data
		let data = Data(data_sequence)
		return (data,bytes)
	}
	
	func generateRandomNumberSequence(_ length: Int) -> [UInt8] {
		var items: [UInt8] = []
		for _ in 0..<length {
			let val = ( UInt8.max - UInt8.min) + UInt8.min
			let randomNum = Int(arc4random_uniform(UInt32(val)))
			items.append(UInt8(randomNum))
		}
		return items
	}
	
	func performTestData(name testName: String, value: Data, expected bytes: [UInt8]) {
		var packed = Data()
		
		do {
			try packed.pack(value)
			
			// Check resulting data size
			guard bytes.count == packed.count else {
				XCTFail("[\(testName)] Resulting packed data is different in byte size than expected (\(packed.count), \(bytes.count) expected)")
				return
			}
			
			// Validate each byte
			var idx = 0
			for byte in packed {
				guard byte == bytes[idx] else {
					XCTFail("[\(testName)] Byte \(idx) is different from expected (\(byte), \(bytes[idx]) expected)")
					return
				}
				idx += 1
			}
			
			// Unpack data
			guard let unpacked = try packed.unpack() else {
				XCTFail("[\(testName)] Failed to unpack data")
				return
			}
			
			// Cast to Data object
			guard let unpacked_data = unpacked as? Data else {
				XCTFail("[\(testName)] Failed to cast unpacked data to `Data` instance")
				return
			}
			
			// Check if data is equal
			guard unpacked_data == value else {
				XCTFail("[\(testName)] Unpackaed data is different from expected")
				return
			}
			
		} catch let err {
			// Something went wrong while packing data
			XCTFail("[\(testName)] Failed to pack data: \(err) (src='\(value)')")
			return
		}
	}
	
}
