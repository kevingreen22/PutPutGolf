//
//  CourseMapIcon.swift
//  PutPutGolf
//
//  Created by Kevin Green on 9/28/23.
//

import SwiftUI

struct CourseMapIcon: View {
    @EnvironmentObject var vm: CoursesViewModel
    var image: Image
    var placement: (CoursesMapInfo.RotationDegrees, CGPoint)
    
    var body: some View {
//        Circle()
//            .foregroundColor(.gray)
//            .frame(width: 100, height: 100)
//            .position(placement.1)
//            .onTapGesture {
//                withAnimation(.spring(response: 0.3, dampingFraction: 0.6, blendDuration: 1)) {
//                    vm.rotation = placement.0
//                    vm.showCourseInfo = true
//                }
//            }
        ZStack {
            image
                .resizable()
                .clipShape(Circle())
                .frame(width: 100, height: 100)
                .position(placement.1)
                .onTapGesture {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.6, blendDuration: 1)) {
                        vm.rotation = placement.0
                        vm.showCourseInfo = true
                        print("map icon tapped")
                    }
                }
                .shadow(color: .gray, radius: 5)
            
            Circle()
                .strokeBorder(.gray.gradient, lineWidth: 4)
                .frame(width: 100, height: 100)
                .position(placement.1)
        }
    }
}

struct CourseMapIcon_Previews: PreviewProvider {
    static var previews: some View {
        CourseMapIcon(image: MockData.instance.courses.first!.getImage(), placement: CoursesMapInfo.iconPlacement[0])
            .environmentObject(CoursesViewModel(url: nil))
    }
}
