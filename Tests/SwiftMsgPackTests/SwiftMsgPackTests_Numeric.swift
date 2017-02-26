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

class SwiftMsgPackTests_Numeric: XCTestCase {
	
	override func setUp() {
		super.setUp()
	}
	
	override func tearDown() {
		super.tearDown()
	}
	
	// MARK: - UInt8

	func testUInt8() {
		performTestUInt8(name: "Test UInt8 #1", value: UInt8(0), expected: [0])
		performTestUInt8(name: "Test UInt8 #2", value: UInt8(0xC), expected: [0xC])
		performTestUInt8(name: "Test UInt8 #3", value: UInt8(0x81), expected: [0xcc, 0x81])
		performTestUInt8(name: "Test UInt8 #4", value: UInt8.max, expected: [0xcc, UInt8.max])
	}
	
	// MARK: - Int8
	
	func testInt8() {
		performTestInt8(name: "Test Int8 #1", value: Int8.min, expected: [0xd0, 0x80])
		performTestInt8(name: "Test Int8 #2", value: (Int8.min + 1), expected: [0xd0, 0x81])
		performTestInt8(name: "Test Int8 #3", value: (Int8.min + 2), expected: [0xd0, 0x82])
		performTestInt8(name: "Test Int8 #4", value: Int8(-33), expected: [0xd0, 0xdf])
		performTestInt8(name: "Test Int8 #5", value: Int8(-32), expected: [0xe0])
		performTestInt8(name: "Test Int8 #6", value: Int8(-1), expected: [0xff])
		performTestInt8(name: "Test Int8 #7", value: Int8(0), expected: [0])
		performTestInt8(name: "Test Int8 #8", value: Int8.max - 1, expected: [0x7e])
		performTestInt8(name: "Test Int8 #9", value: Int8.max, expected: [0x7f])
	}
	
	// MARK: - UInt16
	
	func testUInt16() {
		performTestUInt16(name: "Test UInt16 #1", value: UInt16(0), expected: [0])
		performTestUInt16(name: "Test UInt16 #2", value: UInt16(0x7f), expected: [0x7f])
		performTestUInt16(name: "Test UInt16 #3", value: UInt16(0x80), expected: [0xcc, 0x80])
		performTestUInt16(name: "Test UInt16 #4", value: UInt16.max, expected: [0xcd, 0xff, 0xff])
		performTestUInt16(name: "Test UInt16 #5", value: UInt16(Int16.max) + 1, expected: [0xcd, 0x80, 0x0])
		performTestUInt16(name: "Test UInt16 #6", value: UInt16(UInt8.max), expected: [0xcc, UInt8.max])
		performTestUInt16(name: "Test UInt16 #7", value: UInt16(UInt8.max) + 1, expected: [0xcd, 0x01, 0x0])
		performTestUInt16(name: "Test UInt16 #8", value: UInt16(Int16.max) - 1, expected: [0xcd, 0x7f, 0xfe])
		performTestUInt16(name: "Test UInt16 #9", value: UInt16(Int16.max), expected: [0xcd, 0x7f, 0xff])
	}
	
	// MARK: - Int16
	
	func testInt16() {
		performTestInt16(name: "Test Int16 #1", value: Int16.min, expected: [0xd1, 0x80, 0])
		performTestInt16(name: "Test Int16 #2", value: Int16(-33), expected:  [0xd0, 0xdf])
		performTestInt16(name: "Test Int16 #3", value: Int16(0), expected: [0])
		performTestInt16(name: "Test Int16 #4", value: Int16(Int8.max - 1), expected: [0x7e])
		performTestInt16(name: "Test Int16 #5", value: Int16.min + 1, expected: [0xd1, 0x80, 0x01])
		performTestInt16(name: "Test Int16 #6", value: Int16(Int8.min) - 1, expected: [0xd1, 0xff, 0x7f])
		performTestInt16(name: "Test Int16 #7", value: Int16(Int8.min), expected: [0xd0, 0x80])
		performTestInt16(name: "Test Int16 #8", value: Int16(Int8.min + 1), expected: [0xd0, 0x81])
		performTestInt16(name: "Test Int16 #9", value: Int16(-33), expected: [0xd0, 0xdf])
		performTestInt16(name: "Test Int16 #10", value: Int16(-32), expected: [0xe0])
		performTestInt16(name: "Test Int16 #11", value: Int16(-1), expected: [0xff])
		performTestInt16(name: "Test Int16 #12", value: Int16(0), expected: [0])
		performTestInt16(name: "Test Int16 #13", value: Int16(Int8.max - 1), expected: [0x7e])
		performTestInt16(name: "Test Int16 #14", value: Int16(Int8.max), expected: [0x7f])
		performTestInt16(name: "Test Int16 #15", value: Int16(Int8.max) + 1, expected: [0xcc, 0x80])
		performTestInt16(name: "Test Int16 #16", value: Int16.max - 1, expected: [0xd1, 0x7f, 0xfe])
		performTestInt16(name: "Test Int16 #17", value: Int16.max, expected: [0xd1, 0x7f, 0xff])
	}
	
