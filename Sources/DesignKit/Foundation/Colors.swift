//
//  Colors.swift
//  DesignKit
//
//  Created by Mahdi_iOS on 24/08/23.
//

import SwiftUI
public extension Color {
    static let teal = Color(red: 49 / 255, green: 163 / 255, blue: 159 / 255)
    static let darkPink = Color(red: 208 / 255, green: 45 / 255, blue: 208 / 255)

    /// Defined in ColorAsset.xcassets, with separate light/dark variants —
    /// use this pattern (rather than a fixed `Color(red:green:blue:)`) for
    /// any color that needs to adapt automatically to appearance changes.
    static let mainText = Color("MainTextColor", bundle: .module)
}
