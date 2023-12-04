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
        ZStack {
            Image("golf_course")
                .resizable()
                .ignoresSafeArea()
            
            VStack {
                Image("logo_banner")
                    .resizable()
                    .scaledToFit()
                    .padding()
                Spacer(minLength: 200)
                ProgressView()
            }
            .transition(.opacity)
        }
    }

}

#Preview {
    LaunchScreenView()
}