	// MARK: - UInt32
	
	func testUInt32() {
		performTestUInt32(name: "Test UInt32 #1", value: UInt32(0), expected: [0])
		performTestUInt32(name: "Test UInt32 #2", value: UInt32(UInt8.max), expected: [0xcc, UInt8.max])
		performTestUInt32(name: "Test UInt32 #3", value: UInt32.max - 1, expected: [0xce, 0xff, 0xff, 0xff, 0xfe])
		performTestUInt32(name: "Test UInt32 #4", value: UInt32.max, expected: [0xce, 0xff, 0xff, 0xff, 0xff])
		performTestUInt32(name: "Test UInt32 #5", value: UInt32(UInt8.max), expected: [0xcc, UInt8.max])
		performTestUInt32(name: "Test UInt32 #6", value: UInt32(UInt8.max) + 1, expected: [0xcd, 0x01, 0x0])
		performTestUInt32(name: "Test UInt32 #7", value: UInt32(Int16.max) - 1, expected: [0xcd, 0x7f, 0xfe])
		performTestUInt32(name: "Test UInt32 #8", value: UInt32(Int16.max), expected: [0xcd, 0x7f, 0xff])
		performTestUInt32(name: "Test UInt32 #9", value: UInt32(Int16.max) + 1, expected: [0xcd, 0x80, 0x0])
}
	
	// MARK: - Int32
	
	func testInt32() {
		performTestInt32(name: "Test Int32 #1", value: Int32.min, expected: [0xd2, 0x80, 0, 0, 0])
		performTestInt32(name: "Test Int32 #2", value: Int32(Int16.min) - 1, expected: [0xd2, 0xff, 0xff, 0x7f, 0xff])
		performTestInt32(name: "Test Int32 #3", value: Int32(Int8.min + 1), expected: [0xd0, 0x81])
		performTestInt32(name: "Test Int32 #4", value: Int32(Int8.max - 1), expected: [0x7e])
		performTestInt32(name: "Test Int32 #5", value: Int32(Int16.max), expected: [0xd1, 0x7f, 0xff])
		performTestInt32(name: "Test Int32 #6", value: Int32.max, expected: [0xd2, 0x7f, 0xff, 0xff, 0xff])
		performTestInt32(name: "Test Int32 #7", value: Int32.max - 1, expected: [0xd2, 0x7f, 0xff, 0xff, 0xfe])
		performTestInt32(name: "Test Int32 #8", value: Int32(Int16.max) + 1, expected: [0xcd, 0x80, 0])
		performTestInt32(name: "Test Int32 #9", value: Int32(-33), expected: [0xd0, 0xdf])
		performTestInt32(name: "Test Int32 #10", value: Int32(-32), expected: [0xe0])
		performTestInt32(name: "Test Int32 #11", value: Int32(-1), expected: [0xff])
		performTestInt32(name: "Test Int32 #12", value: Int32(Int8.max), expected: [0x7f])
	}
	
	// MARK: - UInt64
	
	func testUInt64() {
		performTestUInt64(name: "Test UInt64 #1", value: UInt64(0), expected: [0])
		performTestUInt64(name: "Test UInt64 #2", value: UInt64(0x81), expected: [0xcc, 0x81])
		performTestUInt64(name: "Test UInt64 #3", value: UInt64.max, expected: [0xcf, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff,
		                                                                        0xff])
		performTestUInt64(name: "Test UInt64 #5", value: UInt64(Int32.max) + 1, expected: [0xce, 0x80, 0x0, 0x0, 0x0])
		performTestUInt64(name: "Test UInt64 #6", value: UInt64.max - 1, expected: [0xcf, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff,
		                                                                            0xfe])
		performTestUInt64(name: "Test UInt64 #7", value: UInt64.max, expected: [0xcf, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff,
		                                                                            0xff])
		performTestUInt64(name: "Test UInt64 #7", value: UInt64(Int32.max), expected: [0xce, 0x7f, 0xff, 0xff, 0xff])
	}
	
