//
//  CoursesMapView.swift
//  PutPutGolf
//
//  Created by Kevin Green on 9/27/23.
//

import SwiftUI



struct CoursesMapView: View {
    @StateObject private var vm: CoursesViewModel
    @State private var screenSize: CGSize = .zero
    
    init(url: URL?) {
        _vm = StateObject(wrappedValue: CoursesViewModel(url: url))
    }
    
    var body: some View {
        ZStack {
            Color.green.edgesIgnoringSafeArea(.top)
            
            CourseMapBallAndClubIcon(screenSize: $screenSize)
                .environmentObject(vm)
            
            ForEach(0..<vm.coursesData.count) { index in
                CourseMapIcon(placement: CoursesMapInfo.iconPlacement[index])
                    .environmentObject(vm)
            }
        }
        
        .sheet(isPresented: $vm.showCourseInfo) {
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




public struct CoursesMapInfo {
    static var iconPlacement: [(RotationDegrees, CGPoint)] = [
        (.left,iconPositions[0]),
        (.leftMid,iconPositions[1]),
        (.rightMid,iconPositions[2]),
        (.right,iconPositions[3])
    ]
    
    static private var iconPositions: [CGPoint] = [
        CGPoint(x: 70, y: 500),
        CGPoint(x: 120, y: 700),
        CGPoint(x: 300, y: 700),
        CGPoint(x: 365, y: 500)
    ]
    
    static private var degrees: [RotationDegrees] = [.none,.left,.leftMid,.rightMid,.right]
    
    public enum RotationDegrees: Double {
        case none = 0
        case left = 27
        case leftMid = 10.0
        case rightMid = -10.0
        case right = -27
    }
}

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

struct CourseMapIcon: View {
    @EnvironmentObject var vm: CoursesViewModel
    var placement: (CoursesMapInfo.RotationDegrees, CGPoint)
    
    var body: some View {
        Circle()
            .foregroundColor(.gray)
            .frame(width: 100, height: 100)
            .position(placement.1)
            .onTapGesture {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.6, blendDuration: 1)) {
                    vm.rotation = placement.0
                    vm.showCourseInfo = true
                }
            }
    }
}


struct SizePreferenceKey: PreferenceKey {
    static var defaultValue: CGSize = .zero
    static func reduce(value: inout CGSize, nextValue: () -> CGSize) {
        value = nextValue()
    }
}
