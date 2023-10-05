//
//  CourseMapBallAndClubIcon.swift
//  PutPutGolf
//
//  Created by Kevin Green on 9/28/23.
//

import SwiftUI

struct CourseMapBallAndClubIcon: View {
    @EnvironmentObject var vm: CoursesViewModel
    @Binding var screenSize: CGSize
    
    var body: some View {
        Circle()
            .foregroundColor(.blue)
            .frame(width: 200, height: 200)
            .background {
                Rectangle()
                    .foregroundColor(.gray)
                    .frame(width: 20, height: 400)
                    .rotationEffect(.degrees(vm.rotation.rawValue))
            }
            .overlay {
                Text("\(vm.title ?? "Select a Course")")
                    .font(.largeTitle)
                    .foregroundColor(.white)
                    .frame(width: 300)
                    .padding()
                    .background{
                        Image(systemName: "rectangle.fill")
                            .resizable()
                            .foregroundColor(.red)
                    }
            }
            .position(x: screenSize.width/2, y: screenSize.height/4)
    }
}


struct CourseMapBallAndClubIcon_Previews: PreviewProvider {
    static var previews: some View {
//        CourseMapBallAndClubIcon(screenSize: .constant(CGSize(width: 400, height: 1000)))
//            .environmentObject(CoursesViewModel(url: nil))
        CoursesMap()
            .environmentObject(CoursesViewModel(url: nil))
            .environmentObject(NavigationStore())
    }
}
