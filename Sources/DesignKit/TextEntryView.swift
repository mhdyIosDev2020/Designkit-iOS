//
//  TextEntryView.swift
//  TextEntryView
//
//  Created by Jason Blood on 8/11/21.
//

import SwiftUI

public enum TextEntryViewValidation: Int {
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

public enum TextEntryViewType: Int {
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

public struct TextEntryView: View {
    @Binding public var text: String
    @Binding public var placeHolder: String
    @Binding public var validatationState: TextEntryViewValidation
    @Binding public var validatationMessage: String
    @Binding public var returnType: UIReturnKeyType
    @Binding public var hasFocus: Bool
    @Binding public var countryCode: String?
    @Binding public var countryName: String?
    @Binding public var genderID: String
    @Binding public var birthday: String
    @Binding public var hearAboutUs: String
    @Binding public var isAllowedToEdit: Bool
    @State public var isSecure:Bool = true
//    public var isAllowedToEdit: Bool = true
    public var textContentType: UITextContentType
    public var type = TextEntryViewType.email
    public let lostFocus: () -> Void
    public let done: () -> Void
    public var forgot: (() -> Void)?
    public var picker: (() -> Void)?
    public var modifyIconClicked: (() -> Void)?
    
    
    public init(
            text: Binding<String>,
            placeHolder: Binding<String>,
            validatationState: Binding<TextEntryViewValidation>,
            validatationMessage: Binding<String>,
            returnType: Binding<UIReturnKeyType>,
            hasFocus: Binding<Bool>,
            countryCode: Binding<String?> = .constant(nil),
            countryName: Binding<String?> = .constant(nil),
            genderID: Binding<String> = .constant(""),
            birthday: Binding<String> = .constant(""),
            hearAboutUs: Binding<String> = .constant(""),
            isSecure: Bool = false,
            isAllowedToEdit: Binding<Bool>,
            type: TextEntryViewType = .email,
            textContentType: UITextContentType = .emailAddress,
            lostFocus: @escaping () -> Void,
            done: @escaping () -> Void,
            forgot: (() -> Void)? = nil,
            picker: (() -> Void)? = nil,
            modifyIconClicked: (() -> Void)? = nil
        ) {
            self._text = text
            self._validatationState = validatationState
            self._validatationMessage = validatationMessage
            self._returnType = returnType
            self._hasFocus = hasFocus
            self._countryCode = countryCode
            self._countryName = countryName
            self._genderID = genderID
            self._birthday = birthday
            self._hearAboutUs = hearAboutUs
            self.isSecure = isSecure
            self._isAllowedToEdit = isAllowedToEdit
            self.type = type
            self.lostFocus = lostFocus
            self.done = done
            self.forgot = forgot
            self.picker = picker
            self.modifyIconClicked = modifyIconClicked
            self.textContentType = textContentType
            self._placeHolder = placeHolder
        }
    
    
    private var labelState: TextEntryViewLabelState {
        get {
            if hasFocus || text != "" || validatationState == .invalid || (type == .country && countryCode != nil) {
                return .small
            }
            
            return .large
        }
    }
    
    private enum TextEntryViewLabelState: Int {
        case large
        case small
    }
    
    private var backgroundLabel: some View {
        GeometryReader { reader in
            VStack(spacing: 0) {
                Spacer(minLength: 0)
                
                HStack {
                    if type == .phone {
                        Button(action: {
                        }, label: {
                            HStack {
                                Text("+\(countryCode ?? "")")
                                    .font(.manrope(.semibold))
//                                    .themeFont(font: .largeButton)
                                    .foregroundColor(.primary)
                                    .frame(width: 45)
                                Image(systemName: "chevron.down")
                            }
                            .padding(5)
                        }).opacity(0)
                    }
                    
                    if validatationState == .invalid {
                        Text(validatationMessage)
                            .font(.manrope(.semibold))
                            .foregroundColor(validatationState.color())
                            .offset(x: 0, y: labelState == .large ? 0 : -10)
                            .frame(width: (reader.size.width - (type == .phone ? 120 : 20)) / (labelState == .large ? 1 : 0.6), alignment: .leading)
                            .scaleEffect(labelState == .large ? 1 : 0.6, anchor: UnitPoint.topLeading)
                            .onTapGesture {
                                if type == .country || type == .genderID || type == .birthday {
                                    picker?()
                                }
                                else {
                                    hasFocus = true
                                }
                            }
                    }
                    else {
                        Text(type.placeholder())
                            .font(.manrope(.semibold))
                            .foregroundColor(.black)
                            .offset(x: 0, y: labelState == .large ? 0 : -10)
                            .frame(width: (reader.size.width - (type == .phone ? 120 : 20)) / (labelState == .large ? 1 : 0.6), alignment: .leading)
                            .scaleEffect(labelState == .large ? 1 : 0.6, anchor: UnitPoint.topLeading)
                            .onTapGesture {
                                if type == .country || type == .genderID || type == .birthday {
                                    picker?()
                                }
                                else {
                                    hasFocus = true
                                }
                            }
                    }
                }
                
                Spacer(minLength: 0)
            }
            .animation(.easeInOut, value: labelState)
        }
    }
    
    private func textChanged(_ value: String) {
        if value != "" {
            validatationState = .none
            validatationMessage = ""
        }
    }
    
