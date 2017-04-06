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


// MARK: - Pack

public extension Data {
	
	// MARK: - Pack functions
	
	/// Allows you to pack multiple objects passed as input.
	/// See `pack(_ obj:Any?)` for more info about supported formats.
	///
	/// - Parameter objects: objects to pack
	/// - Returns: `self` `(maybe used to chain multiple pack`)
	/// - Throws: throw an exception if packing fails for some reason
	@discardableResult
	public mutating func pack(_ objects: Any?...) throws -> Data {
		try objects.forEach { try self.pack($0) }
		return self
	}
	
	/// This is the main func used to pack an object.
	/// Packing is done by mutating `self` instance of `Data` caller of the function.
	/// Recognized types includes:
	/// `String`,`UInt8`,`UInt16`,`UInt32`,`UInt64`,`Int8`,`Int16`,`Int32`,`Int64`,
	/// `Double`,`Float`,`Int`,`UInt`,`Character`,`Bool`,`Array` and `Dictionary`.
	/// Also nil objects are accepted and encoded according to the msgpack format.
	///
	/// - Parameter obj: object to pack or `nil`
	/// - Returns: `self` `(maybe used to chain multiple pack`)
	/// - Throws: throw an exception if packing fails for some reason
	@discardableResult
	public mutating func pack(_ obj: Any?) throws -> Data {
		
		guard let obj = obj else {
			// If the object is nil we want to write the nil
			// msgpack prefix (0xc0)
			try  self.writeDataTypeHeader(.nil)
			return self
		}
		
		// STRING
		if let value_str = obj as? String {
			try self.pack(string: value_str)
		}
		
		// UNSIGNED INT
		else if let value_u8 = obj as? UInt8 { // 8 BIT
			//try self.pack(signedInt: Int(value_u8))
			try self.pack(unsignedInt: UInt64(value_u8))
		}
		else if let value_u16 = obj as? UInt16 { // 16 BIT
			//try self.pack(signedInt: Int(value_u16))
			try self.pack(unsignedInt: UInt64(value_u16))
		}
		else if let value_u32 = obj as? UInt32 { // 32 BIT
			//try self.pack(signedInt: Int(value_u32))
			try self.pack(unsignedInt: UInt64(value_u32))
		}
		else if let value_u64 = obj as? UInt64 { // 64 BIT
			//try self.pack(unsignedInt: UInt(value_u64))
			try self.pack(unsignedInt: value_u64)
		}
			
			
		// SIGNED INT
		else if let value_i8 = obj as? Int8 { // 8 BIT
			try self.pack(signedInt: Int(value_i8))
		}
		else if let value_i16 = obj as? Int16 { // 16 BIT
			try self.pack(signedInt: Int(value_i16))
		}
		else if let value_i32 = obj as? Int32 { // 32 BIT
			try self.pack(signedInt: Int(value_i32))
		}
		else if let value_i64 = obj as? Int64 { // 64 BIT
			try self.pack(signedInt: Int(value_i64))
		}
			
			
		// DOUBLE
		else if let value_double = obj as? Double {
			try self.pack(double: value_double)
		}
		// FLOAT
		else if let value_float = obj as? Float {
			try self.pack(float: value_float)
		}
		// INT
		else if let value_int = obj as? Int {
			try self.pack(signedInt: value_int)
		}
		// UNSIGNED INT
		else if let value_uint = obj as? UInt {
			//try self.pack(unsignedInt: value_uint)
			try self.pack(unsignedInt: UInt64(value_uint))
		}
			
			
		// CHARACTER
		else if let value_char = obj as? Character {
			try self.pack(string: String(value_char))
		}
		// BOOLEAN VALUES
		else if let value_bool = obj as? Bool {
			try self.pack(boolean: value_bool)
		}
		
		// ARRAY
		else if let value_array = obj as? [Any?] {
			try self.pack(array: value_array)
		}
		// DICTIONARIES
		else if let value_dict = obj as? [AnyHashable: Any] {
			try self.pack(dict: value_dict)
		}
		// DICTIONARIES WITH OPTIONAL VALUES
		else if let value_dict = obj as? [AnyHashable: Any?] {
			try self.pack(dict: value_dict)
		}
		// DATA
		else if let value_data = obj as? Data {
			try self.pack(data: value_data)
		}
			
		// Not supported fallback
		else {
			throw MsgPackError.unsupportedValue(obj)
		}
		return self
	}
	
