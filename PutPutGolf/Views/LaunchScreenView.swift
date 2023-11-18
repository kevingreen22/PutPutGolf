//
//  LaunchScreenView.swift
//  PutPutGolf
//
//  Created by Kevin Green on 11/17/23.
//

import SwiftUI

struct LaunchScreenView: View {
    
    init() {
        print("\(type(of: self)).\(#function)")
    }
    
    
    var body: some View {
        VStack {
            Image("putter_banner")
                .resizable()
                .scaledToFit()
                .padding()
                
            ProgressView()
        }
        .transition(.opacity)
    }

}

#Preview {
    LaunchScreenView()
}






