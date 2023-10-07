//
//  CoursesList.swift
//  PutPutGolf
//
//  Created by Kevin Green on 10/7/23.
//

import SwiftUI

struct CoursesList: View {
    @EnvironmentObject var vm: CoursesViewModel

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
    CoursesList()
        .environmentObject(CoursesViewModel(url: nil))
}





extension CoursesList {
    
    func listRowView(course: Course) -> some View {
        HStack {
            course.getImage()
                .resizable()
                .scaledToFill()
                .frame(width: 45, height: 45)
                .clipShape(Circle())
            
            VStack(alignment: .leading) {
                Text(course.name)
                    .font(.headline)
                Text(course.difficulty.rawValue)
                    .font(.subheadline)
                    .foregroundStyle(getColor(for: course.difficulty))
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
    
    
    fileprivate func getColor(for difficulty: Difficulty) -> Color {
        switch difficulty {
        case .easy: Color.green
        case .medium: Color.primary
        case .hard: Color.yellow
        case .veryHard: Color.red
        }
    }
        
}
