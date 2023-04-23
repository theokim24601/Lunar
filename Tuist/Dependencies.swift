import ProjectDescription
import ProjectDescriptionHelpers

let packages: [Package] = [
  Package.Firebase,
  Package.KeychainAccess,
  Package.Realm,
  Package.Scope,
  Package.SnapKit,
  Package.Theodore
]

let dependencies = Dependencies(
  carthage: [],
  swiftPackageManager: .init(
    packages
  ),
  platforms: [.iOS]
)
