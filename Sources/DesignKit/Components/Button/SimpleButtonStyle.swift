//
//  SimpleButtonStyle.swift
//  DesignKit
//

import SwiftUI

/// Colors for a `SimpleButton`. Use one of the presets, or make your own.
public struct SimpleButtonStyle {
    public var background: Color
    public var foreground: Color
    public var loadingBackground: Color
    /// Drawn as a 1pt outline when set (used by `.secondary`).
    public var border: Color?

    public init(
        background: Color,
        foreground: Color,
        loadingBackground: Color = .gray,
        border: Color? = nil
    ) {
        self.background = background
        self.foreground = foreground
        self.loadingBackground = loadingBackground
        self.border = border
    }

    /// Filled button — the main action on a screen. Same look as the
    /// original `SimpleButton`, so existing screens don't change.
    public static let primary = SimpleButtonStyle(background: .red, foreground: .white)

    /// Outlined button — a less important action next to a primary one.
    public static let secondary = SimpleButtonStyle(
        background: .clear,
        foreground: .red,
        loadingBackground: .gray.opacity(0.2),
        border: .red
    )
}