	// MARK: - Int64
	
	func testInt64() {
		performTestInt64(name: "Test Int64 #1", value: Int64.min, expected: [0xd3, 0x80, 0, 0, 0, 0, 0, 0, 0])
		performTestInt64(name: "Test Int64 #2", value: Int64.min + 1, expected: [0xd3, 0x80, 0, 0, 0, 0, 0, 0, 0x01])
		performTestInt64(name: "Test Int64 #3", value: Int64(Int32.min) - 1, expected: [0xd3, 0xff, 0xff, 0xff, 0xff, 0x7f, 0xff, 0xff,
		                                                                                0xff])
		performTestInt64(name: "Test Int64 #4", value: Int64(Int32.min), expected: [0xd2, 0x80, 0, 0, 0])
		performTestInt64(name: "Test Int64 #5", value: Int64(Int32.min) + 1, expected: [0xd2, 0x80, 0, 0, 0x01])
		performTestInt64(name: "Test Int64 #6", value: Int64(Int16.min) - 1, expected: [0xd2, 0xff, 0xff, 0x7f, 0xff])
		performTestInt64(name: "Test Int64 #7", value: Int64(Int16.min), expected: [0xd1, 0x80, 0])
		performTestInt64(name: "Test Int64 #8", value: Int64(Int16.min) + 1, expected: [0xd1, 0x80, 0x01])
		performTestInt64(name: "Test Int64 #10", value: Int64(Int8.min), expected: [0xd0, 0x80])
		performTestInt64(name: "Test Int64 #11", value: Int64(Int8.min) - 1, expected: [0xd1, 0xff, 0x7f])
		performTestInt64(name: "Test Int64 #12", value: Int64(Int8.min) + 1, expected: [0xd0, 0x81])
		performTestInt64(name: "Test Int64 #13", value: Int64(Int8.max), expected: [0x7f])
		
		performTestInt64(name: "Test Int64 #14", value: Int64(Int8.max - 1), expected: [0x7e])
		performTestInt64(name: "Test Int64 #15", value: Int64(Int8.max), expected: [0x7f])
		performTestInt64(name: "Test Int64 #16", value: Int64(Int8.max) + 1, expected: [0xcc, 0x80])
		performTestInt64(name: "Test Int64 #17", value: Int64(Int16.max) - 1, expected: [0xd1, 0x7f, 0xfe])
		performTestInt64(name: "Test Int64 #18", value: Int64(Int16.max), expected: [0xd1, 0x7f, 0xff])
		performTestInt64(name: "Test Int64 #19", value: Int64(Int16.max) + 1, expected: [0xcd, 0x80, 0])
		
		performTestInt64(name: "Test Int64 #20", value: Int64.max, expected: [0xd3, 0x7f, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff,
		                                                                     0xff])
		performTestInt64(name: "Test Int64 #21", value: Int64.max - 1, expected: [0xd3, 0x7f, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff,
		                                                                         0xfe])

	}
	
	// MARK: - Float
	
	func testFloat() {
		performTestFloat(name: "Test Float #1", value: Float(1.5), expected: [0xca, 0x3f, 0xc0, 0, 0])
		performTestFloat(name: "Test Float #2", value: Float(-553.4), expected: [0xca, 0xc4, 0x0a, 0x59, 0x9a])
		performTestFloat(name: "Test Float #3", value: Float(9124.45789), expected: [0xca, 0x46, 0x0e, 0x91, 0xd5])
	}
	
	// MARK: - Double
	
