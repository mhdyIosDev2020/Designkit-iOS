//
//  CatalogBoxes.swift
//  DesignKitCatalog
//

import SwiftUI
import DesignKit

/// A shaded box that holds a live example of a component.
struct ExampleBox<Content: View>: View {
    let content: Content

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        content
            .padding(DKSpacing.md)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: DKRadius.md)
                    .fill(Color(.secondarySystemBackground))
            )
    }
}

/// An outlined box that holds the controls for changing a component's options.
struct ConfigPanel<Content: View>: View {
    let content: Content

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        VStack(alignment: .leading, spacing: DKSpacing.sm) {
            content
        }
        .padding(DKSpacing.md)
        .frame(maxWidth: .infinity, alignment: .leading)
        .overlay(
            RoundedRectangle(cornerRadius: DKRadius.md)
                .strokeBorder(Color(.separator), lineWidth: 1)
        )
    }
}

/// A slider with its label and current value, for numeric options.
struct LabeledSlider: View {
    let title: String
    @Binding var value: CGFloat
    let range: ClosedRange<CGFloat>
    var step: CGFloat = 1

    var body: some View {
        VStack(alignment: .leading, spacing: DKSpacing.xxs) {
            HStack {
                Text(title)
                Spacer()
                Text(String(format: step < 1 ? "%.2f" : "%.0f", Double(value)))
                    .monospacedDigit()
                    .foregroundColor(.secondary)
            }
            Slider(value: $value, in: range, step: step)
        }
    }
}

/// A short callout for usage tips (info) or known problems (warning).
struct CatalogNote: View {
    let text: String
    var isWarning: Bool = false

    init(_ text: String, isWarning: Bool = false) {
        self.text = text
        self.isWarning = isWarning
    }

    var body: some View {
        HStack(alignment: .top, spacing: DKSpacing.xs) {
            Image(systemName: isWarning ? "exclamationmark.triangle.fill" : "info.circle.fill")
                .foregroundColor(isWarning ? .orange : .blue)
            Text(text)
                .font(.footnote)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(DKSpacing.sm)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: DKRadius.md)
                .fill((isWarning ? Color.orange : Color.blue).opacity(0.1))
        )
    }
}
