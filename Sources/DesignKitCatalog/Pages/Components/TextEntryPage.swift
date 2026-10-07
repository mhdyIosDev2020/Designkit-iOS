//
//  TextEntryPage.swift
//  DesignKitCatalog
//

import SwiftUI
import DesignKit

struct TextEntryPage: View {
    @State private var text = ""
    @State private var placeholder = "Type here"
    @State private var type = TextEntryViewType.email
    @State private var validation = TextEntryViewValidation.none
    @State private var message = ""
    @State private var hasFocus = false
    @State private var isEditable = true

    private let types: [CatalogOption<TextEntryViewType>] = [
        CatalogOption("email", .email),
        CatalogOption("password", .password),
        CatalogOption("createPassword", .createPassword),
        CatalogOption("newPassword", .newPassword),
        CatalogOption("confirmPassword", .confirmPassword),
        CatalogOption("displayName", .displayName),
        CatalogOption("verificationCode", .verificationCode),
        CatalogOption("phone", .phone),
        CatalogOption("birthday", .birthday),
        CatalogOption("genderID", .genderID),
        CatalogOption("country", .country),
        CatalogOption("hearAboutus", .hearAboutus),
    ]

    private let states: [CatalogOption<TextEntryViewValidation>] = [
        CatalogOption("none", .none),
        CatalogOption("editing", .editing),
        CatalogOption("valid", .valid),
        CatalogOption("invalid", .invalid),
        CatalogOption("loading", .loading),
        CatalogOption("modifiable", .modifiable),
    ]

    var body: some View {
        CatalogPage(
            title: "TextEntryView",
            summary: "A labeled form field. The type sets the label, keyboard and secure entry; the validation state sets the icon on the right."
        ) {
            CatalogSection("Preview") {
                ExampleBox {
                    TextEntryView(
                        text: $text,
                        placeHolder: $placeholder,
                        validatationState: $validation,
                        validatationMessage: $message,
                        returnType: .constant(.done),
                        hasFocus: $hasFocus,
                        countryCode: .constant("98"),
                        genderID: .constant("Prefer not to say"),
                        birthday: .constant("1 Jan 1990"),
                        hearAboutUs: .constant("A friend"),
                        isAllowedToEdit: $isEditable,
                        type: type,
                        lostFocus: {},
                        done: {},
                        picker: {}
                    )
                    // TextEntryView only reads secure entry when it appears,
                    // so rebuild it whenever the type changes.
                    .id(type)
                }
            }

            CatalogSection("Configuration") {
                ConfigPanel {
                    HStack {
                        Text("Type")
                        Spacer()
                        Picker("Type", selection: $type) {
                            ForEach(types) { Text($0.name).tag($0.value) }
                        }
                        .pickerStyle(.menu)
                    }
                    HStack {
                        Text("Validation state")
                        Spacer()
                        Picker("Validation state", selection: $validation) {
                            ForEach(states) { Text($0.name).tag($0.value) }
                        }
                        .pickerStyle(.menu)
                    }
                    TextField("Placeholder", text: $placeholder)
                        .textFieldStyle(.roundedBorder)
                    Toggle("Editable", isOn: $isEditable)
                }
            }

            CatalogSection("Code") {
                CodeSnippet(code)
            }

            CatalogNote("Typing in the field resets the validation state to none.")
            CatalogNote("Known issues: the phone type shows only the country code, with no field to type in; country shows the country code instead of its name; the validation message is never displayed.", isWarning: true)
        }
    }

    private var typeName: String {
        types.first { $0.value == type }?.name ?? "email"
    }

    private var stateName: String {
        states.first { $0.value == validation }?.name ?? "none"
    }

    private var code: String {
        """
        // @State var state: TextEntryViewValidation = .\(stateName)
        TextEntryView(
            text: $text,
            placeHolder: $placeholder,
            validatationState: $state,
            validatationMessage: $message,
            returnType: .constant(.done),
            hasFocus: $hasFocus,
            isAllowedToEdit: .constant(\(isEditable)),
            type: .\(typeName),
            lostFocus: { },
            done: { }
        )
        """
    }
}

#Preview {
    NavigationView { TextEntryPage() }
}
