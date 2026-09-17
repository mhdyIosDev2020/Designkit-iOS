//
//  InputField.swift
//  DesignKit
//
//  Created by Mahdi_iOS on 24/08/23.
//

import SwiftUI
import UIKit

public struct InputField: UIViewRepresentable {
    @Binding public var text: String
    @Binding public var placeHolder: String
    @Binding public var isEnabled: Bool
    @Binding public var isFocused: Bool
    @Binding public var isSecure:Bool
    public var isAllowedToEdit:Bool = true
    public var keyboardType = UIKeyboardType.default
    public var textContentType = UITextContentType.emailAddress
    public var returnKeyType = UIReturnKeyType.default
    /// Extra delegate callbacks layered on top of InputField's own syncing.
    /// `Coordinator` stays the UITextField's actual `delegate` — that's what
    /// keeps `text`/`isFocused`/`done()` working — and forwards every call
    /// here afterward. For the four methods with a return value
    /// (`shouldChangeCharactersIn`, `shouldClear`, `shouldBeginEditing`,
    /// `shouldEndEditing`), this delegate's answer wins when it implements
    /// one; InputField has no opinion of its own on those, so it defaults to
    /// `true` when this is nil or doesn't implement it. `shouldReturn` is the
    /// exception: `done()` always fires first since that's InputField's own
    /// contract, and this delegate's return value (default `false`) only
    /// decides whether the keyboard also gets UIKit's default return handling.
    public weak var delegate: UITextFieldDelegate?
    public let done: () -> Void

    public func makeUIView(context: UIViewRepresentableContext<InputField>) -> UITextField {
        let tf = UITextField(frame: .zero)
        tf.isUserInteractionEnabled = true
        tf.delegate = context.coordinator
        tf.isSecureTextEntry = isSecure
        tf.isEnabled = isEnabled
        tf.isUserInteractionEnabled = isAllowedToEdit
        tf.keyboardType = keyboardType
        tf.returnKeyType = returnKeyType
        tf.autocorrectionType = .no
        tf.autocapitalizationType = keyboardType == .emailAddress ? .none : .words
        tf.spellCheckingType = .no
        tf.textContentType = self.textContentType
        return tf
    }

    public func makeCoordinator() -> InputField.Coordinator {
        return Coordinator(parent: self)
    }

    public func updateUIView(_ uiView: UITextField, context: Context) {
        if uiView.text != text {
            uiView.text = text
        }
           
        uiView.placeholder = placeHolder
        
        if uiView.isSecureTextEntry != isSecure {
            uiView.isSecureTextEntry = isSecure
        }
    }
    
    public class Coordinator: NSObject, UITextFieldDelegate {
        var parent: InputField?
        
        init(parent: InputField?) {
            self.parent = parent
        }

        public func textFieldDidChangeSelection(_ textField: UITextField) {
            DispatchQueue.main.async {
                if self.parent?.text != textField.text ?? "" {
                    self.parent?.text = textField.text ?? ""
                }
            }
            parent?.delegate?.textFieldDidChangeSelection?(textField)
        }

        public func textFieldDidBeginEditing(_ textField: UITextField) {
            DispatchQueue.main.async {
                if self.parent?.isFocused ?? true == false {
                    self.parent?.isFocused = true
                }
            }
            parent?.delegate?.textFieldDidBeginEditing?(textField)
        }

        public func textFieldDidEndEditing(_ textField: UITextField) {
            DispatchQueue.main.async {
                if self.parent?.isFocused ?? false {
                    self.parent?.isFocused = false
                }
            }
            parent?.delegate?.textFieldDidEndEditing?(textField)
        }

        public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            self.parent?.done()
            return parent?.delegate?.textFieldShouldReturn?(textField) ?? false
        }

        public func textField(
            _ textField: UITextField,
            shouldChangeCharactersIn range: NSRange,
            replacementString string: String
        ) -> Bool {
            parent?.delegate?.textField?(
                textField, shouldChangeCharactersIn: range, replacementString: string
            ) ?? true
        }

        public func textFieldShouldClear(_ textField: UITextField) -> Bool {
            parent?.delegate?.textFieldShouldClear?(textField) ?? true
        }

        public func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
            parent?.delegate?.textFieldShouldBeginEditing?(textField) ?? true
        }

        public func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
            parent?.delegate?.textFieldShouldEndEditing?(textField) ?? true
        }
    }
}

struct InputField_Previews: PreviewProvider {
    static var previews: some View {
        InputField(text: .constant(""), placeHolder: .constant("Some Text ..."), isEnabled: .constant(true), isFocused: .constant(false), isSecure: .constant(false) , done: {
            
        })
    }
}
