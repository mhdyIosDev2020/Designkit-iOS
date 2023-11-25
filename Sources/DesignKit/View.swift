//
//  View.swift
//  Lyf Support (iOS)
//
//  Created by Jason Blood on 7/10/21.
//

import SwiftUI
import UIKit

extension UIViewController {
    static func topMostViewController() -> UIViewController? {
        if let keyWindowScene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
            let keyWindow = keyWindowScene.windows.first(where: { $0.isKeyWindow })
            return keyWindow?.rootViewController?.topMostViewController()
        }
        return nil
    }
    func topMostViewController() -> UIViewController? {
        if let navigationController = self as? UINavigationController {
            return navigationController.topViewController?.topMostViewController()
        }
        else if let tabBarController = self as? UITabBarController {
            if let selectedViewController = tabBarController.selectedViewController {
                return selectedViewController.topMostViewController()
            }
            
            return tabBarController.topMostViewController()
        }
        else if let presentedViewController = self.presentedViewController {
            return presentedViewController.topMostViewController()
        }
        else {
            return self
        }
    }
}

private struct SizePreferenceKey: PreferenceKey {
  static var defaultValue: CGSize = .zero
  static func reduce(value: inout CGSize, nextValue: () -> CGSize) {}
}
public struct LocalizedAlertError: LocalizedError {
    let underlyingError: LocalizedError
    public var errorDescription: String? {
        underlyingError.errorDescription
    }
    public var recoverySuggestion: String? {
        underlyingError.recoverySuggestion
    }

    init?(error: Error?) {
        guard let localizedError = error as? LocalizedError else { return nil }
        underlyingError = localizedError
    }
}
public enum CodeClanError: Error {
    case other(String)
}
extension View {
    
   public func errorAlert(error: Binding<Error?>, buttonTitle: String = "OK") -> some View {
        let localizedAlertError = LocalizedAlertError(error: error.wrappedValue)
        return alert(isPresented: .constant(localizedAlertError != nil), error: localizedAlertError) { _ in
            Button(buttonTitle) {
                error.wrappedValue = nil
            }
        } message: { error in
            Text(error.recoverySuggestion ?? "")
        }
    }
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

struct EdgeBorder: Shape {
    var width: CGFloat
    var edges: [Edge] = [.top,.bottom , .leading , .trailing]

    func path(in rect: CGRect) -> Path {
        var path = Path()
        for edge in edges {
            var x: CGFloat {
                switch edge {
                case .top, .bottom, .leading: return rect.minX
                case .trailing: return rect.maxX - width
                }
            }

            var y: CGFloat {
                switch edge {
                case .top, .leading, .trailing: return rect.minY
                case .bottom: return rect.maxY - width
                }
            }

            var w: CGFloat {
                switch edge {
                case .top, .bottom: return rect.width
                case .leading, .trailing: return self.width
                }
            }

            var h: CGFloat {
                switch edge {
                case .top, .bottom: return self.width
                case .leading, .trailing: return rect.height
                }
            }
            path.addPath(Path(CGRect(x: x, y: y, width: w, height: h)))
        }
        
        return path
    }
}
extension Binding {
    func onChange(_ handler: @escaping (Value) -> Void) -> Binding<Value> {
        Binding(
            get: { self.wrappedValue },
            set: { newValue in
                self.wrappedValue = newValue
                handler(newValue)
            }
        )
    }
}
