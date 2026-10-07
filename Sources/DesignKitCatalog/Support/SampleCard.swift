//
//  SampleCard.swift
//  DesignKitCatalog
//

import SwiftUI

/// Placeholder bank-card content for the paging and stack examples.
struct SampleCard: View {
    let last4: String
    let colors: [Color]

    var body: some View {
        ZStack(alignment: .bottomLeading) {
            LinearGradient(colors: colors, startPoint: .topLeading, endPoint: .bottomTrailing)
            VStack(alignment: .leading, spacing: 8) {
                Spacer()
                Text("•••• •••• •••• \(last4)")
                    .font(.system(.title3, design: .monospaced))
                Text("VALID THRU 12/29")
                    .font(.caption)
            }
            .foregroundColor(.white)
            .padding()
        }
        .frame(maxWidth: .infinity)
        .frame(height: 170)
    }

    static let examples: [SampleCard] = [
        SampleCard(last4: "4821", colors: [.blue, .purple]),
        SampleCard(last4: "9027", colors: [.orange, .red]),
        SampleCard(last4: "1193", colors: [.green, .mint]),
    ]
}
