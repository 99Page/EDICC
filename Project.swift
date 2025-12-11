import ProjectDescription

let project = Project(
    name: "EDICC",
    targets: [
        .target(
            name: "EDICC",
            destinations: .iOS,
            product: .app,
            bundleId: "io.tuist.EDICC",
            deploymentTargets: .iOS("18.0"),
            infoPlist: .extendingDefault(
                with: [
                    "UILaunchScreen": [
                        "UIColorName": "",
                        "UIImageName": "",
                    ],
                ]
            ),
            sources: ["EDICC/Sources/**"],
            resources: ["EDICC/Resources/**"],
            dependencies: []
        ),
        .target(
            name: "EDICCTests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "io.tuist.EDICCTests",
            deploymentTargets: .iOS("18.0"),
            infoPlist: .default,
            sources: ["EDICC/Tests/**"],
            resources: [],
            dependencies: [.target(name: "EDICC")]
        ),
    ]
)
