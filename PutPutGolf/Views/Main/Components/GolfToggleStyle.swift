//
//  GolfToggleStyle.swift
//  PutPutGolf
//
//  Created by Kevin Green on 6/15/24.
//

import SwiftUI

struct GolfToggleStyle: ToggleStyle {
    @State private var handleRect: CGRect = .zero
    
    func makeBody(configuration: Configuration) -> some View {
        GeometryReader { proxy in
            ZStack {
                Capsule()
                    .fill(configuration.isOn ? Color.accentColor : Color.gray)
                    .bordered(shape: Capsule(), color: Color.accentColor, lineWidth: 1)
                
                    .overlay(alignment: .leading) {
                        Image(systemName: "checkmark")
                            .resizable()
                            .scaledToFit()
                            .scaleEffect(0.4)
                            .foregroundStyle(Color.white)
                            .opacity(configuration.isOn ? 1 : 0)
                    }
                
                    .overlay(alignment: .trailing) {
                        Image(systemName: "xmark")
                            .resizable()
                            .scaledToFit()
                            .scaleEffect(0.4)
                            .foregroundStyle(Color.red)
                            .opacity(configuration.isOn ? 0 : 1)
                    }
                
                    .overlay(alignment: .center) {
                        Image("golf_ball")
                            .resizable()
                            .scaledToFit()
                            .shadow(radius: 3)
                            .padding(.vertical, 2)
                            .padding(.leading, 2)
                            .padding(.trailing, 1)
                            .rectReader($handleRect, in: .local)
                            .offset(x: configuration.isOn ? proxy.size.width/2-handleRect.size.width/2 : -proxy.size.width/2+handleRect.size.width/2)
                            .onTapGesture {
                                configuration.isOn.toggle()
                            }
                            .gesture(
                                DragGesture()
                                    .onEnded { value in
                                        configuration.isOn.toggle()
                                    }
                            )
                    }
                configuration.label
            }.animation(.easeInOut(duration: 0.15), value: configuration.isOn)
        }.frame(height: 34)
    }
}

#Preview {
    @State var on: Bool = false
    return Toggle("", isOn: $on)
        .toggleStyle(GolfToggleStyle())
        .frame(width: 70)
        .scaleEffect(4)
}
