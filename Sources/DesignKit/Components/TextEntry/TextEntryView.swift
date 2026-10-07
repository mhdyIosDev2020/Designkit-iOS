import SwiftUI

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
                            HStack{
                                InputField(text: $text.onChange(textChanged), placeHolder: $placeHolder, isEnabled: .constant(true), isFocused: $hasFocus, isSecure: $isSecure,  isAllowedToEdit : isAllowedToEdit  , keyboardType: type.keyboardType(),textContentType: self.textContentType, returnKeyType: returnType, done: {
                                    done()
                                })
                                .padding(8)
                                .background(Capsule()
                                    .strokeBorder(lineWidth: 1).foregroundColor(.gray.opacity(0.5)))
                                .frame(height: 40)
                                .padding(.vertical, 5)

                                .onChange(of: hasFocus) { newValue in
                                    if !newValue {
                                        lostFocus()
                                    }
                                }
                                StatusView(validatationState: validatationState, type: self.type, isSecure: $isSecure)


                            }.background(Color(.clear))
                        }
                }
                
                
                
                Spacer()
                
      
                
        
            }
        }
        .background(Color(.clear))
        .padding()
        .background(Rectangle().fill(.clear))
        .cornerRadius(10)
        .onAppear{
            self.isSecure = type.isSecure()
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

