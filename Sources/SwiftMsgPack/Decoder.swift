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

// MARK: Helper Struct to read and decoded stream of `Data`

private struct StreamReader {
	
	/// Pointer to `data` instance
	private var data: Data
	
	/// Current position on `data` instance
	private var index: Int
	
	/// Initialize a new stream with an input data
	///
	/// - Parameter data: data to read
	public init(_ data: Data) {
		self.data = data
		self.index = 0
	}
	
	/// Read the next data type header of the structure (8 bit) and move the index by 1 position
	///
	/// - Returns: data type value
	/// - Throws: throw an exception if data cannot be read or it's not available
	mutating func readType() throws -> UInt8 {
		guard index < data.count else {
			throw MsgPackError.unexpectedData
		}
		let type: UInt8 = data[Data.Index(index)]
		index += 1
		return type
	}
	
	/// Read 8 bit value and return it and move the index by 1 position
	///
	/// - Returns: 8 bit value
	/// - Throws: throw an exception if data cannot be read or it's not available
	mutating func read8Bit() throws -> UInt8 {
		return try readType()
	}
	
	
	/// Read next 16 bytes and return the value (index is moved according to the task)
	///
	/// - Returns: value read
	/// - Throws: throw an exception if data cannot be read or it's not available
	mutating func read16Bit() throws -> UInt16 {
		guard index + 2 <= data.count else {
			throw MsgPackError.unexpectedData
		}
		let value_int16 = UInt16(data[Data.Index(index)]) << 8 + UInt16(data[Data.Index(index + 1)])
		index += 2
		return value_int16
	}
	
	/// Read next 32 bytes and return the value (index is moved according to the task)
	///
	/// - Returns: value read
	/// - Throws: throw an exception if data cannot be read or it's not available
	mutating func read32Bit() throws -> UInt32 {
		guard index + 4 <= data.count else {
			throw MsgPackError.unexpectedData
		}
		var value_int32: UInt32 = 0
		for idx in index...(index + 3) {
			value_int32 = (value_int32 << 8) + UInt32(data[Data.Index(idx)])
		}
		index += 4
		return value_int32
	}
	
	/// Read next 64 bytes and return the value (index is moved according to the task)
	///
	/// - Returns: value read
	/// - Throws: throw an exception if data cannot be read or it's not available
	mutating func read64Bit() throws -> UInt64 {
		guard index + 8 <= data.count else {
			throw MsgPackError.unexpectedData
		}
		var value_int64: UInt64 = 0
		for idx in index...(index + 7) {
			value_int64 = (value_int64 << 8) + UInt64(data[Data.Index(idx)])
		}
		index += 8
		return value_int64
	}
	
	
	/// Read next `length` bytes of data and return it (index is moved according to it)
	///
	/// - Parameter length: length of data to read
	/// - Returns: read value
	/// - Throws: throw an exception if data cannot be read or it's not available
	mutating func readData(length: Int) throws -> Data {
		guard index + length <= data.count else {
			throw MsgPackError.unexpectedData
		}
		let range = Range(index..<(index + length))
		index += length
		return data.subdata(in: range)
	}
}

// MARK: Unpack of MsgPack Data

public extension Data {
	
	// MARK - Unpack
	
	/// This is the public function which can read a sequence of Data
	/// and unpack all objects by returning decoded data.
	///
	/// - Returns: decoded data
	/// - Throws: an error if decoding task cannot be finished correctly due to an error
	public func unpack() throws -> Any? {
		// Create a reader which has a point to the current position in data instance
		// and several help functions to read data
		var reader = StreamReader(self)
		// try to unpack data
		return try self.unpack(stream: &reader)
	}
	
	// MARK - Unpack Internal Functions 

