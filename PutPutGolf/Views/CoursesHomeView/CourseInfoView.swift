//
//  CourseInfoView.swift
//  PutPutGolf
//
//  Created by Kevin Green on 9/23/23.
//

import SwiftUI

struct CourseInfoView: View {
    var course: Course
    
    var body: some View {
        Text("\(course.name)")
    }
}

struct CourseInfoView_Previews: PreviewProvider {
    static var previews: some View {
        CourseInfoView(course: MockData.shared.courses.first!)
    }
}
