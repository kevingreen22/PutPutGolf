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
        ScrollView(showsIndicators: false) {
            ZStack { // Header
                Image(systemName: "photo")
                    .resizable()
                    .scaledToFill()
                    .frame(height: 300)
                    .opacity(0.3)
                
                VStack {
                    Spacer()
                    Text("\(course.name)")
                        .font(.largeTitle)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                }
            }
            
            List { // Stats
                DifficultyCell(difficulty: course.difficulty, text: "\(course.difficulty.rawValue)")
                HoleCell(iconName: "flag.circle.fill", text: "\(course.holes.count) Hole")
                ChallengeInfoCell(iconName: "trophy.circle.fill", text: "\(course.challenges.count) Challenge")
            }.frame(height: 500)
        }
        .overlay(alignment: .bottom) {
            Button {
                //
            } label: {
                Text("Play Course")
                    .font(.largeTitle)
                    .fontWeight(.semibold)
            }
            .controlSize(.large)
            .buttonStyle(.borderedProminent)
            .buttonBorderShape(.capsule)
        }
    }
}

struct CourseInfoView_Previews: PreviewProvider {
    static var previews: some View {
        CourseInfoView(course: MockData.shared.courses.first!)
    }
}




struct DifficultyCell: View {
    var difficulty: Difficulty
    var text: String
    
    var body: some View {
        HStack {
            switch difficulty {
            case .easy:
                difficultyIcon("circle.circle.fill")
                    .foregroundColor(.white)
            case .medium:
                difficultyIcon("square.circle.fill")
                    .foregroundColor(.blue)
            case .hard:
                difficultyIcon("triangle.circle.fill")
                    .foregroundColor(.red)
            case .veryHard:
                difficultyIcon("diamond.circle.fill")
                    .foregroundColor(.black)
            }
            
            Text(text)
        }.padding(.horizontal)
    }
    
    private func difficultyIcon(_ name: String) -> some View {
        Image(systemName: name)
            .resizable()
            .scaledToFit()
            .frame(height: 50)
    }
}


struct HoleCell: View {
    var iconName: String
    var text: String
    
    var body: some View {
        HStack {
            Image(systemName: iconName)
                .resizable()
                .scaledToFit()
                .foregroundColor(.green)
                .frame(height: 50)
            
            Text(text)
                .font(.title)
        }.padding(.horizontal)
    }
}


struct ChallengeInfoCell: View {
    var iconName: String
    var text: String
    
    var body: some View {
        HStack {
            Image(systemName: iconName)
                .resizable()
                .scaledToFit()
                .foregroundColor(.yellow)
                .frame(height: 50)
            
            Text(text)
                .font(.title)
        }.padding(.horizontal)
    }
}



