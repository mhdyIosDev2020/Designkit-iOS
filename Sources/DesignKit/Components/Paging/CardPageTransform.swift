//
//  CardPageTransform.swift
//  DesignKit
//

import SwiftUI

/// Per-card visual state as a function of distance from the current page
/// (0 = current card, 1 = next, -1 = previous, ...). Swap the `transform`
/// closure passed to `BannerPagingView` to change the animation style later
/// (e.g. a Wallet-style scale/fan) without touching the drag/snap engine.
public struct CardPageTransform {
    public var scale: CGFloat
    public var opacity: Double
    public var rotation: Angle

    public init(scale: CGFloat = 1, opacity: Double = 1, rotation: Angle = .zero) {
        self.scale = scale
        self.opacity = opacity
        self.rotation = rotation
    }

    /// No change — every card looks the same regardless of position. The default.
    public static let identity = CardPageTransform()
}
