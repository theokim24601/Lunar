import ProjectDescription

public extension TargetDependency {
  enum SPM {}
}

public extension TargetDependency.SPM {
  static let FirebaseAnalytics = TargetDependency.package(product: "FirebaseAnalytics")
  static let FirebaseCrashlytics = TargetDependency.package(product: "FirebaseCrashlytics")
  static let KeychainAccess = TargetDependency.package(product: "KeychainAccess")
  static let Realm = TargetDependency.package(product: "RealmSwift")
  static let Scope = TargetDependency.package(product: "Scope")
  static let SnapKit = TargetDependency.package(product: "SnapKit")
  static let TheodoreCore = TargetDependency.package(product: "TheodoreCore")
  static let TheodoreUI = TargetDependency.package(product: "TheodoreUI")
}
