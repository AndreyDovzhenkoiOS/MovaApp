// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command
// swiftlint:disable file_length

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name
internal enum L10n {
  /// Search
  internal static let searchPlaceholder = L10n.tr("Localizable", "search_placeholder")
  /// Search Images
  internal static let searchTitle = L10n.tr("Localizable", "search_title")

  internal enum Alert {
    /// Ok
    internal static let action = L10n.tr("Localizable", "alert.action")
    /// Something went wrong
    internal static let message = L10n.tr("Localizable", "alert.message")
    /// Message
    internal static let title = L10n.tr("Localizable", "alert.title")
  }
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name

// MARK: - Implementation Details

extension L10n {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg...) -> String {
    // swiftlint:disable:next nslocalizedstring_key
    let format = NSLocalizedString(key, tableName: table, bundle: Bundle(for: BundleToken.self), comment: "")
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

private final class BundleToken {}
