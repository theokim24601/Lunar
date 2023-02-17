import ProjectDescription

// MARK: - Project
public extension Project {
  static let platform = Platform.iOS
  static let orgName = "theo"
  static let domainName = "kim.\(orgName)"
  static let deploymentTarget = DeploymentTarget.iOS(targetVersion: "15.0", devices: [.iphone])

  static func app(
    name: String,
    product: Product,
    packages: [Package] = [],
    dependencies: [TargetDependency] = []
  ) -> Project {
    return Project(
      name: name,
      organizationName: orgName,
      packages: packages,
      settings: .settings(
        base: .init()
          .swiftVersion("5.4")
          .setStripDebugSymbolsDuringCopy("NO")
          .setExcludedArchitectures(),
        configurations: [
          .debug(
            name: .debug,
            settings: .init()
              .setBuildActiveArchitectureOnly(true)
          ),
          .release(
            name: .release,
            settings: .init()
              .setBuildActiveArchitectureOnly(false)
          )
        ],
        defaultSettings: .recommended
      ),
      targets: [
        .appTarget(name: name, platform: platform, domainName: domainName, deploymentTarget: deploymentTarget, dependencies: dependencies),
        .testTarget(name: name, platform: platform, domainName: domainName, deploymentTarget: deploymentTarget)
      ],
      schemes: [
        .makeScheme(name: name)
      ]
    )
  }

  static func framework(
    name: String,
    product: Product = .framework,
    packages: [Package] = [],
    sources: SourceFilesList = ["Sources/**"],
    resources: ResourceFileElements? = nil,
    dependencies: [TargetDependency] = []
  ) -> Project {
    return Project(
      name: name,
      organizationName: orgName,
      packages: packages,
      settings: .settings(
        base: .init()
          .swiftVersion("5.4")
          .setExcludedArchitectures(),
        debug: .init()
          .setBuildActiveArchitectureOnly(true),
        release: .init()
          .setBuildActiveArchitectureOnly(false),
        defaultSettings: .none
      ),
      targets: [
        .frameworkTarget(name: name, platform: platform, product: product, domainName: domainName, deploymentTarget: deploymentTarget, sources: sources, resources: resources, dependencies: dependencies),
        .testTarget(name: name, platform: platform, domainName: domainName, deploymentTarget: deploymentTarget),
      ],
      schemes: [.makeScheme(name: name)]
    )
  }
}

// MARK: - Target
extension Target {
  static func appTarget(
    name: String,
    platform: Platform,
    domainName: String,
    deploymentTarget: DeploymentTarget,
    dependencies: [TargetDependency] = []
  ) -> Target {
    return Target(
      name: name,
      platform: platform,
      product: .app,
      bundleId: "\(domainName).\(name.lowercased())",
      deploymentTarget: deploymentTarget,
      infoPlist: .extendingDefault(with: [
        "CFBundleShortVersionString": "2.0.0",
        "CFBundleVersion": "2",
        "UIMainStoryboardFile": "",
        "UILaunchStoryboardName": "Launch",
        "ITSAppUsesNonExemptEncryption": false,
        "UIApplicationSceneManifest": [
          "UIApplicationSupportsMultipleScenes": false,
          "UISceneConfigurations": [
            "UIWindowSceneSessionRoleApplication": [
              [
                "UISceneConfigurationName": "Default Configuration",
                "UISceneDelegateClassName": "$(PRODUCT_MODULE_NAME).SceneDelegate"
              ]
            ]
          ]
        ],
        "UISupportedInterfaceOrientations": [
          "UIInterfaceOrientationPortrait"
        ],
        "UIUserInterfaceStyle": "Light",
        "NSCalendarsUsageDescription": "기본 캘린더에 일정 등록을 위해 접근 권한이 필요합니다.",
        "UIAppFonts": [
          "SpoqaHanSansNeo-Bold.otf",
          "SpoqaHanSansNeo-Light.otf",
          "SpoqaHanSansNeo-Medium.otf",
          "SpoqaHanSansNeo-Regular.otf"
        ],
        "LSApplicationCategoryType": "public.app-category.utilities",
        "UIViewControllerBasedStatusBarAppearance": true
      ]),
      sources: ["Sources/**"],
      resources: [
        "Resources/**",
        "../../config/lunar/GoogleService-Info.plist"
      ],
//      scripts: [.SwiftLintString],
      dependencies: dependencies
    )
  }

