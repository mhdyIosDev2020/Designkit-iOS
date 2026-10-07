//
//  CodeSnippet.swift
//  DesignKitCatalog
//

import SwiftUI
import UIKit
import DesignKit

/// Monospaced, selectable code with a Copy button.
struct CodeSnippet: View {
    let code: String
    @State private var didCopy = false

    init(_ code: String) {
        self.code = code
    }

    var body: some View {
        ZStack(alignment: .topTrailing) {
            ScrollView(.horizontal, showsIndicators: false) {
                Text(verbatim: code)
                    .font(.system(.footnote, design: .monospaced))
                    .textSelection(.enabled)
                    .padding(DKSpacing.sm)
                    .padding(.trailing, 56)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: DKRadius.md)
                    .fill(Color(.tertiarySystemFill))
            )

            Button {
                UIPasteboard.general.string = code
                didCopy = true
            } label: {
                Text(didCopy ? "Copied" : "Copy")
                    .font(.caption.weight(.semibold))
            }
            .padding(DKSpacing.xs)
        }
        .onChange(of: code) { _ in didCopy = false }
    }
}
