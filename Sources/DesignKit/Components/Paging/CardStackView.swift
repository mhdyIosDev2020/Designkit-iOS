//
//  CardStackView.swift
//  DesignKit
//

import SwiftUI

/// A cyclic card stack — all cards render in one ZStack (last item on top,
/// per SwiftUI's default z-order), and swiping the front card doesn't remove
/// it: it rotates to the back of the stack, revealing the next card as the
/// new front. Swiping the other way reverses it, pulling the back card
/// forward again. No ScrollView, no fixed index into a page list — the
/// state is the stack's order itself.
///
/// Direction is collapsed to two logical actions regardless of axis: a
/// rightward or upward swipe past the threshold means "next" (front → back),
/// a leftward or downward swipe means "previous" (back → front). The front
/// card continues flying off in whichever direction you actually dragged.
public struct CardStackView<Content: View>: View {
    @State private var orderedItems: [Content]
    @State private var dragTranslation: CGSize = .zero

    // Tracked by the card's original ID, not its current array position —
    // once `rotate` moves the just-dismissed card to the back, it's no
    // longer "front," so it can't keep riding `dragTranslation`. This pair
    // gives it its own offset so the off-screen → back-of-stack leg can
    // still be animated instead of snapping.
    @State private var returningCardID: Int?
    @State private var returningOffset: CGSize = .zero
    @State private var returningTilt: Angle = .zero

    // Tracks dragProgress live while dragging, same as offset/tilt — but
    // unlike dragTranslation, it deliberately does NOT reset to 0 the
    // instant the drag ends (see handleDragEnded), so the other cards don't
    // snap back mid-dismiss. It only resets once `rotate()` actually runs,
    // at which point resetting it is seamless — see fannedOffset's math.
    @State private var stackShiftProgress: CGFloat = 0

    /// The tilt a card reaches right at the dismiss threshold.
    private let maxDragTilt: Angle = .degrees(30)

    /// Pivot point for the tilt, below the card's own bottom edge (y > 1 in
    /// UnitPoint terms) rather than dead-center — this is what makes the
    /// combined move+tilt read as a natural thumb-flick, the standard
    /// technique behind every Tinder-style swipe, instead of the card
    /// looking like it's spinning in place while it happens to also move.
    private let tiltAnchor = UnitPoint(x: 0.5, y: 1.3)

    public let dismissThreshold: CGFloat
    public let onFrontChange: ((Int) -> Void)?

    /// Live drag progress toward a page change, reported continuously
    /// during the drag rather than only once it's confirmed. Signed: 0 = no
    /// drag, ramps toward +1 while dragging toward "next" and -1 toward
    /// "previous" — meant for driving something like `PageControl`'s
    /// `dragProgress` so it tracks the gesture in real time instead of only
    /// snapping when `onFrontChange` eventually fires.
    public let onDragProgress: ((CGFloat) -> Void)?

    /// How far apart each card sits from the one behind it, in both x and y
    /// — this is what makes every card's edge visible behind the front one
    /// (a fanned-deck look) instead of all cards sitting exactly on top of
    /// each other. A card 2 positions back from the front sits at `2 *
    /// stackOffsetStep`, and so on.
    public let stackOffsetStep: CGSize

    /// `id`s track the original array position of each item through
    /// rotations, so `onFrontChange` reports a stable index back to the
    /// caller rather than "whatever's currently first in the shuffled array."
    @State private var orderedIDs: [Int]

    public init(
        items: [Content],
        dismissThreshold: CGFloat = 100,
        stackOffsetStep: CGSize = CGSize(width: 20, height: 20),
        onFrontChange: ((Int) -> Void)? = nil,
        onDragProgress: ((CGFloat) -> Void)? = nil
    ) {
        _orderedItems = State(initialValue: items)
        _orderedIDs = State(initialValue: Array(items.indices))
        self.dismissThreshold = dismissThreshold
        self.stackOffsetStep = stackOffsetStep
        self.onFrontChange = onFrontChange
        self.onDragProgress = onDragProgress
    }

    private enum Direction {
        case next
        case previous
    }

