//
//  LoadingButtonDemo.swift
//  PutPutGolf
//
//  Created by Kevin Green on 12/1/23.
//

import SwiftUI

struct LoadingButtonDemo: View {
    @State private var showLoader1 = false
    @State private var showLoader2 = false
    
    var body: some View {
        VStack {
            Button {
                withAnimation {
                    showLoader1.toggle()
                }
            } label: {
                Text("Click Me")
            }
            .withLoader($showLoader1)
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
            
            
            ButtonWithLoader(showLoader: $showLoader2) {
                withAnimation {
                    showLoader2.toggle()
                }
            } content: {
                Text("Click Me")
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)

            
        }
    }
}

#Preview {
    LoadingButtonDemo()
}





extension Button {
    
    func withLoader(_ showLoader: Binding<Bool>) -> some View {
        self
            .overlay {
                if showLoader.wrappedValue {
                    ProgressView()
                        .allowsHitTesting(false)
                }
            }
    }
    
}



struct ButtonWithLoader<Label>: View where Label: View {
    @Binding var showLoader: Bool
    var buttonRole: ButtonRole?
    var action: ()->Void
    @ViewBuilder var content: Label
    
    var body: some View {
        Button(role: buttonRole) {
            withAnimation {
                showLoader.toggle()
            }
            action()
        } label: {
            if showLoader {
                ProgressView()
            } else {
                content
            }
        }
    }
    
}
