//
//  ButtonsPage.swift
//  DesignKitCatalog
//

import SwiftUI
import DesignKit

struct ButtonsPage: View {
    @State private var title = "Continue"
    @State private var style = ButtonStyleOption.primary
    @State private var size = ButtonSizeOption.medium
    @State private var radius = RadiusOption.md
    @State private var isLoading = false
    @State private var isDisabled = false

    var body: some View {
        CatalogPage(
            title: "SimpleButton",
            summary: "The standard action button. Choose a style and size, and it handles the loading spinner and disabled state for you."
        ) {
            CatalogSection("Preview") {
                ExampleBox {
                    SimpleButton(
                        isLoading: $isLoading,
                        title: title,
                        style: style.value,
                        size: size.value,
                        cornerRadius: radius.value
                    ) {}
                    .disabled(isDisabled)
                }
            }

            CatalogSection("Configuration") {
                ConfigPanel {
                    TextField("Title", text: $title)
                        .textFieldStyle(.roundedBorder)

                    Text("Style").font(.subheadline).foregroundColor(.secondary)
                    Picker("Style", selection: $style) {
                        ForEach(ButtonStyleOption.allCases) { Text($0.name).tag($0) }
                    }
                    .pickerStyle(.segmented)

                    Text("Size").font(.subheadline).foregroundColor(.secondary)
                    Picker("Size", selection: $size) {
                        ForEach(ButtonSizeOption.allCases) { Text($0.name).tag($0) }
                    }
                    .pickerStyle(.segmented)

                    Text("Corner radius").font(.subheadline).foregroundColor(.secondary)
                    Picker("Corner radius", selection: $radius) {
                        ForEach(RadiusOption.allCases) { Text($0.name).tag($0) }
                    }
                    .pickerStyle(.segmented)

                    Toggle("Loading", isOn: $isLoading)
                    Toggle("Disabled", isOn: $isDisabled)
                }
            }

            CatalogSection("Code") {
                CodeSnippet(code)
            }

            CatalogSection("All styles and sizes") {
                VStack(spacing: DKSpacing.sm) {
                    ForEach(ButtonStyleOption.allCases) { style in
                        ForEach(ButtonSizeOption.allCases) { size in
                            SimpleButton(
                                title: "\(style.name) · \(size.name)",
                                style: style.value,
                                size: size.value
                            ) {}
                        }
                    }
                }
            }

            CatalogNote("Make your own colors with SimpleButtonStyle(background:foreground:loadingBackground:border:).")
        }
    }

    /// Only lists the options that differ from the defaults, the same way
    /// you'd write it in your app.
    private var code: String {
        var arguments: [String] = []
        if isLoading { arguments.append("isLoading: $isLoading") }
        arguments.append("title: \"\(title)\"")
        if style != .primary { arguments.append("style: \(style.code)") }
        if size != .medium { arguments.append("size: \(size.code)") }
        if radius != .md { arguments.append("cornerRadius: \(radius.code)") }

        var code = "SimpleButton(\(arguments.joined(separator: ", "))) {\n    // action\n}"
        if isDisabled { code += "\n.disabled(true)" }
        return code
    }
}

#Preview {
    NavigationView { ButtonsPage() }
}
