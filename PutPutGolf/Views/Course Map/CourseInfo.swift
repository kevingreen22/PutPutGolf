//
//  CourseInfo.swift
//  PutPutGolf
//
//  Created by Kevin Green on 9/23/23.
//

import SwiftUI

struct CourseInfo: View {
    @EnvironmentObject var navVM: NavigationStore
    @EnvironmentObject var coursesVM: CoursesViewModel
    @Binding var course: Course!
    @State private var courseImage: Image = Image("walnut_creek") /*Image(systemName: "photo")*/ /* Image("placeholder") */
    @State private var infoItem: InfoItem?
    
    init(course: Binding<Course?>) {
        _course = course
        
        if let course = course.wrappedValue, let data = course.imageData, let img = UIImage(data: data) {
            courseImage = Image(uiImage: img)
        }
        
        self.infoItem = infoItem
    }
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            courseImageHeader
                .overlay(alignment: .top) {
                    playCourseButton
                }
            stats
            courseRules
        }
        
        .sheet(item: $infoItem) { item in
            infoItemView(item: item)
                .presentationDetents([.height(300)])
                .presentationDragIndicator(.visible)
        }
    }
    
}

struct CourseInfo_Previews: PreviewProvider {
    static let mockData = MockData.instance
    
    static var previews: some View {
        CourseInfo(course: .constant(mockData.courses.first!))
            .environmentObject(CoursesViewModel(dataService: MockDataService(mockData: mockData)))
            .environmentObject(NavigationStore())
    }
}



struct InfoItem: Identifiable {
    var id = UUID()
    var title: String
    var text: InfoItemText
    var iconName: String
}

enum InfoItemText: String {
    case difficulty = "The level of difficulty of the course. There are 4 levels,\n \"●\"-easy,\n \"■\"-medium,\n \"▲\"-hard,\n \"♦︎\"-very hard\n Depending on your Putter's Golf Club experience level will depend on how challenging the course will be for you."
    
    case numOfHoles = "This denotes the total number of holes on the course. Not including \"Game Changer\" holes. Each hole will have it's par rating at the begining of the hole for your information as well as along the top of the score card."
    
    case numOfChallenges = "This denotes the total number of \"Game Changer\" holes on the course. Game Changers are unique putting challenges that add an extra layer of competition. These holes do not have numbers but are marked with checkered race flags. Each Game Changer hole will have instructions to tell you how to play and how the scoring is calculated. These holes can change the outcome of the game big time!"
}


extension CourseInfo {
    
    fileprivate var courseImageHeader: some View {
        courseImage
            .resizable()
            .scaledToFill()
            .overlay {
                Rectangle()
                    .fill(LinearGradient(colors: [.black,.clear,.clear], startPoint: .top, endPoint: .bottom))
            }
            .overlay(alignment: .topLeading) {
                Text("\(course.address)")
                    .font(.title)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .lineLimit(2)
                    .padding()
            }
            .overlay(alignment: .bottomLeading) {
                    Button {
                        coursesVM.getDirections()
                    } label: {
                        Image(systemName: "arrow.uturn.right.circle.fill")
                        Text("Go")
                            .font(.title3)
                            .fontWeight(.thin)
                    }
                    .buttonStyle(.borderedProminent)
                    .buttonBorderShape(.capsule)
                    .padding()
            }
    }
    
    fileprivate var playCourseButton: some View {
        Button {
            // Navigate to PlayerSetup here
            navVM.path.append(1)
            coursesVM.showCourseInfo = false
        } label: {
            Text("Play Course")
                .font(.largeTitle)
                .fontWeight(.semibold)
        }
        .controlSize(.large)
        .buttonStyle(.borderedProminent)
        .buttonBorderShape(.capsule)
        .shadow(radius: 10)
        .offset(y: 125)
    }
    
    fileprivate var stats: some View {
        HStack(alignment: .top) {
            difficultyCell(difficulty: course.difficulty, text: "\(course.difficulty.rawValue)", infoItem: $infoItem)
                .padding(.leading)
            
            Divider()
            Spacer()
            
            holeCell(iconName: "flag.circle.fill", text: "\(course.holes.count)", infoItem: $infoItem)
            
            Spacer()
            Divider()
            
            challengeInfoCell(iconName: "trophy.circle.fill", text: "\(course.challenges.count)", infoItem: $infoItem)
                .padding(.trailing)
        }

    }
    
    fileprivate var courseRules: some View {
        List {
            Section("Course Rules") {
                ForEach(course.rules, id: \.self) { rule in
                    Text("• \(rule)")
                }
            }
        }
        .listStyle(.sidebar)
        .frame(height: 1000)
        .scrollDisabled(true)
    }
    
    fileprivate func infoItemView(item: InfoItem) -> some View {
        ScrollView {
            HStack(alignment: .bottom) {
                Image(systemName: item.iconName)
                    .resizable()
                    .frame(width: 30, height: 30)
                    .offset(y: -3)
                
                Text(item.title)
                    .font(.title)
                    .padding(.top)
            }
            
            Text(item.text.rawValue)
                .font(.title3)
                .foregroundColor(.gray)
                .padding(.horizontal)
        }
    }
    
    fileprivate func difficultyCell(difficulty: Difficulty, text: String, infoItem: Binding<InfoItem?>) -> some View {
        VStack {
            Text("Difficulty")
                .foregroundStyle(Color.gray)
            
            Difficulty.icon(difficulty)
                .resizable()
                .scaledToFit()
                .frame(width: 50)
                .foregroundColor(Difficulty.color(for: difficulty))
            
            Text(text)
                .font(.title)
        }
        .onTapGesture {
            self.infoItem = InfoItem(title: "Difficulty Level", text: .difficulty, iconName: "diamond.circle.fill")
        }
    }
    
    fileprivate  func holeCell(iconName: String, text: String, infoItem: Binding<InfoItem?>) -> some View {
        VStack {
            Text("Holes")
                .foregroundStyle(Color.gray)
            
            Image(systemName: iconName)
                .resizable()
                .scaledToFit()
                .foregroundColor(.green)
                .frame(height: 50)
            
            Text(text)
                .font(.title)
        }
        .onTapGesture {
            self.infoItem = InfoItem(title: "Number Of Holes", text: InfoItemText.numOfHoles, iconName: "flag.circle.fill")
        }
    }
    
    fileprivate func challengeInfoCell(iconName: String, text: String, infoItem: Binding<InfoItem?>) -> some View {
        VStack {
            Text("Challenges")
                .foregroundStyle(Color.gray)
            
            Image(systemName: iconName)
                .resizable()
                .scaledToFit()
                .foregroundColor(.yellow)
                .frame(height: 50)
            
            Text(text)
                .font(.title)
        }
        .onTapGesture {
            self.infoItem = InfoItem(title: "Number of Game Changers", text: InfoItemText.numOfChallenges, iconName: "trophy.circle.fill")
        }
    }
    
}