  static func frameworkTarget(
    name: String,
    platform: Platform,
    product: Product,
    domainName: String,
    deploymentTarget: DeploymentTarget,
    sources: SourceFilesList,
    resources: ResourceFileElements?,
    dependencies: [TargetDependency] = []
  ) -> Target {
    return Target(
      name: name,
      platform: platform,
      product: product,
      bundleId: "\(domainName).\(name.lowercased())",
      deploymentTarget: deploymentTarget,
      infoPlist: .default,
      sources: sources,
      resources: resources,
      dependencies: dependencies,
      settings: .settings(
        base: .init()
          .setSkipInstall(true),
        debug: .init(),
        release: .init(),
        defaultSettings: .none
      )
    )
  }

  static func testTarget(
    name: String,
    platform: Platform,
    domainName: String,
    deploymentTarget: DeploymentTarget
  ) -> Target {
    return Target(
      name: "\(name)Tests",
      platform: platform,
      product: .unitTests,
      bundleId: "\(domainName).\(name.lowercased())Tests",
      deploymentTarget: deploymentTarget,
      infoPlist: .default,
      sources: ["Tests/**"],
      dependencies: [.target(name: name)]
    )
  }
}

// MARK: - Scheme
extension Scheme {
  static func makeScheme(name: String) -> Scheme {
    return Scheme(
      name: name,
      shared: true,
      buildAction: .buildAction(targets: ["\(name)"]),
      testAction: .targets(
        ["\(name)Tests"],
        configuration: .debug,
        options: .options(coverage: true, codeCoverageTargets: ["\(name)"])
      ),
      runAction: .runAction(configuration: .debug),
      archiveAction: .archiveAction(configuration: .release),
      profileAction: .profileAction(configuration: .release),
      analyzeAction: .analyzeAction(configuration: .debug)
    )
  }
}

// MARK: - Settings
extension Settings {
  static func targetSettings() -> Settings {
    return Settings.settings(
      base: .init()
        .swiftVersion("5.4"),
      debug: .init()
        .setBuildActiveArchitectureOnly(true),
      release: .init()
        .setBuildActiveArchitectureOnly(false),
      defaultSettings: .none
    )
  }
}

// MARK: - Extension Setting Dictionary
extension SettingsDictionary {
  func setAssetcatalogCompilerAppIconName(_ value: String = "AppIcon$(BUNDLE_ID_SUFFIX)") -> SettingsDictionary {
    merging(["ASSETCATALOG_COMPILER_APPICON_NAME": SettingValue(stringLiteral: value)])
  }

  func setBuildActiveArchitectureOnly(_ value: Bool) -> SettingsDictionary {
    merging(["ONLY_ACTIVE_ARCH": SettingValue(stringLiteral: value ? "YES" : "NO")])
  }

  func setExcludedArchitectures(sdk: String = "iphonesimulator*", _ value: String = "x86_64") -> SettingsDictionary {
    merging(["EXCLUDED_ARCHS[sdk=\(sdk)]": SettingValue(stringLiteral: value)])
  }

  func setSwiftActiveComplationConditions(_ value: String) -> SettingsDictionary {
    merging(["SWIFT_ACTIVE_COMPILATION_CONDITIONS": SettingValue(stringLiteral: value)])
  }

  func setStripDebugSymbolsDuringCopy(_ value: String = "NO") -> SettingsDictionary {
    merging(["COPY_PHASE_STRIP": SettingValue(stringLiteral: value)])
  }

  func setDynamicLibraryInstallNameBase(_ value: String = "@rpath") -> SettingsDictionary {
    merging(["DYLIB_INSTALL_NAME_BASE": SettingValue(stringLiteral: value)])
  }

  func setSkipInstall(_ value: Bool = false) -> SettingsDictionary {
    merging(["SKIP_INSTALL": SettingValue(stringLiteral: value ? "YES" : "NO")])
  }
}
