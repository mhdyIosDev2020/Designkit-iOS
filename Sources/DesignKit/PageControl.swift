//
//  PageControl.swift
//  DesignKit
//

import SwiftUI

/// A row of dots indicating position among a fixed number of pages. The
/// active dot grows into a pill and cross-fades to `activeColor` — smoothly,
/// via `dragProgress`, as a drag is happening (feed it `CardStackView`'s
/// `onDragProgress` or `BannerPagingView`'s equivalent), and via a spring
/// when `currentPage` changes on its own (e.g. set programmatically, with
/// no accompanying drag). Purely presentational: it doesn't drive paging
/// itself, it just reflects it.
public struct PageControl: View {
    public let numberOfPages: Int
    public let currentPage: Int
    /// -1...1: how far a drag has progressed toward the previous/next page.
    /// 0 (the default) means "not dragging" — the active dot just sits at
    /// `currentPage` as normal.
    public let dragProgress: CGFloat
    public let activeColor: Color
    public let inactiveColor: Color
    public let dotSize: CGFloat
    public let spacing: CGFloat

    public init(
        numberOfPages: Int,
        currentPage: Int,
        dragProgress: CGFloat = 0,
        activeColor: Color = .primary,
        inactiveColor: Color = .secondary.opacity(0.3),
        dotSize: CGFloat = 8,
        spacing: CGFloat = 8
    ) {
        self.numberOfPages = numberOfPages
        self.currentPage = currentPage
        self.dragProgress = dragProgress
        self.activeColor = activeColor
        self.inactiveColor = inactiveColor
        self.dotSize = dotSize
        self.spacing = spacing
    }

    public var body: some View {
        HStack(spacing: spacing) {
            ForEach(0..<numberOfPages, id: \.self) { index in
                let activeness = activeness(forDotAt: index)
                ZStack {
                    Capsule().fill(inactiveColor)
                    Capsule().fill(activeColor).opacity(activeness)
                }
                .frame(width: dotSize + dotSize * 1.5 * activeness, height: dotSize)
            }
        }
        // Scoped to currentPage only, not dragProgress: dragProgress already
        // tracks the live gesture 1:1 (see activeness(forDotAt:)) and would
        // just lag behind the finger if this animation applied to it too.
        // currentPage changing independent of a drag (set programmatically)
        // still gets a smooth spring instead of a hard cut.
        .animation(.spring(response: 0.35, dampingFraction: 0.7), value: currentPage)
    }

    /// 0...1 — how "active" (sized/colored) a dot should render right now.
    /// At dragProgress 0 this is just "1 for currentPage, 0 elsewhere." As
    /// dragProgress moves toward ±1, currentPage's activeness fades out
    /// while whichever neighbor it's heading toward fades in by the same
    /// amount — always summing to 1 between the two, so the transition
    /// reads as one dot handing off to the next rather than two independent
    /// fades that could overlap or gap.
    private func activeness(forDotAt index: Int) -> CGFloat {
        let progress = min(max(abs(dragProgress), 0), 1)
        let direction = dragProgress > 0 ? 1 : (dragProgress < 0 ? -1 : 0)
        let target = min(max(currentPage + direction, 0), numberOfPages - 1)

        if target == currentPage {
            return index == currentPage ? 1 : 0
        }
        if index == currentPage {
            return 1 - progress
        }
        if index == target {
            return progress
        }
        return 0
    }
}

#Preview {
    struct PreviewHost: View {
        @State private var frontIndex = 2
        @State private var dragProgress: CGFloat = 0

        func bankCard(last4: String, gradient: [Color]) -> some View {
            ZStack(alignment: .bottomLeading) {
                LinearGradient(colors: gradient, startPoint: .topLeading, endPoint: .bottomTrailing)
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
            .frame(width: 300, height: 180)
            .cornerRadius(12)
        }

        var body: some View {
            VStack(spacing: 50) {
                CardStackView(
                    items: [
                        bankCard(last4: "4821", gradient: [.blue, .purple]),
                        bankCard(last4: "9027", gradient: [.orange, .red]),
                        bankCard(last4: "1193", gradient: [.green, .teal]),
                    ],
                    onFrontChange: { frontIndex = $0 },
                    onDragProgress: { dragProgress = $0 }
                )
                .frame(width: 300, height: 180)

                PageControl(numberOfPages: 3, currentPage: frontIndex, dragProgress: dragProgress)
            }
        }
    }

    return PreviewHost()
}
