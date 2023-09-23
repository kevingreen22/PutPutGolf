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
                    .overlay(alignment: .bottomLeading) {
                        Text("\(course.name)")
                            .font(.largeTitle)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .lineLimit(2)
                            .padding(.leading)
                    }
            }
                        
            List {
                Section("Course Stats") {
                    DifficultyCell(difficulty: course.difficulty, text: "\(course.difficulty.rawValue)")
                    
                    HoleCell(iconName: "flag.circle.fill", text: "\(course.holes.count)")
                    
                    ChallengeInfoCell(iconName: "trophy.circle.fill", text: "\(course.challenges.count)")
                }
                
                Section("Course Rules") {
                    ForEach(course.rules, id: \.self) { rule in
                        Text("• \(rule)")
                    }
                }
            }
            .listStyle(.sidebar)
            .frame(height: 800)
            
            
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
                    .foregroundColor(.green)
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
                .font(.title)
            
            Spacer()
            
            Button {
                
            } label: {
                Image(systemName: "info.circle")
                    .foregroundColor(.blue)
            }
        }
    }
    
    private func difficultyIcon(_ name: String) -> some View {
        Image(systemName: name)
            .resizable()
            .scaledToFit()
            .frame(height: 50)
            .padding(.trailing)
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
                .padding(.trailing)
            
            Text(text)
                .font(.title)
            
            Spacer()
            
            Button {
                
            } label: {
                Image(systemName: "info.circle")
                    .foregroundColor(.blue)
            }
        }
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
                .padding(.trailing)
            
            Text(text)
                .font(.title)
            
            Spacer()
            
            Button {
                
            } label: {
                Image(systemName: "info.circle")
                    .foregroundColor(.blue)
            }
        }
    }
}



