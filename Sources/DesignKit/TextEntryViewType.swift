//
//  TextEntryViewType.swift
//  DesignKit
//
//  Created by mohsen Hashemloo on 1405/6/26.
//
import UIKit

public enum TextEntryViewType {
    case email
    case phone
    case password
    case createPassword
    case displayName
    case genderID
    case birthday
    case country
    case verificationCode
    case newPassword
    case confirmPassword
    case hearAboutus
    
    func placeholder() -> String {
        if self == .email {
            return "Email Address"
        }
        else if self == .phone {
            return "Mobile Phone"
        }
        else if self == .password {
            return "Password"
        }
        else if self == .createPassword {
            return "Create Password"
        }
        else if self == .displayName {
            return "Display Name *"
        }
        else if self == .genderID {
            return "Gender Identity"
        }
        else if self == .birthday {
            return "Birthday"
        }
        else if self == .country {
            return "Country *"
        }
        else if self == .verificationCode {
            return "Verification Code"
        }
        else if self == .newPassword {
            return "New Password"
        }
        else if self == .confirmPassword {
            return "Confirm Password"
        }
        
        else if self == .hearAboutus {
            return "How did you hear about us? *"
        }
        
        return "Entry"
    }
    
    func keyboardType() -> UIKeyboardType {
        if self == .email {
            return .emailAddress
        }
        else if self == .phone || self == .verificationCode {
            return .numberPad
        }
        else if self == .password {
            return .default
        }
        else if self == .createPassword || self == .newPassword || self == .confirmPassword {
            return .default
        }
        else if self == .displayName {
            return .default
        }
        else if self == .country {
            return .default
        }
        
        return .default
    }
    
    func isSecure() -> Bool {
        if self == .password {
            return true
        }
        else if self == .createPassword || self == .newPassword || self == .confirmPassword {
            return true
        }
        
        return false
    }
}
