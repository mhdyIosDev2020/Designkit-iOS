//
//  StatusView.swift
//  DesignKit
//
//  Created by mohsen Hashemloo on 1405/6/26.
//
import SwiftUI

struct StatusView : View {

    public var validatationState: TextEntryViewValidation
    public var type : TextEntryViewType
    @Binding public var isSecure: Bool
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
            EmptyView()
        }
    }
}
