//
//  InputField.swift
//  DesignKit
//
//  Created by Mahdi_iOS on 24/08/23.
//

import SwiftUI

public struct InputField: UIViewRepresentable {
    @Binding public var text: String
    @Binding public var isEnabled: Bool
    @Binding public var isFocused: Bool
    @Binding public var isSecure:Bool
    public var isAllowedToEdit:Bool = true
    public var keyboardType = UIKeyboardType.default
    public var textContentType = UITextContentType.emailAddress
    public var returnKeyType = UIReturnKeyType.default
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
        }

        public func textFieldDidBeginEditing(_ textField: UITextField) {
            DispatchQueue.main.async {
                if self.parent?.isFocused ?? true == false {
                    self.parent?.isFocused = true
                }
            }
        }

        public func textFieldDidEndEditing(_ textField: UITextField) {
            DispatchQueue.main.async {
                if self.parent?.isFocused ?? false {
                    self.parent?.isFocused = false
                }
            }
        }

        public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            self.parent?.done()
            return false
        }
    }
}

struct InputField_Previews: PreviewProvider {
    static var previews: some View {
        InputField(text: .constant("Hello"), isEnabled: .constant(true), isFocused: .constant(false), isSecure: .constant(false) , done: {
            
        })
    }
}
