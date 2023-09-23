//
//  CourseInfoView.swift
//  PutPutGolf
//
//  Created by Kevin Green on 9/23/23.
//

import SwiftUI

struct CourseInfoView: View {
    var course: Course
    @State var infoItem: InfoItem?
    
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
                    DifficultyCell(difficulty: course.difficulty, text: "\(course.difficulty.rawValue)", infoItem: $infoItem)
                    
                    HoleCell(iconName: "flag.circle.fill", text: "\(course.holes.count)", infoItem: $infoItem)
                    
                    ChallengeInfoCell(iconName: "trophy.circle.fill", text: "\(course.challenges.count)", infoItem: $infoItem)
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
        
        .sheet(item: $infoItem) { item in
            InfoItemView(item: item)
                .presentationDetents([.height(300)])
        }
    }
}

struct CourseInfoView_Previews: PreviewProvider {
    static var previews: some View {
        CourseInfoView(course: MockData.shared.courses.first!)
    }
}



struct InfoItem: Identifiable {
    var id = UUID()
    var title: String
    var text: InfoItemText
}

struct InfoItemView: View {
    var item: InfoItem
    
    var body: some View {
        ScrollView {
            Text(item.title)
                .font(.title)
                .padding(.top)
            
            Text(item.text.rawValue)
                .font(.title3)
                .foregroundColor(.gray)
                .padding()
        }
    }
}

enum InfoItemText: String {
    case difficulty = "The level of difficulty of the course. There are 4 levels, easy, medium, hard, and very hard. Depending on your Putter's experience level will depend on how challenging the course will be for you."
    
    case numOfHoles = "This denotes the total number of holes on the course. Not including \"Game Changer\" holes. Each hole will have it's par rating at the begining of the hole for your information as well as along the top of the score card."
    
    case numOfChallenges = "This denotes the total number of \"Game Changer\" holes on the course. These holes are scored in different ways (i.e. Timed, Race, Closest, etc.). Each Game Changer hole will have instructions to tell you how to play and how the scoring is calculated. These holes can change the outcome of the game big time!"
}





struct DifficultyCell: View {
    var difficulty: Difficulty
    var text: String
    @Binding var infoItem: InfoItem?
    
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
                self.infoItem = InfoItem(title: "Difficulty Level", text: .difficulty)
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
    @Binding var infoItem: InfoItem?
    
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
                self.infoItem = InfoItem(title: "Number Of Holes", text: InfoItemText.numOfHoles)
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
    @Binding var infoItem: InfoItem?
    
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
                self.infoItem = InfoItem(title: "Number of Game Changers", text: InfoItemText.numOfChallenges)
            } label: {
                Image(systemName: "info.circle")
                    .foregroundColor(.blue)
            }
        }
    }
}