    public var body: some View {
        ZStack {
            ForEach(Array(orderedItems.enumerated()), id: \.offset) { index, item in
                item
                    .offset(offset(forCardAt: index))
                    .rotationEffect(tilt(forCardAt: index), anchor: tiltAnchor)
                    .zIndex(Double(index))
            }
        }
        .gesture(
            DragGesture()
                .onChanged { value in
                    dragTranslation = value.translation
                    stackShiftProgress = dragProgress
                    onDragProgress?(signedDragProgress)
                }
                .onEnded(handleDragEnded)
        )
    }

    private func isFront(_ index: Int) -> Bool {
        index == orderedItems.count - 1
    }

    /// Same shape as `liveDragTilt`'s progress calc — continuous from the
    /// first pixel, reaching 1 exactly at `dismissThreshold`.
    private var dragProgress: CGFloat {
        let magnitude = max(abs(dragTranslation.width), abs(dragTranslation.height))
        return min(magnitude / dismissThreshold, 1)
    }

    /// `dragProgress`, signed by which direction the drag would trigger if
    /// released right now — matches the same dominant-axis logic
    /// `handleDragEnded` uses to decide `.next` vs `.previous`.
    private var signedDragProgress: CGFloat {
        let horizontal = dragTranslation.width
        let vertical = dragTranslation.height
        let horizontalIsDominant = abs(horizontal) > abs(vertical)
        let wouldGoNext = horizontalIsDominant ? (horizontal > 0) : (vertical < 0)
        return wouldGoNext ? dragProgress : -dragProgress
    }

    private func offset(forCardAt index: Int) -> CGSize {
        if orderedIDs[index] == returningCardID {
            return returningOffset
        }
        if isFront(index) {
            return dragTranslation
        }
        // Interpolates toward "one step closer to front" as the front card's
        // drag progresses — so the whole stack shifts together in real time
        // instead of snapping all at once once the dismiss finally completes.
        let distanceFromFront = orderedItems.count - 1 - index
        let current = fannedOffset(distanceFromFront: distanceFromFront)
        let next = fannedOffset(distanceFromFront: distanceFromFront - 1)
        return CGSize(
            width: current.width + (next.width - current.width) * stackShiftProgress,
            height: current.height + (next.height - current.height) * stackShiftProgress
        )
    }

    /// The resting position for a card `distanceFromFront` positions back —
    /// 0 for the front card itself. Front's is always `.zero` since
    /// `distanceFromFront` is 0 there.
    private func fannedOffset(distanceFromFront: Int) -> CGSize {
        let n = CGFloat(distanceFromFront)
        return CGSize(width: stackOffsetStep.width * n, height: stackOffsetStep.height * n)
    }

    private func tilt(forCardAt index: Int) -> Angle {
        if orderedIDs[index] == returningCardID {
            return returningTilt
        }
        return isFront(index) ? liveDragTilt : .zero
    }

    /// Tracks the drag continuously from the first pixel — same source
    /// (`dragTranslation`) and same instant as `offset(forCardAt:)`, so tilt
    /// and movement are always exactly in step, reaching `maxDragTilt`
    /// exactly at `dismissThreshold`. Sign follows the dominant axis's
    /// direction (right/down tilt one way, left/up the other). Purely
    /// derived from `dragTranslation`, so the threshold-not-crossed
    /// snap-back restores level for free — no separate state needed for that case.
    private var liveDragTilt: Angle {
        let horizontal = dragTranslation.width
        let vertical = dragTranslation.height
        let horizontalIsDominant = abs(horizontal) > abs(vertical)
        let magnitude = horizontalIsDominant ? abs(horizontal) : abs(vertical)
        let sign: Double = horizontalIsDominant
            ? (horizontal >= 0 ? 1 : -1)
            : (vertical >= 0 ? 1 : -1)

        let progress = min(magnitude / dismissThreshold, 1)
        return .degrees(sign * progress * maxDragTilt.degrees)
    }

