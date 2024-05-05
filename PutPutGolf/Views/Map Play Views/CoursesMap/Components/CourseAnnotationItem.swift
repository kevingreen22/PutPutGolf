//
//  CourseAnnotationItem.swift
//  PutPutGolf
//
//  Created by Kevin Green on 11/11/23.
//

import SwiftUI

struct CourseAnnotationItem: View {
    
    var body: some View {
        Circle()
            .stroke(.black, lineWidth: 3)
            .overlay {
                Image("golf_ball")
                    .resizable()
                    .scaledToFill()
                    .saturation(1.0)
                    .clipShape(Circle())
                    .padding(3)
            }
            .background(Color.white.clipShape(Circle()))
            .frame(width: 50, height: 50)
    }
}

#Preview {
    CourseAnnotationItem()
}

