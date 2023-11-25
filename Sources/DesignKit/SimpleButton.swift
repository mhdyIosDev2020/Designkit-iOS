//
//  SimpleButton.swift
//  DesignKit
//
//  Created by Mahdi_iOS on 27/08/23.
//

import SwiftUI

public struct SimpleButton: View {
    public var title: String = "Button Title"
    @Binding public var isLoading: Bool
    public let cornerRadius: CGFloat = 10
    public let backgroundColor: Color = .red
    public let loadingBackgroundColor: Color = .gray
    public let foregroundColor: Color = .white
    public let font: Font = .body
    public let height: CGFloat = 40
    public let action: () -> Void
    public init(isLoading: Binding<Bool> = .constant(false),title:String, action: @escaping () -> Void) {
        self.title = title
        self._isLoading = isLoading
        self.action = action
    }
    public var body: some View {
        Button(action: action) {
            ZStack {
                RoundedRectangle(cornerRadius: cornerRadius)
                    .frame(height: height)
                    .foregroundColor(isLoading ? loadingBackgroundColor : backgroundColor)
                
                if isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: foregroundColor))
                        .frame(width: height * 0.7, height: height * 0.7)
                } else {
                    Text(title)
                        .font(font)
                        .foregroundColor(foregroundColor)
                }
            }
        }
        .disabled(isLoading)
    }
}

struct SimpleButton_Previews: PreviewProvider {
    static var previews: some View {
        SimpleButton(title: "login") {
            
        }
    }
}
