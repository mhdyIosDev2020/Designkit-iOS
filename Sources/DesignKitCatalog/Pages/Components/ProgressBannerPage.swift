//
//  ProgressBannerPage.swift
//  DesignKitCatalog
//

import SwiftUI
import DesignKit

struct ProgressBannerPage: View {
    @State private var isVisible = false
    @State private var title = "Uploading file"
    @State private var message = "This banner closes by itself."
    @State private var duration: CGFloat = 5
    @State private var barColor = ColorOption.red

    var body: some View {
        CatalogPage(
            title: "CustomProgressView",
            summary: "A temporary banner whose bar fills over a set time, then dismisses itself by setting isVisible back to false."
        ) {
            CatalogSection("Preview") {
                ExampleBox {
                    VStack(spacing: DKSpacing.md) {
                        CustomProgressView(
                            isVisible: $isVisible,
                            barColor: barColor.value,
                            timeInterval: TimeInterval(duration),
                            title: title,
                            description: message
                        )
                        .background(
                            RoundedRectangle(cornerRadius: DKRadius.md)
                                .fill(Color(.systemBackground))
                        )

                        SimpleButton(
                            title: isVisible ? "Showing…" : "Show banner",
                            style: .secondary,
                            size: .small
                        ) {
                            isVisible = true
                        }
                        .disabled(isVisible)
                    }
                    .frame(minHeight: 140, alignment: .top)
                }
            }

            CatalogSection("Configuration") {
                ConfigPanel {
                    TextField("Title", text: $title)
                        .textFieldStyle(.roundedBorder)
                    TextField("Description", text: $message)
                        .textFieldStyle(.roundedBorder)
                    LabeledSlider(title: "Duration (seconds)", value: $duration, range: 1...10)
                    HStack {
                        Text("Bar color")
                        Spacer()
                        Picker("Bar color", selection: $barColor) {
                            ForEach(ColorOption.allCases) { Text($0.name).tag($0) }
                        }
                        .pickerStyle(.menu)
                    }
                }
            }

            CatalogSection("Code") {
                CodeSnippet("""
                CustomProgressView(
                    isVisible: $isBannerVisible,
                    barColor: \(barColor.code),
                    timeInterval: \(Int(duration)),
                    title: "\(title)",
                    description: "\(message)"
                )
                """)
            }

            CatalogNote("Leave the description empty to show only the title.")
        }
    }
}

#Preview {
    NavigationView { ProgressBannerPage() }
}
