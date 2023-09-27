//
//  CourseListCell.swift
//  PutPutGolf
//
//  Created by Kevin Green on 9/23/23.
//

import SwiftUI

struct CourseListCell: View {
    var course: Course
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            Image(systemName: "photo")
                .resizable()
                .scaledToFit()
                .opacity(0.1)
            
            VStack(alignment: .leading) {
                HStack {
                    Image(systemName: "house.and.flag.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(.green)
                    Text("\(course.name)")
                        .font(.title)
                }
                
                HStack {
                    Image(systemName: "mappin.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(.red)
                    Text("\(course.address)")
                        .font(.title2)
                }
            }.frame(height: 200)
        }
    }
}


struct CourseListCell_Previews: PreviewProvider {
    static var previews: some View {
        CourseListCell(course: MockData.instance.courses.first!)
    }
}
