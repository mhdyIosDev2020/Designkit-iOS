//
//  Fonts.swift
//  DesignKit
//
//  Created by Mahdi_iOS on 24/08/23.
//

import SwiftUI
//MARK: Font Extension
public extension Font {
    enum ManropeFont {
        case semibold
        case custom(String)
        
        var value: String {
            switch self {
            case .semibold:
                return "Semibold"
                
            case .custom(let name):
                return name
            }
        }
    }
    
    enum LatoFont {
        case black
        case bold
        case heavy
        case regular
        case light
        
        var value: String {
            
            switch self {
                
            case .black:
                return "Lato-Black"
            case .bold:
                return "Lato-Bold"
            case .heavy:
                return "Lato-Heavy"
            case .regular:
                return "Lato-Regular"
            case .light:
                return "Lato-Light"
            }
        }
    }
    
    enum RobotoFont {
        case semibold
        case custom(String)
        
        var value: String {
            switch self {
            case .semibold:
                return "Semibold"
                
            case .custom(let name):
                return name
            }
        }
    }
    
    static func manrope(_ type: ManropeFont, size: CGFloat = 26) -> Font {
        return .custom(type.value, size: size)
    }
    
    static func roboto(_ type: RobotoFont, size: CGFloat = 26) -> Font {
        return .custom(type.value, size: size)
    }
    static func lato(_ type: LatoFont, size: CGFloat = 15) -> Font {
        return .custom(type.value, size: size)
    }
}
