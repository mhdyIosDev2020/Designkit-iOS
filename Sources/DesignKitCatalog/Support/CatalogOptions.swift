//
//  CatalogOptions.swift
//  DesignKitCatalog
//
//  The choices offered by the catalog's pickers. Each option knows its
//  real value and the code that produces it, so the Code section always
//  matches what the preview shows.
//

import SwiftUI
import DesignKit

/// A named value, for lists of examples and picker entries.
struct CatalogOption<Value>: Identifiable {
    let name: String
    let value: Value
    var id: String { name }

    init(_ name: String, _ value: Value) {
        self.name = name
        self.value = value
    }
}

enum ButtonStyleOption: String, CaseIterable, Identifiable {
    case primary, secondary

    var id: Self { self }
    var name: String { rawValue.capitalized }
    var code: String { ".\(rawValue)" }
    var value: SimpleButtonStyle {
        switch self {
        case .primary: return .primary
        case .secondary: return .secondary
        }
    }
}

enum ButtonSizeOption: String, CaseIterable, Identifiable {
    case small, medium, large

    var id: Self { self }
    var name: String { rawValue.capitalized }
    var code: String { ".\(rawValue)" }
    var value: SimpleButtonSize {
        switch self {
        case .small: return .small
        case .medium: return .medium
        case .large: return .large
        }
    }
}

enum RadiusOption: String, CaseIterable, Identifiable {
    case sm, md, lg, pill

    var id: Self { self }
    var name: String { rawValue }
    var code: String { "DKRadius.\(rawValue)" }
    var value: CGFloat {
        switch self {
        case .sm: return DKRadius.sm
        case .md: return DKRadius.md
        case .lg: return DKRadius.lg
        case .pill: return DKRadius.pill
        }
    }
}

enum ColorOption: String, CaseIterable, Identifiable {
    case primary, red, blue, green, darkPink

    var id: Self { self }
    var name: String {
        self == .darkPink ? "Dark pink" : rawValue.capitalized
    }
    var code: String { ".\(rawValue)" }
    var value: Color {
        switch self {
        case .primary: return .primary
        case .red: return .red
        case .blue: return .blue
        case .green: return .green
        case .darkPink: return .darkPink
        }
    }
}
