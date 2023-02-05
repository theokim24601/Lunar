import ProjectDescription

public extension Package {
  static let Firebase = remote(
    url: "https://github.com/firebase/firebase-ios-sdk.git",
    requirement: .upToNextMajor(from: "10.4.0")
  )
  static let KeychainAccess = remote(
    url: "https://github.com/kishikawakatsumi/KeychainAccess",
    requirement: .upToNextMajor(from: "4.2.2")
  )
  static let Realm = remote(
    url: "https://github.com/realm/realm-swift.git",
    requirement: .upToNextMajor(from: "10.34.1")
  )
  static let Scope = remote(
    url: "https://github.com/hb1love/Scope.git",
    requirement: .upToNextMajor(from: "2.1.1")
  )
  static let SnapKit = remote(
    url: "https://github.com/SnapKit/SnapKit.git",
    requirement: .upToNextMajor(from: "5.6.0")
  )
}
