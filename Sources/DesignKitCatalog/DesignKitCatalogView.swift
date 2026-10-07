//
//  DesignKitCatalogView.swift
//  DesignKitCatalog
//

import SwiftUI
import DesignKit

/// A browsable guide to everything in DesignKit: every foundation value
/// and component, with a live preview, controls for each option, and
/// copyable code that matches what you see.
///
/// Browse it in Xcode's preview canvas (live mode), or show it from a
/// debug menu in your app:
///
///     import DesignKitCatalog
///     DesignKitCatalogView()
public struct DesignKitCatalogView: View {
    public init() {}

    public var body: some View {
        NavigationView {
            List {
                Section(header: Text("Foundation")) {
                    row("Colors", icon: "paintpalette", subtitle: "Brand and adaptive colors") { ColorsPage() }
                    row("Typography", icon: "textformat", subtitle: "Lato, Manrope, Roboto") { TypographyPage() }
                    row("Spacing", icon: "arrow.left.and.right", subtitle: "DKSpacing scale") { SpacingPage() }
                    row("Corner radius", icon: "square", subtitle: "DKRadius scale") { RadiusPage() }
                    row("Icons", icon: "star.square", subtitle: "DesignKitIcons") { IconsPage() }
                }

                Section(header: Text("Components")) {
                    row("SimpleButton", icon: "rectangle.fill", subtitle: "Styles, sizes, loading") { ButtonsPage() }
                    row("TextEntryView", icon: "character.cursor.ibeam", subtitle: "Form fields and validation") { TextEntryPage() }
                    row("BannerPagingView", icon: "rectangle.split.3x1", subtitle: "Swipeable carousel") { BannerPagingPage() }
                    row("CardStackView", icon: "rectangle.stack", subtitle: "Swipe-through card deck") { CardStackPage() }
                    row("PageControl", icon: "ellipsis", subtitle: "Page indicator dots") { PageControlPage() }
                    row("CustomProgressView", icon: "timer", subtitle: "Self-dismissing banner") { ProgressBannerPage() }
                }
            }
            .listStyle(.insetGrouped)
            .navigationTitle("DesignKit")
        }
        .navigationViewStyle(.stack)
    }

    private func row<Destination: View>(
        _ title: String,
        icon: String,
        subtitle: String,
        @ViewBuilder destination: () -> Destination
    ) -> some View {
        NavigationLink(destination: destination()) {
            HStack(spacing: DKSpacing.sm) {
                Image(systemName: icon)
                    .foregroundColor(.accentColor)
                    .frame(width: 28)
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                    Text(subtitle)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            .padding(.vertical, DKSpacing.xxs)
        }
    }
}

#Preview {
    DesignKitCatalogView()
}