	// MARK: - Pack `string` value
	
	/// This function pack a String instance
	///
	/// - Parameter value: string to pack
	/// - Returns: the instance of `self` modified with the packed data
	/// - Throws: throw if string cannot be encoded (`.invalidEncoding`) or data is too much
	///           to be packed in a MsgPack message (`.dataIsTooBig`)
	@discardableResult
	private mutating func pack(string value: String) throws -> Data {
		guard !value.isEmpty else { // String instance is empty
			// Fixed string length (fixstr	101xxxxx	0xa0 - 0xbf)
			try self.writeDataTypeHeader(.fixstr)
			return self
		}
		// Attempt to encode the String instance to a data by encoding it using UTF-8
		guard let encoded_data = value.data(using: String.Encoding.utf8) else {
			// Something went wrong and we can't continue packing data
			throw MsgPackError.invalidEncoding
		}
		
		// Write specific header for string
		let len = encoded_data.count
		try self.writeHeader(forString: len)
		// Write the contents of data
		self.writeData(encoded_data)
		return self
	}
	
	// MARK: - Pack `boolean` value
	
	/// Pack a boolean value.
	/// Bool format family stores false or true in 1 byte (0xc2 for false and 0xc3 for true).
	/// (Specs: https://github.com/msgpack/msgpack/blob/master/spec.md#formats-bool)
	///
	/// - Parameter bool: boolean value to pack
	/// - Returns: the instance of `self` modified with the packed data
	@discardableResult
	public mutating func pack(boolean bool: Bool) throws -> Data {
		try self.writeDataTypeHeader(.boolean(bool))
		return self
	}
	
	// MARK: - Pack UInt
	
	/// Pack an unsigned `int` value
	///
	/// - Parameter value: value to pack
	/// - Returns: the instance of `self` modified with the packed data
	/// - Throws: throw an exception if value cannot be encoded because is too large to be contained in a MsgPack message
	@discardableResult
	private mutating func pack(unsignedInt value: UInt64) throws -> Data {
		switch value {
		case 0...127:
			try self.writeDataTypeHeader(.pFixInt8(value: Int(value)))
			
		case UInt64(UInt8.min)...UInt64(UInt8.max):
			try self.writeDataTypeHeader(.uInt8)
			
			var data = UInt8(value)
			self.append(UnsafeBufferPointer(start: &data, count: 1))
			
		case UInt64(UInt16.min)...UInt64(UInt16.max):
			try self.writeDataTypeHeader(.uInt16)
			
			var data = UInt16(value).bigEndian
			self.append(UnsafeBufferPointer(start: &data, count: 1))
			
		case UInt64(UInt32.min)...UInt64(UInt32.max):
			try self.writeDataTypeHeader(.uInt32)
			
			var data = UInt32(value).bigEndian
			self.append(UnsafeBufferPointer(start: &data, count: 1))
			
		default:
			try self.writeDataTypeHeader(.uInt64)
			// Write value
			var data = UInt64(value).bigEndian
			self.append(UnsafeBufferPointer(start: &data, count: 1))
		}
		
		return self
	}
	
	// MARK: - Pack Int
	
