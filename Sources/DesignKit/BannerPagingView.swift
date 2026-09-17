//
//  BannerPagingView.swift
//  DesignKit
//
//  Created by Mahdi_ios on 1405/6/26.
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

/// A horizontally swipeable, paging card carousel with injected views — no
/// ScrollView, no iOS 17 scroll-target APIs, works back to iOS 15.
///
/// The view doesn't constrain its own size — size it from outside
/// (`.frame(width:height:)`) to control how much of the next card peeks in.
public struct BannerPagingView<Content: View>: View {
    public let items: [Content]
    public let itemWidth: CGFloat
    public let itemSpacing: CGFloat
    public let cornerRadius: CGFloat
    public let transform: (_ pageOffset: Int) -> CardPageTransform
    public let onPageChange: ((Int) -> Void)?

    @State private var currentPage: Int
    // Plain @State, not @GestureState — @GestureState resets to 0 in its own,
    // separate transaction when the gesture ends, which raced against the
    // withAnimation below (two uncoordinated animations feeding one offset).
    // Resetting this manually inside the same withAnimation block fixes that.
    @State private var dragTranslation: CGFloat = 0

    public init(
        items: [Content],
        itemWidth: CGFloat,
        itemSpacing: CGFloat = 10,
        cornerRadius: CGFloat = 5,
        initialPage: Int = 0,
        transform: @escaping (_ pageOffset: Int) -> CardPageTransform = { _ in .identity },
        onPageChange: ((Int) -> Void)? = nil
    ) {
        self.items = items
        self.itemWidth = itemWidth
        self.itemSpacing = itemSpacing
        self.cornerRadius = cornerRadius
        self.transform = transform
        self.onPageChange = onPageChange
        let lastIndex = max(items.count - 1, 0)
        _currentPage = State(initialValue: min(max(initialPage, 0), lastIndex))
    }

    private var pageStride: CGFloat { itemWidth + itemSpacing }
    private var lastPageIndex: Int { max(items.count - 1, 0) }

    public var body: some View {
        // GeometryReader gives an explicit, concrete width to align against.
        // `.frame(maxWidth: .infinity, alignment: .leading)` looked right but
        // wasn't: maxWidth only raises the upper bound, it doesn't force the
        // view to claim the parent's full width — so the oversized content
        // kept reporting its natural size and something further up centered
        // it. An explicit `width:` has no such ambiguity.
        GeometryReader { proxy in
            HStack(spacing: itemSpacing) {
                ForEach(Array(items.enumerated()), id: \.offset) { index, item in
                    let t = transform(index - currentPage)
                    item
                        .frame(width: itemWidth)
                        .cornerRadius(cornerRadius)
                        .scaleEffect(t.scale)
                        .opacity(t.opacity)
                        .rotation3DEffect(t.rotation, axis: (x: 0, y: 1, z: 0))
                }
            }
            // Flattens the whole card row into one rasterized layer. Without this,
            // every card's shadow/gradient gets recomposited on every drag frame —
            // that's the actual source of the lag, not the generic Content type.
            .drawingGroup()
            .offset(x: -CGFloat(currentPage) * pageStride + dragTranslation)
            .frame(width: proxy.size.width, alignment: .leading)
            .clipped()
            .gesture(
                DragGesture()
                    .onChanged { value in
                        dragTranslation = value.translation.width
                    }
                    .onEnded { value in
                        // A threshold check, not a continuous position calculation: every
                        // gesture moves at most one page, in whichever direction crossed
                        // the threshold. predictedEndTranslation (not translation) is what's
                        // checked, so a fast short flick still counts, not just a long slow
                        // drag — but it can never skip multiple pages or land off by one.
                        let threshold = pageStride * 0.3
                        let predicted = value.predictedEndTranslation.width
                        var targetPage = currentPage
                        if predicted < -threshold {
                            targetPage = currentPage + 1
                        } else if predicted > threshold {
                            targetPage = currentPage - 1
                        }
                        let clampedPage = min(max(targetPage, 0), lastPageIndex)
                        withAnimation(.interactiveSpring(response: 0.35, dampingFraction: 0.86, blendDuration: 0.2)) {
                            currentPage = clampedPage
                            dragTranslation = 0
                        }
                    }
            )
            .onChange(of: currentPage) { newValue in
                onPageChange?(newValue)
            }
        }
    }
}

#Preview {
    struct PreviewHost: View {
        @State private var currentPage = 0

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
        }

        var body: some View {
            VStack(spacing: 16) {
                Text("Current page: \(currentPage)")
                    .font(.headline)

                BannerPagingView(
                    items: [
                        bankCard(last4: "4821", gradient: [.blue, .purple]),
                        bankCard(last4: "9027", gradient: [.orange, .red]),
                        bankCard(last4: "1193", gradient: [.green, .teal]),
                    ],
                    itemWidth: 300,
                    initialPage: 0,
                    onPageChange: { currentPage = $0 }
                )
                .frame(width: 320, height: 180)
            }
        }
    }

    return PreviewHost()
}
