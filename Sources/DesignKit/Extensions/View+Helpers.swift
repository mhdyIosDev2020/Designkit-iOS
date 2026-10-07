//
//  View+Helpers.swift
//  DesignKit
//

import SwiftUI
import UIKit

private struct SizePreferenceKey: PreferenceKey {
  static var defaultValue: CGSize = .zero
  static func reduce(value: inout CGSize, nextValue: () -> CGSize) {}
}
extension View {
    func getRect() -> CGRect {
        return UIScreen.main.bounds
    }
    
    func readSize(onChange: @escaping (CGSize) -> Void) -> some View {
        background(
          GeometryReader { geometryProxy in
            Color.clear
              .preference(key: SizePreferenceKey.self, value: geometryProxy.size)
          }
        )
        .onPreferenceChange(SizePreferenceKey.self, perform: onChange)
    }
    
    
    @ViewBuilder func isHidden(_ hidden: Bool, remove: Bool = false) -> some View {
           if hidden {
               if !remove {
                   self.hidden()
               }
           } else {
               self
           }
       }
    
//    func themeFont(font: ThemeFont) -> some View {
//        ModifiedContent(content: self, modifier: ThemeFontViewModifier(font: font))
//    }
    
    func border(width: CGFloat, edges: [Edge], color: Color) -> some View {
        overlay(EdgeBorder(width: width, edges: edges).foregroundColor(color))
    }
    
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    func safeTopInset() -> CGFloat {
        if let keyWindowScene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
            return keyWindowScene.windows.first?.safeAreaInsets.top ?? 0
        }
        return 0
    }
    
    func safeBottomInset() -> CGFloat {
        if let keyWindowScene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
            return keyWindowScene.windows.first?.safeAreaInsets.bottom ?? 0
        }
        return 0
    }
    @ViewBuilder
      func `if`<Content: View>(_ conditional: Bool, content: (Self) -> Content) -> some View {
           if conditional {
               content(self)
           } else {
               self
           }
       }
}
