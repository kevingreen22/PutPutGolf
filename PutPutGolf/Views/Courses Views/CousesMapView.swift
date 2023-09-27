//
//  CoursesMapView.swift
//  PutPutGolf
//
//  Created by Kevin Green on 9/27/23.
//

import SwiftUI

public struct CoursesMapInfo {
    var degrees: [Degrees] = [.left,.leftMid,.rightMid,.right]
    
    enum Degrees: Double {
        case left = 27
        case leftMid = 10.0
        case rightMid = -10.0
        case right = -27
    }
}


struct CoursesMapView: View {
    @StateObject private var vm: CoursesViewModel
    @State private var rotation: CoursesMapInfo.Degrees = .left
    @State private var screenSize: CGSize = .zero
    @State private var title: String?
    @State private var showCourseInfo: Bool = false
    
    
    init(url: URL?) {
        _vm = StateObject(wrappedValue: CoursesViewModel(url: url))
    }
    
    var body: some View {
        ZStack {
            Color.green.edgesIgnoringSafeArea(.top)
            
            Circle()
                .foregroundColor(.blue)
                .frame(width: 200, height: 200)
                .background {
                    Rectangle()
                        .foregroundColor(.gray)
                        .frame(width: 20, height: 400)
                        .rotationEffect(.degrees(rotation.rawValue))
                }
                .overlay {
                    Text("\(title ?? "Select a Course")")
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
            
            
            Circle()
                .foregroundColor(.gray)
                .frame(width: 100, height: 100)
                .position(x: 70, y: 500)
                .onTapGesture {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.6, blendDuration: 1)) {
//                        self.selectedCourse = MockData.instance.courses[0]
                        vm.setSelectedCourse()
                        rotation = .left
                        title = vm.selectedCourse?.name
                        showCourseInfo = true
                    }
                }
            
            Circle()
                .foregroundColor(.gray)
                .frame(width: 100, height: 100)
                .position(x: 120, y: 700)
                .onTapGesture {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.6, blendDuration: 1)) {
//                        self.selectedCourse = MockData.instance.courses[1]
                        vm.setSelectedCourse()
                        rotation = .leftMid
                        title = vm.selectedCourse?.name
                        showCourseInfo = true
                    }
                }
            
            Circle()
                .foregroundColor(.gray)
                .frame(width: 100, height: 100)
                .position(x: 300, y: 700)
                .onTapGesture {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.6, blendDuration: 1)) {
//                        self.selectedCourse = MockData.instance.courses[2]
                        vm.setSelectedCourse()
                        rotation = .rightMid
                        title = vm.selectedCourse?.name
                        showCourseInfo = true
                    }
                }
            
            Circle()
                .foregroundColor(.gray)
                .frame(width: 100, height: 100)
                .position(x: 365, y: 500)
                .onTapGesture {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.6, blendDuration: 1)) {
//                        self.selectedCourse = MockData.instance.courses[3]
                        vm.setSelectedCourse()
                        rotation = .right
                        title = vm.selectedCourse?.name
                        showCourseInfo = true
                    }
                }
        }
        
        .sheet(isPresented: $showCourseInfo) {
            CourseInfoView(course: $vm.selectedCourse)
                .presentationDetents([
                    .height(550),
                    .height(300),
                    .height(70),
                ])
                .presentationBackgroundInteraction(.enabled)
                .presentationCornerRadius(30)
        }
        
        .overlay(
            GeometryReader { proxy in
                Color.clear.preference(key: SizePreferenceKey.self, value: proxy.size)
            }
        )
        .onPreferenceChange(SizePreferenceKey.self) { value in
            screenSize = value
        }
    }
}

struct CoursesMapView_Previews: PreviewProvider {
    static var previews: some View {
        CoursesMapView(url: nil)
    }
}





struct SizePreferenceKey: PreferenceKey {
    static var defaultValue: CGSize = .zero
    static func reduce(value: inout CGSize, nextValue: () -> CGSize) {
        value = nextValue()
    }
}
