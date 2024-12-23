// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "FSPagerView-SPM",
    platforms: [
        .iOS(.v15) // 필요한 최소 iOS 버전 설정
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "FSPagerView-SPM",
            targets: ["FSPagerViewSwift"]),
    ],
    targets: [
        // Objective-C 타겟
        .target(
            name: "FSPagerViewObjC",
            path: "Sources/FSPagerViewObjC",
            publicHeadersPath: "."
        ),
        // Swift 타겟
        .target(
            name: "FSPagerViewSwift",
            dependencies: ["FSPagerViewObjC"],
            path: "Sources/FSPagerViewSwift"
        )
    ]
)