	/// This is the unpack function which reader
	///
	/// - Parameter stream: stream object
	/// - Returns: decoded data
	/// - Throws: an error if decoding task cannot be finished correctly due to an error
	private func unpack(stream: inout StreamReader) throws -> Any? {
		let type = try stream.readType()
		
		// Spec is defined here:
		// https://github.com/msgpack/msgpack/blob/master/spec.md#formats-bool
		switch type {
		
		// POSITIVE FIX INT
		// positive fixint	0xxxxxxx	0x00 - 0x7f
		case 0x00...0x7f:
			return Int8(type)
		
		// FIX DICTIONARY (< 16 ITEMS)
		// fixmap	1000xxxx	0x80 - 0x8f
		case 0x80...0x8f:
			let count_items = Int(type & 0xf)
			return try self.unpack(dictionary: &stream, count: count_items)
			
		// FIX ARRAY (< 16 ITEMS)
		// fixarray	1001xxxx	0x90 - 0x9f
		case 0x90...0x9f:
			let count_items = Int(type & 0xf)
			return try self.unpack(array: &stream, count: count_items)
			
		// NEGATIVE FIX NUM
		// negative fixint	111xxxxx	0xe0 - 0xff
		case 0xe0...0xff:
			return Int8( Int(type) - 256)
		
		// FIX STRING (< 16 CHARS)
		// fixstr	101xxxxx	0xa0 - 0xbf
		case 0xa0...0xbf:
			let str_length = Int(type - 0xa0)
			return try self.unpack(string: &stream, length: str_length)
		
		// NIL VALUE
		// nil	11000000	0xc0
		case 0xc0:
			return nil
			
		// BOOLEAN FALSE
		// false 	11000010	0xc2
		case 0xc2:
			return false
		
		// BOOLEAN TRUE
		// true	11000011	0xc3
		case 0xc3:
			return true
		
		// BINARY DATA 8 BIT
		// bin 8	11000100	0xc4
		case 0xc4:
			let len_data = Int(try stream.read8Bit())
			return try stream.readData(length: len_data)
			
		// BINARY DATA 16 BIT
		// bin 16	11000101	0xc5
		case 0xc5:
			let len_data = Int(try stream.read16Bit())
			return try stream.readData(length: len_data)
			
		// BINARY DATA 32 BIT
		// bin 32	11000110	0xc6
		case 0xc6:
			let len_data = Int(try stream.read32Bit())
			return try stream.readData(length: len_data)
			
		// FLOAT 32 BIT
		// float 32	11001010	0xca
		case 0xca:
			return Float(bitPattern: try stream.read32Bit())
		
		// DOUBLE
		// float 64	11001011	0xcb
		case 0xcb:
			return Double(bitPattern: try stream.read64Bit())
		
		// UNSIGNED INT 8 BIT
		// uint 8	11001100	0xcc
		case 0xcc:
			return try stream.readType()
		
		// UNSIGNED INT 16 BIT
		// uint 16	11001101	0xcd
		case 0xcd:
			let h = UInt16(try stream.read8Bit())
			let l = UInt16(try stream.read8Bit())
			return (h << 8 + l)
		
		// UNSIGNED INT 32 BIT
		// uint 32	11001110	0xce
		case 0xce:
			return try stream.read32Bit()
		
		// UNSIGNED INT 64 BIT
		// uint 64	11001111	0xcf
		case 0xcf:
			return try stream.read64Bit()
		
		// INT 8 BIT
		// int 8	11010000	0xd0
		case 0xd0:
			let value = try stream.read8Bit()
			return Int8(Int(value) - 256)
		
		// INT 16 BIT
		// int 16	11010001	0xd1
		case 0xd1:
			let h = UInt16(try stream.read8Bit())
			let l = UInt16(try stream.read8Bit())
			return Int16(bitPattern: h << 8 + l)
		
		// INT 32 BIT
		// int 32	11010010	0xd2
		case 0xd2:
			return try Int32(bitPattern: stream.read32Bit())
		
		// INT 64 BIT
		// int 64	11010011	0xd3
		case 0xd3:
			return try Int64(bitPattern: stream.read64Bit())
		
		// STRING 8 BIT LENGTH
		// str 8	11011001	0xd9
		case 0xd9:
			let len_data = Int(try stream.read8Bit())
			return try unpack(string: &stream, length: len_data)
		
		// STRING 16 BIT LENGTH
		// str 16	11011010	0xda
		case 0xda:
			let len_data = Int(try stream.read8Bit()) << 8 + Int(try stream.read8Bit())
			return try unpack(string: &stream, length: len_data)
		
		// STRING 32 BIT LENGTH
		// str 32	11011011	0xdb
		case 0xdb:
			let len_data =  Int(try stream.read8Bit()) << 24 +
							Int(try stream.read8Bit()) << 16 +
							Int(try stream.read8Bit()) << 8 +
							Int(try stream.read8Bit())
			return try unpack(string: &stream, length: len_data)

			
		// ARRAY 16 ITEMS LENGTH
		// array 16	11011100	0xdc
		case 0xdc:
			let count_items = Int(try stream.read16Bit())
			return try unpack(array: &stream, count: count_items)
			
		// ARRAY 32 ITEMS LENGTH
		// array 32	11011101	0xdd
		case 0xdd:
			let count_items = Int(try stream.read32Bit())
			return try unpack(array: &stream, count: count_items)
			
		// DICTIONARY 16 ITEMS LENGTH
		// map 16	11011110	0xde
		case 0xde:
			let count_items = Int(try stream.read16Bit())
			return try unpack(dictionary: &stream, count: count_items)
			
		// DICTIONARY 32 ITEMS LENGTH
		// map 32	11011111	0xdf
		case 0xdf:
			let count_items = Int(try stream.read32Bit())
			return try unpack(dictionary: &stream, count: count_items)
			
		default:
			throw MsgPackError.unsupportedValue(String(format: "Type(%02x)", type))
		}
	}
	
	/// Unpack a `dictionary` sequence
	///
	/// - Parameters:
	///   - stream: input stream of data
	///   - count: number of keys in dictionary
	/// - Returns: decoded dictionary
	/// - Throws: throw an exception if failed to decoded data
	private func unpack(dictionary stream: inout StreamReader, count: Int) throws -> [AnyHashable: Any?] {
		var dict: [AnyHashable: Any?] = [:]
		for _ in 0..<count {
			guard let key = try self.unpack(stream: &stream) as? AnyHashable else {
				throw MsgPackError.unsupportedValue("Invalid dict key")
			}
			let val = try self.unpack(stream: &stream)
			dict[key] = val
		}
		return dict
	}
	
	/// Unpack an `array` sequence
	///
	/// - Parameters:
	///   - stream: input stream of data
	///   - count: number of keys in array
	/// - Returns: decoded array
	/// - Throws: throw an exception if failed to decoded data
	private func unpack(array stream: inout StreamReader, count: Int) throws -> [Any?] {
		var array: [Any?] = []
		for _ in 0..<count {
			array.append(try self.unpack(stream: &stream))
		}
		return array
	}
	
	
	/// Unpack a `string` sequence
	///
	/// - Parameters:
	///   - stream: input stream of data
	///   - length: length of data to read
	/// - Returns: decoded string
	/// - Throws: throw an exception if failed to decoded data
	private func unpack(string stream: inout StreamReader, length: Int) throws -> String {
		let data = try stream.readData(length: length)
		guard let str = String(data: data, encoding: String.Encoding.utf8) else {
			throw MsgPackError.invalidEncoding
		}
		return str
	}
	
}
