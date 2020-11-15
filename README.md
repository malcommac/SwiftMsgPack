<p align="center" >
  <img src="https://raw.githubusercontent.com/malcommac/SwiftMsgPack/develop/logo.png" width=210px height=204px alt="SwiftMsgPack" title="SwiftMsgPack">
</p>

[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage) [![CI Status](https://travis-ci.org/malcommac/SwiftMsgPack.svg)](https://travis-ci.org/malcommac/SwiftMsgPack) [![Version](https://img.shields.io/cocoapods/v/SwiftMsgPack.svg?style=flat)](http://cocoadocs.org/docsets/SwiftMsgPack) [![License](https://img.shields.io/cocoapods/l/SwiftMsgPack.svg?style=flat)](http://cocoadocs.org/docsets/SwiftMsgPack) [![Platform](https://img.shields.io/cocoapods/p/SwiftMsgPack.svg?style=flat)](http://cocoadocs.org/docsets/SwiftMsgPack)

<p align="center" >MsgPack for Swift... Its' like JSON <a href="http://theburningmonk.com/2011/12/performance-test-binary-serializers-part-ii/"> but faster</a><br/>
Made with ♥ in pure Swift, no dependencies, lightweight & fully portable
<p/>
<p align="center" >★★ <b>Star our github repository to help us!</b> ★★</p>
<p align="center" >Created by <a href="http://www.danielemargutti.com">Daniele Margutti</a> (<a href="http://www.twitter.com/danielemargutti">@danielemargutti</a>)</p>

[MessagePack](http://msgpack.org/) is an efficient binary serialization format, which lets you exchange data among multiple languages like JSON, except that it's faster and smaller. Small integers are encoded into a single byte while typical short strings require only one extra byte in addition to the strings themselves.
You can read more about [specs directly from the main web](https://github.com/msgpack/msgpack/blob/master/spec.md) site.

## OTHER LIBRARIES YOU MAY LIKE

I'm also working on several other projects you may like.
Take a look below:

<p align="center" >

| Library         | Description                                      |
|-----------------|--------------------------------------------------|
| [**SwiftDate**](https://github.com/malcommac/SwiftDate)       | The best way to manage date/timezones in Swift   |
| [**Hydra**](https://github.com/malcommac/Hydra)           | Write better async code: async/await & promises  |
| [**Flow**](https://github.com/malcommac/Flow) | A new declarative approach to table managment. Forget datasource & delegates. |
| [**SwiftRichString**](https://github.com/malcommac/SwiftRichString) | Elegant & Painless NSAttributedString in Swift   |
| [**SwiftLocation**](https://github.com/malcommac/SwiftLocation)   | Efficient location manager                       |
| [**SwiftMsgPack**](https://github.com/malcommac/SwiftMsgPack)    | Fast/efficient msgPack encoder/decoder           |
</p>

## Index
* **[Current Release](#release)**
* **[How to use](#howto)**
* **[Supported Types](#supportedtypes)**
* **[Installation (CocoaPods, SwiftPM and Carthage)](#installation)**
* **[Tests](#tests)**
* **[Requirements](#requirements)**
* **[Credits](#credits)**

<a name="release" />

## Current Release

* **Swift 4.x**: Latest is 1.0.0 [Download here](https://github.com/malcommac/SwiftMsgPack/releases/tag/1.0.0).
* **Swift 3.x**: Last is 0.9.1 [Download here](https://github.com/malcommac/SwiftMsgPack/releases/tag/0.9.1).

A complete list of changes for each release is available in the [CHANGELOG](CHANGELOG.md) file.

<a name="howto" />

## How to use: one-shot pack & unpack

Both serialization and deseralization happens inside a `Data` object.

In order to pack one or more objects you need to create an empty `Data` instance and call `pack` by passing the object(s) you want to serialize.
It's pretty easy, take a look here:

```swift
var data = Data()
do {
	let obj1 = "Hello World"
	let obj2 = 45.5
	let obj3: [AnyHashable:Any?] = [ "key_1" : "value test","key_2" : 4,"key_3" : true, otherHashableKey: "value1"]
	// Now you can pack your instances by passing them to pack function
	try data.pack(obj1,obj2,obj3)
} catch {
	print("Something went wrong while packing data: \(error)")	
}
```
Deserializing data is pretty simple too, just call `unpack` function to an instance of `Data` with msgpack data:

```swift
let data: Data = // msgpack data...
do {
  let decodedObj: Any? = try data.unpack()
} catch {
	print("Something went wrong while unpacking data: \(error)")	
}
```

<a name="supportedtypes" />

## Supported Types

SwiftMsgPack supports the following Swift types:
- `String`
- `Data`
- `Bool`
- `nil`
- Numeric values: `Int` & `UInt` (`UInt8`,`Int8`,`UInt16`,`Int16`,`UInt32`,`Int32`,`UInt64`,`Int64`), `Float` and `Double`
- `Dictionaries` (`[AnyHashable:Any?]`)
- `Array` (`[Any?]`)

The following limitations are specified by [MsgPack specs format](https://github.com/msgpack/msgpack/blob/master/spec.md#types-limitation):

* a value of an Integer object is limited from `-(2^63)` upto `(2^64)-1`
* maximum length of a Binary object is `(2^32)-1`
* maximum byte size of a String object is `(2^32)-1`
* String objects may contain invalid byte sequence and the behavior of a deserializer depends on the actual implementation when it received invalid byte sequence
    * Deserializers should provide functionality to get the original byte array so that applications can decide how to handle the object
* maximum number of elements of an Array object is `(2^32)-1`
* maximum number of key-value associations of a Map object is `(2^32)-1`

<a name="installation" />

## Installation
You can install Swiftline using CocoaPods, carthage and Swift package manager

### CocoaPods
    use_frameworks!
    pod 'SwiftMsgPack'

### Carthage
    github 'malcommac/SwiftMsgPack'

### Swift Package Manager
Add swiftline as dependency in your `Package.swift`

```
  import PackageDescription

  let package = Package(name: "YourPackage",
    dependencies: [
      .Package(url: "https://github.com/malcommac/SwiftMsgPack.git", majorVersion: 0),
    ]
  )
```

<a name="tests" />

## Tests

SwiftMsgPack has an extensive coverage using XCTest.
You can found a complete list of tests inside `Tests/SwiftMsgPackTests` folder.
Tests can also be runned with XCode using the SwiftMsgPack project.

<a name="requirements" />

## Requirements

Current version is compatible with:

* Swift 4.x+ (Swift 3.x up to 0.9.1)
* iOS 9.0 or later
* tvOS 9.0 or later
* macOS 10.10 or later
* Linux compatible environments

<a name="credits" />

## Credits & License
SwiftMsgPack is owned and maintained by [Daniele Margutti](http://www.danielemargutti.com/).

As open source creation any help is welcome!

The code of this library is licensed under MIT License; you can use it in commercial products without any limitation.

The only requirement is to add a line in your Credits/About section with the text below:

```
This software uses open source SwiftMsgPack's library to manage MsgPack data.
Web: http://github.com/malcommac/SwiftMsgPack.
Created by Daniele Margutti and licensed under MIT License.
```

msgpack.org[SwiftMsgPack]