	/// Pack a signed `int` value
	///
	/// - Parameter value: value to encode
	/// - Returns: the instance of `self` modified with the packed data
	/// - Throws: throw an exception is value is too large to be encoded in a MsgPack message
	@discardableResult
	private mutating func pack(signedInt value: Int) throws -> Data {
		switch value {
		// POSITIVE INT 32 BIT
		case (Int(UInt16.max) + 1)...Int(Int32.max):
			try self.writeDataTypeHeader(.int32)

			var data = UInt32(value).bigEndian
			self.append(UnsafeBufferPointer(start: &data, count: 1))
			
		// UNSIGNED INT 16 BIT
		case (Int(Int16.max) + 1)...Int(UInt16.max):
			try self.writeDataTypeHeader(.uInt16)

			var data = UInt16(value).bigEndian
			self.append(UnsafeBufferPointer(start: &data, count: 1))
			
		// POSITIVE INT 16 BIT
		case (Int(UInt8.max) + 1)...Int(Int16.max):
			try self.writeDataTypeHeader(.int16)

			var data = UInt16(value).bigEndian
			self.append(UnsafeBufferPointer(start: &data, count: 1))
			
		// UNSIGNED INT 8 BIT
		case (Int(Int8.max) + 1)...Int(UInt8.max):
			try self.writeDataTypeHeader(.uInt8)
			
			var data = UInt8(value)
			self.append(UnsafeBufferPointer(start: &data, count: 1))
			
		// POSITIVE INT 8 BIT
		case 0...Int(Int8.max):
			try self.writeDataTypeHeader(.pFixInt8(value: value))

		// NEGATIVE FIX INT
		case -32..<0:
			try self.writeDataTypeHeader(.nFixInt(value: value))
		
		// NEGATIVE INT 8 BIT
		case Int(Int8.min)...(-33):
			try self.writeDataTypeHeader(.nInt8)

			var data = UInt8(value & 0xff)
			self.append(UnsafeBufferPointer(start: &data, count: 1))
		
		// NEGATIVE INT 16 BIT
		case Int(Int16.min)...(Int(Int8.min) - 1):
			try self.writeDataTypeHeader(.nInt16)

			var data = UInt16(bitPattern: Int16(value)).bigEndian
			self.append(UnsafeBufferPointer(start: &data, count: 1))
		
		// NEGATIVE INT 32 BIT
		case Int(Int32.min)...(Int(Int16.min) - 1):
			try self.writeDataTypeHeader(.nInt32)

			var data = UInt32(bitPattern: Int32(value)).bigEndian
			self.append(UnsafeBufferPointer(start: &data, count: 1))
		
		// INT 64 BIT
		default:
			try self.writeDataTypeHeader(.int64)
			
			var data = UInt64(bitPattern: Int64(value)).bigEndian
			self.append(UnsafeBufferPointer(start: &data, count: 1))
		}
		
		return self
	}
	
	// MARK: - Pack Float
	
	/// Pack a `float` value
	///
	/// - Parameter value: `float` value to pack
	/// - Returns: the instance of `self` modified with the packed data
	@discardableResult
	private mutating func pack(float value: Float) throws -> Data {
		try self.writeDataTypeHeader(.float)
		
		var data = value.bitPattern.bigEndian
		self.append(UnsafeBufferPointer(start: &data, count: 1))
		return self
	}
	
	// MARK: - Pack Double
	
	/// Pack a `double` value
	///
	/// - Parameter value: `double` value to pack
	/// - Returns: the instance of `self` modified with the packed data
	@discardableResult
	private mutating func pack(double value: Double) throws -> Data {
		try self.writeDataTypeHeader(.double)
		
		var data = value.bitPattern.bigEndian
		self.append(UnsafeBufferPointer(start: &data, count: 1))
		return self
	}
	
	// MARK: - Pack Data
	
	/// Pack `Data` instance
	///
	/// - Parameter value: value to pack
	/// - Returns: the instance of `self` modified with the packed data
	/// - Throws: throw an exception if data is too large to be contained in a MsgPack data
	@discardableResult
	private mutating func pack(data value: Data) throws -> Data {
		// Write data prefix based upon the length
		try self.writeHeader(forData: value.count)
		// Append the data itself
		self.writeData(value)
		return self
	}
	
	// MARK: - Pack Array
	
	/// Pack an `array` of `Any?` instances
	///
	/// - Parameter value: array to pack
	/// - Returns: the instance of `self` modified with the packed data
	/// - Throws: throw an exception if data is too large to be contained in a MsgPack data
	@discardableResult
	private mutating func pack(array value: [Any?]) throws -> Data {
		
		guard UInt32(bitPattern: Int32(value.count)) < UInt32.max else {
		//guard value.count < Int(UInt32.max) else {
			// Array is too large to be included in a MsgPack data
			throw MsgPackError.dataIsTooBig("Array is too big: \(value.count) items")
		}
		
		// Write the header of the array
		try self.writeHeader(forArray: value.count)
		// Let's encode each data contained in it
		try value.forEach {
			try self.pack($0)
		}
		return self
	}
	
	// MARK: - Pack Dictionary
	
