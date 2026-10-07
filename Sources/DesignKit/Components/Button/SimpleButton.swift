//
//  SimpleButton.swift
//  DesignKit
//
//  Created by Mahdi_iOS on 27/08/23.
//

import SwiftUI

public struct SimpleButton: View {
    public var title: String
    @Binding public var isLoading: Bool
    public var style: SimpleButtonStyle
    public var size: SimpleButtonSize
    public var cornerRadius: CGFloat
    public let action: () -> Void

    /// Picks up `.disabled(true)` set from outside, so the button dims.
    @Environment(\.isEnabled) private var isEnabled

    /// The existing call `SimpleButton(title:action:)` keeps working and
    /// looks the same as before — every new parameter has a default.
    public init(
        isLoading: Binding<Bool> = .constant(false),
        title: String,
        style: SimpleButtonStyle = .primary,
        size: SimpleButtonSize = .medium,
        cornerRadius: CGFloat = DKRadius.md,
        action: @escaping () -> Void
    ) {
        self._isLoading = isLoading
        self.title = title
        self.style = style
        self.size = size
        self.cornerRadius = cornerRadius
        self.action = action
    }

    public var body: some View {
        Button(action: action) {
            ZStack {
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(isLoading ? style.loadingBackground : style.background)

                if let border = style.border {
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .strokeBorder(border, lineWidth: 1)
                }

                if isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: style.foreground))
                } else {
                    Text(title)
                        .font(size.font)
                        .foregroundColor(style.foreground)
                        .padding(.horizontal, DKSpacing.md)
                }
            }
            .frame(height: size.height)
            .contentShape(RoundedRectangle(cornerRadius: cornerRadius))
        }
        .buttonStyle(.plain)
        .opacity(isEnabled ? 1 : 0.5)
        .disabled(isLoading)
        .accessibilityLabel(isLoading ? "\(title), loading" : title)
    }
}

struct SimpleButton_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: DKSpacing.md) {
            SimpleButton(title: "Login") {}
            SimpleButton(title: "Create account", style: .secondary) {}
            SimpleButton(isLoading: .constant(true), title: "Loading") {}
            SimpleButton(title: "Small", size: .small) {}
            SimpleButton(title: "Large", size: .large, cornerRadius: DKRadius.pill) {}
            SimpleButton(title: "Disabled") {}
                .disabled(true)
        }
        .padding(DKSpacing.md)
    }
}