    public var body: some View {
        VStack{
            HStack {
                switch type {
                case .phone:
                    Button(action: {
                        picker?()
                    }, label: {
                        HStack {
                            Text("+\(countryCode ?? "")")
                                .font(.manrope(.semibold))
                                .foregroundColor(.primary)
                                .frame(width: 45)
                            Image(systemName: "chevron.down")
                        }
                        .padding(5)
                    })
                
                case .genderID:
                    VStack(alignment: .leading, spacing: 0) {
                        Text(type.placeholder()).opacity(0)
                        
                        Button(action: {
                            picker?()
                        }, label: {
                            HStack {
                                Text(genderID)
                                    .foregroundColor(.primary)
                                Spacer(minLength: 0)
                            }
                            .frame(height: 24)
                        })
                        .padding(.vertical, 5)
                    }
                case .birthday:
                    VStack(alignment: .leading, spacing: 0) {
                        Text(type.placeholder()).opacity(0)

                        Button(action: {
                            picker?()
                        }, label: {
                            HStack {
                                Text(birthday)
                                    .foregroundColor(.primary)
                                Spacer(minLength: 0)
                            }
                            .frame(height: 24)
                        })
                        .padding(.vertical, 5)
                    }
                case .country:
                    VStack(alignment: .leading, spacing: 0) {
                        Text(type.placeholder()).opacity(0)
                        
                        Button(action: {
                            picker?()
                        }, label: {
                            HStack {
                                Text(countryCode ?? "")
                                    .foregroundColor(.primary)
                                Spacer(minLength: 0)
                            }
                            .frame(height: 24)
                        })
                        .padding(.vertical, 5)
                    }
                
                case .hearAboutus:
                    VStack(alignment: .leading, spacing: 0) {
                        Text(type.placeholder()).opacity(0)

                        Button(action: {
                            picker?()
                        }, label: {
                            HStack {
                                Text(hearAboutUs)
                                    .foregroundColor(.primary)
                                Spacer(minLength: 0)
                            }
                            .frame(height: 24)
                        })
                        .padding(.vertical, 5)
                    }
                default:
                    
                        VStack(alignment: .leading, spacing: 0) {
                            Text(type.placeholder()).opacity(0.5)
//                            TextField("Email", text: $userName).tint(.red).padding().background(Capsule().strokeBorder(lineWidth: 1).foregroundColor(.red)).padding()
                            HStack{
                                InputField(text: $text.onChange(textChanged), placeHolder: $placeHolder, isEnabled: .constant(true), isFocused: $hasFocus, isSecure: $isSecure,  isAllowedToEdit : isAllowedToEdit  , keyboardType: type.keyboardType(),textContentType: self.textContentType, returnKeyType: returnType, done: {
                                    done()
                                })
                                .padding(8)
                                .background(Capsule().strokeBorder(lineWidth: 1).foregroundColor(.gray.opacity(0.5)))//.padding()
                                .frame(height: 40)
                                .padding(.vertical, 5)
                                
                                .onChange(of: hasFocus) { newValue in
                                    if !newValue {
                                        lostFocus()
                                    }
                                }
                                StatusView(validatationState: validatationState, type: self.type, isSecure: self.isSecure)
                                

                            }
                            /*.onChange(of: text) { newValue in
                                if newValue != "" {
                                    validatationState = .none
                                    validatationMessage = ""
                                }
                            }*/
                        }
                }
                
                
                
                Spacer()
                
      
                
        
            }
//            Divider()
        }
        .padding()
        .background(Rectangle().fill(.white))
        .cornerRadius(10)
//        .background(backgroundLabel)
//        .border(width: 1 / UIScreen.main.scale, edges: [.bottom], color: validatationState.color())
        .onAppear{
            self.isSecure = type.isSecure()
        }
    }
    
    
    
}
struct StatusView : View {
    
    @State public var validatationState: TextEntryViewValidation
    public var type : TextEntryViewType
    @State public var isSecure:Bool
    public var forgot: (() -> Void)?
    public var modifyIconClicked: (() -> Void)?
   

    var body: some View {
        if type == .password || type == .createPassword {
            
            HStack(spacing : 10) {
                
                if forgot != nil {
                    Button("Forgot?") {
                        forgot?()
                    }
                    .buttonStyle(LinkButtonStyle())
                }
                
                Button {
                    self.isSecure.toggle()
                } label: {
                    Image(systemName: self.isSecure ?
                          "eye.slash" : "eye")
                    .resizable()
                    .frame(width: 25, height: 15)
                    .foregroundColor(Color.gray)
                }
                
            }.frame(height: 40)
            
        }
        
        if validatationState == .valid {
            Image(systemName: "checkmark.circle.fill")
                .foregroundColor(validatationState.color())
        }
        else if validatationState == .invalid {
            Image(systemName: "xmark.circle.fill")
                .foregroundColor(validatationState.color())
        }
        else if validatationState == .loading {
            ProgressView()
        }
        else if validatationState == .modifiable {
            
            Button {
                modifyIconClicked?()
            } label: {
                Image(systemName: "pencil")
                    .foregroundColor(validatationState.color())
            
            }
            
            
        }
        else {
//                Image(systemName: "xmark.circle.fill")
//                    .opacity(0)
        }
    }
}
struct TextEntryView_Previews: PreviewProvider {
    static var previews: some View {
        TextEntryView(text: .constant(""), placeHolder: .constant("place holder"), validatationState: .constant(.none), validatationMessage: .constant("Password requires at least one character.  Please enter that below..."), returnType: .constant(.done), hasFocus: .constant(false),countryCode: .constant("+98"), countryName: .constant(nil), genderID: .constant("") , birthday: .constant(""),hearAboutUs: .constant(""), isAllowedToEdit: .constant(true), type: .password, lostFocus: {

        }, done: {

        })
        .padding()
    }
}
struct LinkButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .font(.body)
            .foregroundColor(.blue)
            .opacity(configuration.isPressed ? 0.8 : 1.0)
    }
}
