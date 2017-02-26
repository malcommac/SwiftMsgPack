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

/// Error MsgPack encoder/decoder may generate during the elaboration of the data
///
/// - invalidEncoding: invalid encoding. string cannot be encoded correctly in UTF-8
/// - unexpectedData: missing data
/// - dataIsTooBig: data is too large to be contained in a MsgPack data (see https://github.com/msgpack/msgpack/blob/master/spec.md#types-limitation)
/// - unsupportedValue: unsupported value
public enum MsgPackError: Error {
	case invalidEncoding
	case unexpectedData
	case dataIsTooBig(_: String)
	case unsupportedValue(_: Any)
}

// This enum defines the prefix header bytes to write
// according to the MsgPack specs
// https://github.com/msgpack/msgpack/blob/master/spec.md#formats-bool
public enum MsgPackType: CustomStringConvertible {
	
	// numeric vlues
	case uInt64
	case int64
	case uInt32
	case int32
	case uInt16
	case int16
	case uInt8
	case pFixInt8(value: Int)
	case nFixInt(value: Int)
	case nInt8
	case nInt16
	case nInt32
	case nInt64
	case float
	case double
	case fixstr
	// string
	case str(length: Int)
	// binary data
	case bin8
	case bin16
	case bin32
	// array
	case array(items: Int)
	case fixarray(items: Int)
	case array16
	case array32
	// dictionary
	case dict(items: Int)
	case fixdict(items: Int)
	case dict16
	case dict32
	// nil
	case `nil`
	// bool
	case boolean(_: Bool)
	
	/// The `UInt8` which represent the type of data
	public func value() throws -> UInt8 {
		switch self {
		
		// numeric values
		case .uInt64:				return UInt8(0xcf)			// uint 64	11001111	0xcf
		case .int64:				return UInt8(0xd3)			// int 64	11010011	0xd3
		case .uInt32:				return UInt8(0xce)			// uint 32	11001110	0xce
		case .int32:				return UInt8(0xd2)			// int 32	11010010	0xd2
		case .uInt16:				return UInt8(0xcd)			// uint 16	11001101	0xcd
		case .int16:				return UInt8(0xd1)			// int 16	11010001	0xd1
		case .uInt8:				return UInt8(0xcc)			// uint 8	11001100	0xcc
		case .pFixInt8(let value):	return UInt8(value & 0x7f)	// positive fixint	0xxxxxxx	0x00 - 0x7f
		case .nFixInt(let value):	return UInt8(value & 0xff)	// negative fixint	111xxxxx	0xe0 - 0xff
		case .nInt8:				return UInt8(0xd0)			// int 8	11010000	0xd0
		case .nInt16:				return UInt8(0xd1)			// int 16	11010001	0xd1
		case .nInt32:				return UInt8(0xd2)			// int 32	11010010	0xd2
		case .nInt64:				return UInt8(0xd3)			// int 64	11010011	0xd3
		case .float:				return UInt8(0xca)			// float 32	11001010	0xca
		case .double:				return UInt8(0xcb)			// float 64	11001011	
		
		// binary data
		case .bin8:					return UInt8(0xc4)			// bin 8	11000100	0xc4
		case .bin16:				return UInt8(0xc5)			// bin 16	11000101	0xc5
		case .bin32:				return UInt8(0xc6)			// bin 32	11000110	0xc6
		
		// array
		case .fixarray(let count):	return UInt8(0x90 + count)	// fixarray	1001xxxx	0x90 - 0x9f
		case .array16:				return UInt8(0xdc)			// array 16	11011100	0xdc
		case .array32:				return UInt8(0xdd)			// array 32	11011101	0xdd
		case .array(let count):
			if count < 16 { // less than 16 bit length
				return try MsgPackType.fixarray(items: count).value()
			}
			else if count < Int(UInt16.max) { // 16 bit length
				return try MsgPackType.array16.value()
			}
			else { //if count < Int(UInt32.max) { // 32 bit length
				return try MsgPackType.array32.value()
			}
			//throw MsgPackError.dataIsTooBig("Array is too big: \(count) items")
			
		// string
		case .fixstr:				return UInt8(0xa0)			// fixstr	101xxxxx	0xa0 - 0xbf
		case .str(let length):
			if length < 32 {
				// 0xa0 + length of the string
				return UInt8(try MsgPackType.fixstr.value() + UInt8(length))
			}
			else if length < Int(UInt8.max) {
				// str 8	11011001	0xd9
				return UInt8(0xd9)
			}
			else if length < Int(UInt16.max) {
				// str 16	11011010	0xda
				return UInt8(0xda)
			}
			else { //if length < Int(UInt32.max) {
				// str 32	11011011	0xdb
				return UInt8(0xdb)
			}
			//throw MsgPackError.dataIsTooBig("String is too long: \(length) chars")

		// dictionaries
		case .fixdict(let count):	return UInt8(0x80 + count)	// fixmap	1000xxxx	0x80 - 0x8f
		case .dict16:				return UInt8(0xde)			// map 16	11011110	0xde
		case .dict32:				return UInt8(0xdf)			// map 32	11011111	0xdf
		case .dict(let count):
			if count < 16 { // less than 16 bit
				return try MsgPackType.fixdict(items: count).value()
			}
			else if count < Int(UInt16.max) { // 16 bit
				return try MsgPackType.dict16.value()
			}
			else { //if count < Int(UInt32.max) { // 32 bit
				return try MsgPackType.dict32.value()
			}
			//throw MsgPackError.dataIsTooBig("Dictionary is too big: \(count) keys")

		// nil values
		case .nil:					return UInt8(0xc0)
		
		// boolean values
		case .boolean(let v):		return UInt8(v ? 0xc3 : 0xc2)
		}
	}

	/// String representation
	public var description: String {
		switch self {
		case .uInt64:					return "uInt64"
		case .int64:					return "int64"
		case .uInt32:					return "uInt32"
		case .int32:					return "int32"
		case .uInt16:					return "uInt16"
		case .int16:					return "int16"
		case .uInt8:					return "uInt8"
		case .pFixInt8(let value):		return "pFixInt8 (val= \(value))"
		case .nFixInt(let value):		return "pFixInt8 (val= \(value))"
		case .nInt8:					return "nInt8"
		case .nInt16:					return "nInt16"
		case .nInt32:					return "nInt32"
		case .nInt64:					return "nInt64"
		case .float:					return "float"
		case .double:					return "double"
		case .fixstr:					return "fixstr"
		case .str(let len):				return "str (len= \(len))"
		case .bin8:						return "bin8"
		case .bin16:					return "bin16"
		case .bin32:					return "bin32"
		case .array(let count):			return "array (count= \(count))"
		case .fixarray(let count):		return "fixarray (count= \(count))"
		case .array16:					return "array16"
		case .array32:					return "array32"
		case .dict(let count):			return "dict (keys= \(count))"
		case .fixdict(let count):		return "fixdict (keys= \(count))"
		case .dict16:					return "dict16"
		case .dict32:					return "dict32"
		case .`nil`:					return "nil"
		case .boolean(let val):			return "bool (is true=\(val))"
			
		}
	}
}
