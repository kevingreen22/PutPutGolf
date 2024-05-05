//
//  LoadingButton.swift
//
//  Created by Kevin Green on 12/1/23.
//

import SwiftUI

struct LoadingButtonDemo: View {
    @State private var showLoader = false
    
    var body: some View {
        VStack {
            Button {
                withAnimation { showLoader.toggle() }
                DispatchQueue.main.asyncAfter(deadline: .now()+2) {
                    withAnimation { showLoader.toggle() }
                }
            } label: {
                Text("Button using modifier")
            }
            .withLoader($showLoader)
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
            
            
            ButtonWithLoader {
                try? await Task.sleep(nanoseconds: 2_000_000_000)
            } label: {
                Label("Button as View", systemImage: "person.fill")
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
        }
    }
}
#Preview {
    LoadingButtonDemo()
}




struct ButtonWithLoader<Label: View>: View {
    var action: ()async->Void
    var buttonRole: ButtonRole?
    var actionOptions = Set(ActionOptions.allCases)
    @ViewBuilder var label: ()->Label
    
    @State private var showProgressView: Bool = false
    @State private var isDisabled: Bool = false
    
    var body: some View {
        Button(role: buttonRole) {
            if actionOptions.contains(.disableButton) {
                isDisabled = true
            }
            
            Task {
                var progressViewTask: Task<Void, Error>?
                
                if actionOptions.contains(.showProgressView) {
                    progressViewTask = Task {
                        try await Task.sleep(nanoseconds: 150_000_000)
                        showProgressView = true
                    }
                }
                
                await action()
                progressViewTask?.cancel()
                
                isDisabled = false
                showProgressView = false
            }
        } label: {
            label()
                .opacity(showProgressView ? 0 : 1)
                .overlay {
                    if showProgressView {
                        ProgressView()
                    }
                }
        }
        .allowsHitTesting(!isDisabled)
    }
}


//extension ButtonWithLoader where Label == Text {
//    init(_ label: String, 
//         actionOptions: Set<ActionOptions> = Set(ActionOptions.allCases),
//         action: @escaping () async -> Void) {
//        self.init(action: action) {
//            Text(label)
//        }
//    }
//}
//
//extension ButtonWithLoader where Label == Image {
//    init(systemImageName: String, actionOptions: Set<ActionOptions> = Set(ActionOptions.allCases), action: @escaping () async -> Void) {
//        self.init(action: action) {
//            Image(systemName: systemImageName)
//        }
//    }
//}

extension ButtonWithLoader {
    enum ActionOptions: CaseIterable {
        case disableButton
        case showProgressView
    }
}







extension Button {
    
    func withLoader(_ showLoader: Binding<Bool>) -> some View {
        self
            .overlay {
                if showLoader.wrappedValue {
                    ProgressView()
                }
            }
            .allowsHitTesting(showLoader.wrappedValue ? false : true)
    }
    
}
