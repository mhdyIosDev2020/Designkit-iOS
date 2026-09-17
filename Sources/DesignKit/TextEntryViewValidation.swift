//
//  TextEntryViewValidation.swift
//  DesignKit
//
//  Created by mohsen Hashemloo on 1405/6/26.
//
import SwiftUI

public enum TextEntryViewValidation {
    case none
    case valid
    case invalid
    case loading
    case modifiable
    case editing
    
    func color() -> Color {
        if self == .editing {
            return .blue
        }
        if self == .valid  || self == .none {
            return .black.opacity(0.5)
        }
        else if self == .invalid {
            return .red
        }
        
        return .green
    }
}
