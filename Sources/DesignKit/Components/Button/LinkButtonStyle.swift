//
//  LinkButtonStyle.swift
//  DesignKit
//
//  Created by mohsen Hashemloo on 1405/6/26.
//
import SwiftUI

struct LinkButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .font(.body)
            .foregroundColor(.blue)
            .opacity(configuration.isPressed ? 0.8 : 1.0)
    }
}
