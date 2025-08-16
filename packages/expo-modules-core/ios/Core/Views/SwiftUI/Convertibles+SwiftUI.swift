// Copyright 2024-present 650 Industries. All rights reserved.

import SwiftUI
import OSLog

extension Color: Convertible {
  public static func convert(from value: Any?, appContext: AppContext) throws -> Color {
    // Simply reuse the logic from UIColor
    if let uiColor = try? UIColor.convert(from: value, appContext: appContext) {
      return Color(uiColor)
    }
    // Context-dependent colors
    if let stringValue = value as? String, let color = colorFromName(stringValue) {
      return color
    }
    throw Conversions.ConvertingException<Color>(value)
  }

  private static func colorFromName(_ name: String) -> Color? {
    switch name {
    case "primary":
      return .primary
    case "secondary":
      return .secondary
    case "red":
      return .red
    case "orange":
      return .orange
    case "yellow":
      return .yellow
    case "green":
      return .green
    case "blue":
      return .blue
    case "purple":
      return .purple
    case "pink":
      return .pink
    case "white":
      return .white
    case "gray":
      return .gray
    case "black":
      return .black
    case "clear":
      return .clear
    case "mint":
      if #available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *) {
        return .mint
      }
      return nil
    case "teal":
      if #available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *) {
        return .teal
      }
      return nil
    case "cyan":
      if #available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *) {
        return .cyan
      }
      return nil
    case "indigo":
      if #available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *) {
        return .indigo
      }
      return nil
    case "brown":
      if #available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *) {
        return .brown
      }
      return nil
    default:
      return nil
    }
  }

  #if os(tvOS)
  private static let _systemGray6: Color = Color(.systemGray.withAlphaComponent(0.5))
  private static let _systemGray5: Color = Color(.systemGray.withAlphaComponent(0.6))
  private static let _systemGray4: Color = Color(.systemGray.withAlphaComponent(0.7))
  private static let _systemBackground: Color = .clear
  private static let _systemGroupedBackground: Color = .white
  private static let _secondaryLabel: Color = .secondary
  private static let _secondarySystemBackground: Color = Color(.systemGray.withAlphaComponent(0.1))
  private static let _secondarySystemGroupedBackground: Color = Color(.systemGray.withAlphaComponent(0.2))
  #else
  private static let _systemGray6: Color = Color(.systemGray6)
  private static let _systemGray5: Color = Color(.systemGray5)
  private static let _systemGray4 = Color(.systemGray4)
  private static let _systemBackground: Color = Color(.systemBackground)
  private static let _systemGroupedBackground: Color = Color(.systemGroupedBackground)
  private static let _secondaryLabel: Color = Color(.secondaryLabel)
  private static let _secondarySystemBackground: Color = Color(.secondarySystemBackground)
  private static let _secondarySystemGroupedBackground: Color = ._secondarySystemGroupedBackground
  #endif

// swiftlint:disable:next type_name
  public enum expoSystemColors {
    case systemBackground
    case systemGroupedBackground
    case secondaryLabel
    case secondarySystemBackground
    case secondarySystemGroupedBackground
    case systemGray4
    case systemGray5
    case systemGray6

    public var color: Color {
      switch self {
      case .secondaryLabel:
        return _secondaryLabel
      case .secondarySystemBackground:
        return _secondarySystemBackground
      case .secondarySystemGroupedBackground:
        return _secondarySystemGroupedBackground
      case .systemBackground:
        return _systemBackground
      case .systemGroupedBackground:
        return _systemGroupedBackground
      case .systemGray4:
        return _systemGray4
      case .systemGray5:
        return _systemGray5
      case .systemGray6:
        return _systemGray6
      }
    }
  }
}

extension UnitPoint: Convertible {
  public static func convert(from value: Any?, appContext: AppContext) throws -> UnitPoint {
    // Simply reuse the logic from CGPoint
    if let cgPoint = try? CGPoint.convert(from: value, appContext: appContext) {
      return UnitPoint(x: cgPoint.x, y: cgPoint.y)
    }
    throw Conversions.ConvertingException<UnitPoint>(value)
  }
}
