import ProjectDescription

let project = Project(
    name: "EDICC",
    packages: [
        .remote(
            url: "https://github.com/SnapKit/SnapKit.git",
            requirement: .upToNextMajor(from: "5.7.1")
        ),
        .remote(
            url: "https://github.com/pointfreeco/swift-composable-architecture.git",
            requirement: .upToNextMajor(from: "1.23.1")
        )
        ],
    targets: [
        .target(
            name: "EDICC",
            destinations: .iOS,
            product: .app,
            bundleId: "io.tuist.EDICC",
            deploymentTargets: .iOS("18.5"),
            infoPlist: .extendingDefault(
                with: [
                    "UILaunchScreen": [
                        "UIColorName": "",
                        "UIImageName": "",
                    ],
                    "UIObservationTrackingEnabled" : "YES"
                ]
            ),
            sources: ["EDICC/Sources/**"],
            resources: ["EDICC/Resources/**"],
            dependencies: [
                .package(product: "SnapKit"),
                .package(product: "ComposableArchitecture")
            ],
            settings: .settings(
                base: [
                    "DEVELOPMENT_TEAM": "MAU8HFALP8"
                ]
            )
        ),
        .target(
            name: "EDICCTests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "io.tuist.EDICCTests",
            deploymentTargets: .iOS("18.5"),
            infoPlist: .default,
            sources: ["EDICC/Tests/**"],
            resources: [],
            dependencies: [.target(name: "EDICC")]
        ),
    ]
)