	/// Pack `dictionary` with `AnyHashable` as key and `Any?` as value
	///
	/// - value: dictionary to pack
	/// - Returns: the instance of `self` modified with the packed data
	/// - Throws: throw an exception if data is too large to be contained in a MsgPack data
	@discardableResult
	private mutating func pack(dict value: [AnyHashable:Any?]) throws -> Data {
		
		guard UInt32(bitPattern: Int32(value.count)) < UInt32.max else {
//		guard value.count < Int(UInt32.max) else {
			// Dictionary is too large to be contained in a MsgPack data
			throw MsgPackError.dataIsTooBig("Dictionary is too big: \(value.count) items")
		}
		
		// Write the header for dictionary
		try self.writeHeader(forDictionary: value.count)
		
		// Let's encode each `{value,key}` inside
		for (k,v) in value {
			try self.pack(k)
			try self.pack(v)
		}
		return self
	}
	
	//MARK: - Helper Functions
	
	
	/// Write the header prefix for each data type
	///
	/// - Parameter type: type to write
	private mutating func writeDataTypeHeader(_ type: MsgPackType) throws {
		var type_value = try type.value()
		self.append( UnsafeBufferPointer(start: &type_value, count: 1) )
	}
	
	
	/// Just a shortcut to append a`data` instance to `self`
	///
	/// - Parameter data: data to add
	private mutating func writeData(_ data: Data) {
		self.append(data)
	}
	
	
	private mutating func writeHeader(forDictionary length: Int) throws {
		// Write header
		try self.writeDataTypeHeader(.dict(items: length))
		
		// Write length if necessary
		if length < 16 {
		} else if length < Int(UInt16.max) {
			var data_len = UInt16(length).bigEndian
			self.append(UnsafeBufferPointer(start: &data_len, count: 1))
		} else { //if length < Int(UInt32.max) {
			var data_len = UInt32(length).bigEndian
			self.append(UnsafeBufferPointer(start: &data_len, count: 1))
		}
	}
	
	/// Write header for 'Array' storage
	///
	/// - Parameter length: number of items in array
	/// - Throws: throw an exception if data is too large
	private mutating func writeHeader(forArray length: Int) throws {
		// Write header
		try self.writeDataTypeHeader(.array(items: length))

		// Write length if necessary
		if length < 16 {
		} else if length < Int(UInt16.max) {
			var data_len = UInt16(length).bigEndian
			self.append(UnsafeBufferPointer(start: &data_len, count: 1))
		} else { //if length < Int(UInt32.max) {
			var data_len = UInt32(length).bigEndian
			self.append(UnsafeBufferPointer(start: &data_len, count: 1))
		}

	}
	
	/// Write prefix for `String` based upon the length of the string itself
	///
	/// - Parameter length: length of the string you want to add
	/// - Throws: throw an exception if data is too large
	private mutating func writeHeader(forString length: Int) throws {
		try self.writeDataTypeHeader(.str(length: length))
		if length < 32 {
			// already written above
		}
		else if length < Int(UInt8.max) {
			var len_data = UInt8(length)
			self.append(UnsafeBufferPointer(start: &len_data, count: 1))
		}
		else if length < Int(UInt16.max) {
			var len_data = UInt16(length).bigEndian
			self.append(UnsafeBufferPointer(start: &len_data, count: 1))
		}
		else { //if length < Int(UInt32.max) {
			var len_data = UInt32(length).bigEndian
			self.append(UnsafeBufferPointer(start: &len_data, count: 1))
		}
	}
	
	
	/// Write prefix for `Data` based upon the length of the `data` itself
	///
	/// - Parameter length: length of data instance you want to write
	/// - Throws: throw an exception if data is too large
	private mutating func writeHeader(forData length: Int) throws {
		// 8 BIT LENGTH
		if length < Int(UInt8.max) {
			try self.writeDataTypeHeader(.bin8)
			
			var data_len = UInt8(length)
			self.append(UnsafeBufferPointer(start: &data_len, count: 1))
		}
			// 16 BIT LENGTH
		else if length < Int(UInt16.max) {
			try self.writeDataTypeHeader(.bin16)
			
			var data_len = UInt16(length).bigEndian
			self.append(UnsafeBufferPointer(start: &data_len, count: 1))
		}
			// 32 BIT LENGTH
		else { // if length < Int(UInt32.max) {
			try self.writeDataTypeHeader(.bin32)
			
			var data_len = UInt32(length).bigEndian
			self.append(UnsafeBufferPointer(start: &data_len, count: 1))
		}
	}
}