    private func handleDragEnded(_ value: DragGesture.Value) {
        let horizontal = value.translation.width
        let vertical = value.translation.height
        let horizontalIsDominant = abs(horizontal) > abs(vertical)
        let magnitude = horizontalIsDominant ? horizontal : vertical

        guard abs(magnitude) > dismissThreshold, !orderedItems.isEmpty else {
            withAnimation(.interactiveSpring(response: 0.3, dampingFraction: 0.8, blendDuration: 0.2)) {
                dragTranslation = .zero
                stackShiftProgress = 0
                onDragProgress?(0)
            }
            return
        }

        let direction: Direction = horizontalIsDominant
            ? (horizontal > 0 ? .next : .previous)
            : (vertical < 0 ? .next : .previous)

        // Both legs of the dismiss — fly-out and the return to the back of
        // the stack — always travel horizontally now, regardless of which
        // axis was actually dragged. Live tracking during the drag itself is
        // untouched (still follows the finger on either axis); only the
        // confirmed-dismissal animation is pinned to left/right, which is
        // also what lets the tilt's sign stay correct and settled for the
        // whole sequence instead of potentially crossing over mid-flight as
        // a vertical drag's height component animated down to 0.
        let flyDistance: CGFloat = 600
        let side: CGFloat = direction == .next ? 1 : -1
        let exitPoint = CGSize(width: side * flyDistance, height: 0)
        let exitTilt = Angle.degrees(side * maxDragTilt.degrees)

        let dismissedID = orderedIDs[orderedItems.count - 1]

        // Hand off immediately, starting exactly where the live drag left
        // off — no jump — so from here on this card's offset/tilt are driven
        // by returning*, not dragTranslation, for the entire exit+return
        // sequence. stackShiftProgress deliberately stays at 1 here (not
        // reset alongside dragTranslation) — see its declaration comment.
        returningCardID = dismissedID
        returningOffset = dragTranslation
        returningTilt = liveDragTilt
        dragTranslation = .zero

        withAnimation(.easeIn(duration: 0.25)) {
            returningOffset = exitPoint
            returningTilt = exitTilt
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
            rotate()
            // Seamless, not a snap: every other card's distanceFromFront just
            // decreased by 1 in the array itself, so fannedOffset computed
            // fresh (progress 0) at the new index already equals what
            // progress-1-at-the-old-index was rendering a moment ago.
            stackShiftProgress = 0
            // Same reasoning applies here: onFrontChange fires inside rotate()
            // with the new front index, and resetting to 0 at this exact
            // instant lines up with it — a caller-side PageControl computing
            // "current page + 0" now equals "old page + fully-committed
            // progress toward next" a moment ago.
            onDragProgress?(0)

            // Rotation always sends the dismissed card all the way to the
            // back, so it animates to the back-most fanned position, not to
            // .zero — otherwise it'd land dead-center, on top of the stack
            // it just went behind.
            let restingOffset = fannedOffset(distanceFromFront: orderedItems.count - 1)
            withAnimation(.easeOut(duration: 0.3)) {
                returningOffset = restingOffset
                returningTilt = .zero
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                if returningCardID == dismissedID {
                    returningCardID = nil
                }
            }
        }
    }

    /// Always front → back, regardless of which direction dismissed it —
    /// `Direction` only decides the exit/return *visuals* (which side it
    /// flies off to and returns from), not where it ends up in the stack.
    /// A true inverse rotation (back card jumps to front, dragged card only
    /// steps back one slot) was tried here for `.previous`, but that leaves
    /// the card you just dragged sitting one slot back instead of at the
    /// back of the stack — not what's wanted.
    private func rotate() {
        guard !orderedItems.isEmpty else { return }
        orderedItems.insert(orderedItems.removeLast(), at: 0)
        orderedIDs.insert(orderedIDs.removeLast(), at: 0)
        onFrontChange?(orderedIDs[orderedIDs.count - 1])
    }
}

#Preview {
    struct PreviewHost: View {
        @State private var frontIndex = 2

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
            VStack(spacing: 16) {
                Text("Front card (original index): \(frontIndex)")
                    .font(.headline)

                CardStackView(
                    items: [
                        bankCard(last4: "4821", gradient: [.blue, .purple]),
                        bankCard(last4: "9027", gradient: [.orange, .red]),
                        bankCard(last4: "1193", gradient: [.green, .teal]),
                    ],
                    onFrontChange: { frontIndex = $0 }
                )
                .frame(width: 300, height: 180)
            }
        }
    }

    return PreviewHost()
}