	func testDouble() {
		performTestDouble(name: "Test Double #1", value: Double(0.0), expected: [0xcb, 0, 0, 0, 0, 0, 0, 0, 0])
		performTestDouble(name: "Test Double #2", value: Double(2.5), expected: [0xcb, 0x40, 0x04, 0, 0, 0, 0, 0, 0])
		performTestDouble(name: "Test Double #3", value: Double(-553.4), expected: [0xcb, 0xc0, 0x81, 0x4b, 0x33, 0x33, 0x33, 0x33, 0x33])
		performTestDouble(name: "Test Double #4", value: Double(998.345), expected: [0xcb, 0x40, 0x8f, 0x32, 0xc2, 0x8f, 0x5c, 0x28, 0xf6])
	}
	
	// MARK: - Helper Functions
	
	func performTestDouble(name testName: String, value: Double, expected bytes: [UInt8]) {
		var packed = Data()
		
		do {
			try packed.pack(value)
			
			guard packed.count == bytes.count else {
				XCTFail("[\(testName)] Packed value different from expected data (\(packed.count) bytes, \(bytes.count) expected)")
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
			
			guard let unpacked = try packed.unpack() else {
				XCTFail("[\(testName)] Failed to unpack")
				return
			}
			
			guard let value_float = unpacked as? Double else {
				XCTFail("[\(testName)] Failed to cast value to a valid Double type")
				return
			}
			
			guard value_float == value else {
				XCTFail("[\(testName)] Unpacked value is different from the original")
				return
			}
			
		} catch let err {
			// Something went wrong while packing data
			XCTFail("[\(testName)] Failed to pack Double: \(err) (src='\(value)')")
			return
		}
	}
	
	func performTestFloat(name testName: String, value: Float, expected bytes: [UInt8]) {
		var packed = Data()

		do {
			try packed.pack(value)
			
			guard packed.count == bytes.count else {
				XCTFail("[\(testName)] Packed value different from expected data (\(packed.count) bytes, \(bytes.count) expected)")
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
			
			guard let unpacked = try packed.unpack() else {
				XCTFail("[\(testName)] Failed to unpack")
				return
			}
			
			guard let value_float = unpacked as? Float else {
				XCTFail("[\(testName)] Failed to cast value to a valid Float type")
				return
			}
			
			guard value_float == value else {
				XCTFail("[\(testName)] Unpacked value is different from the original")
				return
			}
			
		} catch let err {
			// Something went wrong while packing data
			XCTFail("[\(testName)] Failed to pack Float: \(err) (src='\(value)')")
			return
		}
	}
	
	func performTestInt64(name testName: String, value: Int64, expected bytes: [UInt8]) {
		var packed = Data()
		do {
			try packed.pack(value)
			
			guard packed.count == bytes.count else {
				XCTFail("[\(testName)] Packed value different from expected data (\(packed.count) bytes, \(bytes.count) expected)")
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
			
			guard let unpacked = try packed.unpack() else {
				XCTFail("[\(testName)] Failed to unpack")
				return
			}
			
			var value_Int64: Int64
			if let tmpval = unpacked as? UInt64 {
				value_Int64 = Int64(bitPattern: tmpval)
			} else if let tmpval = unpacked as? Int64 {
				value_Int64 = tmpval
			} else if let tmpval = unpacked as? UInt32 {
				value_Int64 = Int64(tmpval)
			} else if let tmpval = unpacked as? Int32 {
				value_Int64 = Int64(tmpval)
			} else if let tmpval = unpacked as? UInt16 {
				value_Int64 = Int64(tmpval)
			} else if let tmpval = unpacked as? Int16 {
				value_Int64 = Int64(tmpval)
			} else if let tmpval = unpacked as? UInt8 {
				value_Int64 = Int64(tmpval)
			} else if let tmpval = unpacked as? Int8 {
				value_Int64 = Int64(tmpval)
			} else {
				XCTFail("[\(testName)] Failed to cast value to a valid Int64")
				return
			}
			
			guard value_Int64 == value else {
				XCTFail("[\(testName)] Unpacked value is different from the original")
				return
			}
			
		} catch let err {
			// Something went wrong while packing data
			XCTFail("[\(testName)] Failed to pack UInt64: \(err) (src='\(value)')")
			return
		}
	}
	
	func performTestUInt64(name testName: String, value: UInt64, expected bytes: [UInt8]) {
		var packed = Data()
		do {
			try packed.pack(value)
			
			guard packed.count == bytes.count else {
				XCTFail("[\(testName)] Packed value different from expected data (\(packed.count) bytes, \(bytes.count) expected)")
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
			
			guard let unpacked = try packed.unpack() else {
				XCTFail("[\(testName)] Failed to unpack")
				return
			}
			
			var value_UInt64: UInt64
			if let value = unpacked as? UInt64 {
				value_UInt64 = value
			} else if let value = unpacked as? Int64 {
				value_UInt64 = UInt64(value)
			} else if let value = unpacked as? UInt32 {
				value_UInt64 = UInt64(value)
			} else if let value = unpacked as? Int32 {
				value_UInt64 = UInt64(value)
			} else if let value = unpacked as? UInt16 {
				value_UInt64 = UInt64(value)
			} else if let value = unpacked as? Int16 {
				value_UInt64 = UInt64(value)
			} else if let value = unpacked as? UInt8 {
				value_UInt64 = UInt64(value)
			} else if let value = unpacked as? Int8 {
				value_UInt64 = UInt64(value)
			} else {
				XCTFail("[\(testName)] Failed to cast value to a valid UInt64")
				return
			}
			
			guard value_UInt64 == value else {
				XCTFail("[\(testName)] Unpacked value is different from the original")
				return
			}
			
		} catch let err {
			// Something went wrong while packing data
			XCTFail("[\(testName)] Failed to pack UInt64: \(err) (src='\(value)')")
			return
		}
	}
	
	func performTestInt32(name testName: String, value: Int32, expected bytes: [UInt8]) {
		var packed = Data()
		do {
			try packed.pack(value)
			
			guard packed.count == bytes.count else {
				XCTFail("[\(testName)] Packed value different from expected data (\(packed.count) bytes, \(bytes.count) expected)")
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
			
			guard let unpacked = try packed.unpack() else {
				XCTFail("[\(testName)] Failed to unpack")
				return
			}
			
			var value_Int32: Int32
			if let value = unpacked as? UInt32 {
				value_Int32 = Int32(bitPattern: value)
			} else if let value = unpacked as? Int32 {
				value_Int32 = value
			} else if let value = unpacked as? UInt16 {
				value_Int32 = Int32(value)
			} else if let value = unpacked as? Int16 {
				value_Int32 = Int32(value)
			} else if let value = unpacked as? UInt8 {
				value_Int32 = Int32(value)
			} else if let value = unpacked as? Int8 {
				value_Int32 = Int32(value)
			} else {
				XCTFail("[\(testName)] Failed to cast value to a valid Int32")
				return
			}
			
			guard value_Int32 == value else {
				XCTFail("[\(testName)] Unpacked value is different from the original")
				return
			}
			
		} catch let err {
			// Something went wrong while packing data
			XCTFail("[\(testName)] Failed to pack Int32: \(err) (src='\(value)')")
			return
		}
	}
	
	func performTestUInt32(name testName: String, value: UInt32, expected bytes: [UInt8]) {
		var packed = Data()
		do {
			try packed.pack(value)
			
			guard packed.count == bytes.count else {
				XCTFail("[\(testName)] Packed value different from expected data (\(packed.count) bytes, \(bytes.count) expected)")
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
			
			guard let unpacked = try packed.unpack() else {
				XCTFail("[\(testName)] Failed to unpack")
				return
			}
			
			var value_UInt32: UInt32
			if let val = unpacked as? UInt32 {
				value_UInt32 = val
			} else if let val = unpacked as? Int32 {
				value_UInt32 = UInt32(val)
			} else if let val = unpacked as? UInt16 {
				value_UInt32 = UInt32(val)
			} else if let val = unpacked as? Int16 {
				value_UInt32 = UInt32(val)
			} else if let val = unpacked as? UInt8 {
				value_UInt32 = UInt32(val)
			} else if let val = unpacked as? Int8 {
				value_UInt32 = UInt32(val)
			} else {
				XCTFail("[\(testName)] Failed to cast value to a valid UInt32")
				return
			}
			
			guard value_UInt32 == value else {
				XCTFail("[\(testName)] Unpacked value is different from the original")
				return
			}
			
		} catch let err {
			// Something went wrong while packing data
			XCTFail("[\(testName)] Failed to pack UInt32: \(err) (src='\(value)')")
			return
		}
	}
	
	func performTestInt16(name testName: String, value: Int16, expected bytes: [UInt8]) {
		var packed = Data()
		do {
			try packed.pack(value)
			
			guard packed.count == bytes.count else {
				XCTFail("[\(testName)] Packed value different from expected data (\(packed.count) bytes, \(bytes.count) expected)")
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
			
			guard let unpacked = try packed.unpack() else {
				XCTFail("[\(testName)] Failed to unpack")
				return
			}
			
			var value_Int16: Int16
			if let value = unpacked as? UInt16 {
				value_Int16 = Int16(value)
			} else if let value = unpacked as? Int16 {
				value_Int16 = Int16(value)
			} else if let value = unpacked as? UInt8 {
				value_Int16 = Int16(value)
			} else if let value = unpacked as? Int8 {
				value_Int16 = Int16(value)
			} else {
				XCTFail("[\(testName)] Failed to cast value to a valid Int16")
				return
			}

			guard value_Int16 == value else {
				XCTFail("[\(testName)] Unpacked value is different from the original")
				return
			}
			
		} catch let err {
			// Something went wrong while packing data
			XCTFail("[\(testName)] Failed to pack Int16: \(err) (src='\(value)')")
			return
		}
	}
	
	func performTestUInt16(name testName: String, value: UInt16, expected bytes: [UInt8]) {
		var packed = Data()
		do {
			try packed.pack(value)
			
			guard packed.count == bytes.count else {
				XCTFail("[\(testName)] Packed value different from expected data (\(packed.count) bytes, \(bytes.count) expected)")
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
			
			guard let unpacked = try packed.unpack() else {
				XCTFail("[\(testName)] Failed to unpack")
				return
			}
			
			var value_uInt16: UInt16
			if let val = unpacked as? UInt16 {
				value_uInt16 = val
			} else if let val = unpacked as? Int16 {
				value_uInt16 = UInt16(val)
			} else if let val = unpacked as? UInt8 {
				value_uInt16 = UInt16(val)
			} else if let val = unpacked as? Int8 {
				value_uInt16 = UInt16(val)
			} else {
				XCTFail("[\(testName)] Failed to cast value to a valid UInt16")
				return
			}
			
			guard value_uInt16 == value else {
				XCTFail("[\(testName)] Unpacked value is different from the original")
				return
			}
			
		} catch let err {
			// Something went wrong while packing data
			XCTFail("[\(testName)] Failed to pack UInt16: \(err) (src='\(value)')")
			return
		}
	}
	
	func performTestInt8(name testName: String, value: Int8, expected bytes: [UInt8]) {
		var packed = Data()
		do {
			try packed.pack(value)
			
			guard packed.count == bytes.count else {
				XCTFail("[\(testName)] Packed value different from expected data (\(packed.count) bytes, \(bytes.count) expected)")
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
			
			guard let unpacked = try packed.unpack() else {
				XCTFail("[\(testName)] Failed to unpack")
				return
			}
			
			guard let unpacked_value = unpacked as? Int8 else {
				XCTFail("[\(testName)] Failed to unpack to a valid Int8")
				return
			}
			
			
			guard unpacked_value == value else {
				XCTFail("[\(testName)] Unpacked value is not equal to the original value")
				return
			}
			
		} catch let err {
			// Something went wrong while packing data
			XCTFail("[\(testName)] Failed to pack Int8: \(err) (src='\(value)')")
			return
		}
	}
	
	func performTestUInt8(name testName: String, value: UInt8, expected bytes: [UInt8]) {
		var packed = Data()
		do {
			try packed.pack(value)
			
			guard packed.count == bytes.count else {
				XCTFail("[\(testName)] Packed value different from expected data (\(packed.count) bytes, \(bytes.count) expected)")
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
			
			guard let unpacked = try packed.unpack() else {
				XCTFail("[\(testName)] Failed to unpack")
				return
			}
			
			var unpacked_value: UInt8
			if let tmpval = unpacked as? UInt8 {
				unpacked_value = tmpval
			} else if let tmpval = unpacked as? Int8 {
				unpacked_value = UInt8(tmpval)
			} else {
				XCTFail("[\(testName)] Failed to unpack to a valid UIn8")
				return
			}

			
			guard unpacked_value == value else {
				XCTFail("[\(testName)] Unpacked value is not equal to the original value")
				return
			}
			
		} catch let err {
			// Something went wrong while packing data
			XCTFail("[\(testName)] Failed to pack uInt8: \(err) (src='\(value)')")
			return
		}
	}
	
}
