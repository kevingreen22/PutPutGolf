//
//  golfBallLoader.swift
//  PutPutGolf
//
//  Created by Kevin Green on 2/22/24.
//

import SwiftUI

struct golfBallLoader: View {
    @State private var rotation: Angle = .zero
    var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        Image("golf_ball")
            .resizable()
            .frame(width: 60, height: 60)
            .rotationEffect(rotation, anchor: .center)
            .animation(.linear.speed(0.3).repeatForever(autoreverses: false), value: rotation)
            .onReceive(timer, perform: { _ in
                rotation = .degrees(360)
            })
    }
}

#Preview {
    golfBallLoader()
}
