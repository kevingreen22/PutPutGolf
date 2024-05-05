//
//  CoursesList.swift
//  PutPutGolf
//
//  Created by Kevin Green on 10/7/23.
//

import SwiftUI

struct CoursesList: View {
    @EnvironmentObject var vm: CoursesMap.ViewModel

    var body: some View {
        List {
            ForEach(vm.coursesData) { course in
                Button {
                    vm.showNextCourse(course: course)
                } label: {
                    listRowView(course: course)
                }
                .padding(4)
                .listRowBackground(Color.clear)
            }
        }
        .listStyle(.plain)
    }
}

#Preview {
    @StateObject var coursesVM = CoursesMap.ViewModel()
    coursesVM.showCoursesList = true
    coursesVM.coursesData = MockData.instance.courses
    coursesVM.selectedCourse = MockData.instance.courses.first!
    
    return CoursesList().environmentObject(coursesVM)
}



// MARK: Private Components
extension CoursesList {
    
    fileprivate func listRowView(course: Course) -> some View {
        HStack {
            course.getImage
                .resizable()
                .scaledToFill()
                .frame(width: 45, height: 45)
                .clipShape(Circle())
            
            VStack(alignment: .leading) {
                Text(course.address)
                    .font(.headline)
                Text(course.difficulty.rawValue)
                    .font(.subheadline)
                    .foregroundStyle(Difficulty.color(for: course.difficulty))
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
    
}
