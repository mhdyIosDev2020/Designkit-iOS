//
//  SimpleButtonSize.swift
//  DesignKit
//

import SwiftUI

/// Height and font for a `SimpleButton`.
public enum SimpleButtonSize {
    case small
    case medium
    case large

    var height: CGFloat {
        switch self {
        case .small: return 32
        case .medium: return 40
        case .large: return 48
        }
    }

    var font: Font {
        switch self {
        case .small: return .subheadline
        case .medium: return .body
        case .large: return .headline
        }
    }
}
