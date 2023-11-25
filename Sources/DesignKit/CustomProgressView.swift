//
//  CustomProgressView.swift
//  DesignKit
//
//  Created by Mahdi_iOS on 09/09/23.
//

import SwiftUI

public struct CustomProgressView: View {
    @Binding public  var isVisible: Bool
    public var barColor: Color = .red
    public var timeInterval: TimeInterval = 5
    @State public var drawingWidth = true
    @State public var title = ""
    @State public var description = ""
    @State private var progressValue = 0.0
    @State private var progress = 0.0
    public init(isVisible: Binding<Bool>, barColor: Color, timeInterval: TimeInterval, drawingWidth: Bool = true, title: String, descriptionValue: String) {
        self.title = title
        print("title init \(title)")
        self.description = descriptionValue
        self.barColor = barColor
        self.timeInterval = timeInterval
        self.drawingWidth = drawingWidth
        self._isVisible = isVisible
       
        
    }
    public var body: some View {
        VStack{
            
            VStack(alignment: .leading) {
                HStack{
                    
                    VStack{
                        Text(title).font(.lato(.bold,size: 15))
                        Text(description).font(.lato(.regular,size: 12))
                        
                    }
                }
                
                
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 3)
                        .fill(Color(.systemGray6))
                        .frame(height: 5)
                    RoundedRectangle(cornerRadius: 3)
                        .fill(.red.gradient)
                        .frame(width: drawingWidth ? UIScreen.main.bounds.width - 32 : 0, alignment: .leading)
                    
//                        .animation(.easeInOut(duration: timeInterval).repeatForever(autoreverses: false), value: drawingWidth)
                    
                }
                .frame( height: 4)
                .onAppear {
                    withAnimation {
                        drawingWidth.toggle()
                    }
                    
                }
                
                
                Spacer()
                
            }.frame(height: 50)
            
        }.ignoresSafeArea(.all)
    }
}

struct CustomProgressView_Previews: PreviewProvider {
    static var previews: some View {
        CustomProgressView(isVisible: .constant(true), barColor: .red, timeInterval: 5, title: "title", descriptionValue: "des")
        
    }
}
