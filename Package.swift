// swift-tools-version:5.3
import PackageDescription

let package = Package(
    name: "SwiftMsgPack",
    products: [
        .library(name: "SwiftMsgPack", targets: ["SwiftMsgPack"])
    ],
    targets: [
        .target(name: "SwiftMsgPack"),
        .testTarget(
            name: "SwiftMsgPackTests",
            dependencies: ["SwiftMsgPack"]
        ),
    ]
)
