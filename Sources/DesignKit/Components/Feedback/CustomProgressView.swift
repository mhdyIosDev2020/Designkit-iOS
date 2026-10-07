//
//  CustomProgressView.swift
//  DesignKit
//
//  Created by Mahdi_iOS on 09/09/23.
//

import SwiftUI

/// A temporary status banner that fills its progress bar before dismissing itself.
public struct CustomProgressView: View {
    @Binding private var isVisible: Bool

    private let barColor: Color
    private let timeInterval: TimeInterval
    private let title: String
    private let description: String

    @State private var isProgressComplete = false

    /// Creates a status banner that dismisses after `timeInterval` seconds.
    public init(
        isVisible: Binding<Bool>,
        barColor: Color = .red,
        timeInterval: TimeInterval = 5,
        title: String,
        description: String
    ) {
        self._isVisible = isVisible
        self.barColor = barColor
        self.timeInterval = max(0, timeInterval)
        self.title = title
        self.description = description
    }

    /// Creates a status banner using the previous API.
    @available(*, deprecated, message: "Use init(isVisible:barColor:timeInterval:title:description:) instead.")
    public init(
        isVisible: Binding<Bool>,
        barColor: Color,
        timeInterval: TimeInterval,
        drawingWidth: Bool = true,
        title: String,
        descriptionValue: String
    ) {
        _ = drawingWidth
        self.init(
            isVisible: isVisible,
            barColor: barColor,
            timeInterval: timeInterval,
            title: title,
            description: descriptionValue
        )
    }

    public var body: some View {
        Group {
            if isVisible {
                content
                    .transition(.move(edge: .top).combined(with: .opacity))
                    .task(id: isVisible) {
                        await animateAndDismiss()
                    }
            }
        }
        .animation(.easeInOut, value: isVisible)
    }

    private var content: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .font(.lato(.bold, size: 15))

            if !description.isEmpty {
                Text(description)
                    .font(.lato(.regular, size: 12))
                    .foregroundStyle(.secondary)
            }

            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    Capsule()
                        .fill(Color(.systemGray6))

                    Capsule()
                        .fill(barColor)
                        .frame(width: geometry.size.width * (isProgressComplete ? 1 : 0))
                }
            }
            .frame(height: 5)
            .accessibilityElement(children: .ignore)
            .accessibilityLabel("Progress")
            .accessibilityValue(isProgressComplete ? "Complete" : "In progress")
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .accessibilityElement(children: .combine)
    }

    @MainActor
    private func animateAndDismiss() async {
        isProgressComplete = false

        // Yield once so SwiftUI can render the empty bar before its animation begins.
        await Task.yield()

        withAnimation(.linear(duration: timeInterval)) {
            isProgressComplete = true
        }

        guard timeInterval > 0 else {
            isVisible = false
            return
        }

        let nanoseconds = UInt64(timeInterval * 1_000_000_000)
        do {
            try await Task.sleep(nanoseconds: nanoseconds)
        } catch {
            return
        }

        guard !Task.isCancelled else { return }
        isVisible = false
    }
}

struct CustomProgressView_Previews: PreviewProvider {
    static var previews: some View {
        CustomProgressView(
            isVisible: .constant(true),
            barColor: .blue,
            timeInterval: 5,
            title: "Uploading file",
            description: "This banner will close automatically."
        )
        .padding()
    }
}
