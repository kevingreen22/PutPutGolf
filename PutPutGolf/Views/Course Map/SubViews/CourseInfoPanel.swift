//
//  CourseInfoPanel.swift
//  PutPutGolf
//
//  Created by Kevin Green on 10/10/23.
//

import SwiftUI

struct CourseInfoPanel: View {
    @EnvironmentObject var vm: CoursesViewModel
    @EnvironmentObject var navVM: NavigationStore
    @Binding var course: Course
    
    var body: some View {
        HStack(alignment: .bottom, spacing: 0) {
            VStack(alignment: .leading, spacing: 16) {
                imageSection
                title
            }
                
            VStack(spacing: 8) {
                playCourseButton
                courseInfoButton
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 10)
            .fill(Material.ultraThinMaterial)
            .offset(y: 65)
        )
        .cornerRadius(10)
    }
}

struct CourseInfoPanel_Preview: PreviewProvider {
    static let mockData = MockData.instance
    
    static var previews: some View {
        ZStack {
            Color.green.ignoresSafeArea()
            CourseInfoPanel(course: .constant(mockData.courses[0]))
                .padding()
                .environmentObject(CoursesViewModel(coursesData: mockData.courses))
                .environmentObject(NavigationStore())
        }
    }
}




extension CourseInfoPanel {
    
    fileprivate var imageSection: some View {
        ZStack {
            course.getImage()
                .resizable()
                .clipShape(Circle())
                .frame(width: 120, height: 120)
        }
        .padding(6)
        .background(Color.white)
        .clipShape(Circle())
    }
    
    fileprivate var title: some View {
        VStack(alignment: .leading) {
            Text(course.address)
                .font(.title2)
                .fontWeight(.bold)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    fileprivate var playCourseButton: some View {
        Button {
            navVM.goto(.playerSetup)
        } label: {
            Text("Play Course")
                .font(.headline)
                .frame(width: 125, height: 35)
        }
        .buttonStyle(.borderedProminent)
        .buttonBorderShape(.capsule)
        
    }
    
    fileprivate var courseInfoButton: some View {
        Button {
            vm.showCourseInfo.toggle()
        } label: {
            Text("Course Info")
                .font(.headline)
                .frame(width: 125, height: 35)
        }
        .buttonStyle(.bordered)
        .buttonBorderShape(.capsule)
    }
    
}
