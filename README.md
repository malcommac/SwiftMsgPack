<p align="center" >
  <img src="banner.png" width=300px alt="SwiftLocation" title="SwiftLocation">
</p>

<p align="center"><strong>It's like JSON, but faster!</strong></p>


[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage) [![CI Status](https://travis-ci.org/malcommac/SwiftMsgPack.svg)](https://travis-ci.org/malcommac/SwiftMsgPack) [![Version](https://img.shields.io/cocoapods/v/SwiftMsgPack.svg?style=flat)](http://cocoadocs.org/docsets/SwiftMsgPack) [![License](https://img.shields.io/cocoapods/l/SwiftMsgPack.svg?style=flat)](http://cocoadocs.org/docsets/SwiftMsgPack) [![Platform](https://img.shields.io/cocoapods/p/SwiftMsgPack.svg?style=flat)](http://cocoadocs.org/docsets/SwiftMsgPack)

## What's this?

[MessagePack](http://msgpack.org/) is an efficient binary serialization format, which lets you exchange data among multiple languages like JSON, except that it's [faster and smaller](http://theburningmonk.com/2011/12/performance-test-binary-serializers-part-ii). Small integers are encoded into a single byte while typical short strings require only one extra byte in addition to the strings themselves.  
You can read more about [specs directly from the main web](https://github.com/msgpack/msgpack/blob/master/spec.md) site.  
Moreover it's made in pure Swift, no dependencies, lightweight & fully portable

## Your Support

*Hi fellow developer!*  
You know, maintaing and developing tools consumes resources and time. While I enjoy making them **your support is foundamental to allow me continue its development**.  

If you are using SwiftLocation or any other of my creations please consider the following options:

- [**Make a donation with PayPal**](https://www.paypal.com/paypalme/danielemargutti/20)
- [**Become a Sponsor**](https://github.com/sponsors/malcommac)

- [⭐️ Follow Me & Discover Other Projects](https://github.com/malcommac)

## Index
* **[How to use](#howto)**
* **[Supported Types](#supportedtypes)**
* **[Installation (CocoaPods, SwiftPM and Carthage)](#installation)**
* **[Tests](#tests)**

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

<a name="credits" />

## Contributing

- If you **need help** or you'd like to **ask a general question**, open an issue.
- If you **found a bug**, open an issue.
- If you **have a feature request**, open an issue.
- If you **want to contribute**, submit a pull request.

## Copyright & Acknowledgements

SwiftLocation is currently owned and maintained by Daniele Margutti.  
You can follow me on Twitter [@danielemargutti](http://twitter.com/danielemargutti).  
My web site is [https://www.danielemargutti.com](https://www.danielemargutti.com) 

This software is licensed under [MIT License](LICENSE.md).

***Follow me on:***  
- 💼 [Linkedin](https://www.linkedin.com/in/danielemargutti/)  
- 🐦 [Twitter](https://twitter.com/danielemargutti)
