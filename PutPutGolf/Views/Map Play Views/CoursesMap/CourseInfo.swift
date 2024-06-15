//
//  CourseInfo.swift
//  PutPutGolf
//
//  Created by Kevin Green on 9/23/23.
//

import SwiftUI

struct CourseInfo: View {
    @EnvironmentObject var navStore: NavigationStore
    @EnvironmentObject var coursesVM: CoursesMap.ViewModel
    
    @State private var courseImage: Image = Image("golf_course")
    @State private var usingCourseImage = false
    @State private var infoItem: InfoItem?
    
    init() {
        print("\(type(of: self)).\(#function)")
        self.infoItem = infoItem
    }
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            courseImageHeader
                .overlay(alignment: .top) {
                    playCourseButton
                }
            courseStats
            List {
                hours
                courseRules
            }
            .listStyle(.sidebar)
            .frame(minHeight: 1300)
        }
        
        .sheet(item: $infoItem) { item in
            infoItemView(item: item)
                .presentationDetents([.height(300)])
                .presentationDragIndicator(.visible)
                .cornerRadius(30)
        }
        
        .onAppear {
            if let data = $coursesVM.selectedCourse.wrappedValue.imageData, let img = UIImage(data: data) {
                courseImage = Image(uiImage: img)
                usingCourseImage = true
            }
        }
    }
}

#Preview {
    let coursesVM = CoursesMap.ViewModel()
    coursesVM.coursesData = MockData.instance.courses
    coursesVM.selectedCourse  = MockData.instance.courses.first!
    
    return CourseInfo()
        .environmentObject(coursesVM)
        .environmentObject(NavigationStore())
}



// MARK: Private Components
extension CourseInfo {
    
    fileprivate var courseImageHeader: some View {
        courseImage
            .resizable()
            .scaledToFill()
            .grayscale(usingCourseImage ? 0 : 1)
            .overlay {
                Rectangle()
                    .fill(LinearGradient(colors: [.black,.clear,.clear], startPoint: .top, endPoint: .bottom))
            }
            .overlay(alignment: .topLeading) {
                Text("\(coursesVM.selectedCourse.address)")
                    .font(.title)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .lineLimit(2)
                    .padding()
                    .padding(.leading, 16)
            }
            .overlay(alignment: .bottomLeading) {
                    Button {
                        coursesVM.getDirections()
                    } label: {
                        Label("Directions", systemImage: "arrow.uturn.right.circle.fill")
                    }
                    .buttonStyle(.bordered)
                    .background(Material.ultraThinMaterial)
                    .clipShape(.capsule)
                    .padding()
            }
    }
    
    fileprivate var playCourseButton: some View {
        Button {
            // Navigate to PlayerSetup here
            coursesVM.showCourseInfo = false
            navStore.goto(.playerSetup)
        } label: {
            HStack {
                Image("golf_ball")
                    .resizable()
                    .frame(width: 30, height: 30)
                Text("Play Course")
                    .font(.title)
                    .fontWeight(.semibold)
            }
        }
        .controlSize(.large)
        .buttonStyle(.borderedProminent)
        .buttonBorderShape(.capsule)
        .shadow(radius: 10)
        .offset(y: 125)
    }
    
    fileprivate var courseStats: some View {
        HStack {
            difficultyCell(
                difficulty: coursesVM.selectedCourse.difficulty,
                text: "\(coursesVM.selectedCourse.difficulty.rawValue)",
                infoItem: $infoItem
            )
            Spacer()
            Divider()
            Spacer()
            holeCell(iconName: "flag.circle.fill", text: "\(coursesVM.selectedCourse.holes.count)", infoItem: $infoItem)
            Spacer()
            Divider()
            Spacer()
            challengeInfoCell(iconName: "trophy.circle.fill", text: "\(coursesVM.selectedCourse.challenges?.count ?? 0)", infoItem: $infoItem)
        }
        .padding(.horizontal, 20)
    }
    
    fileprivate func difficultyCell(difficulty: Difficulty, text: String, infoItem: Binding<InfoItem?>) -> some View {
        VStack {
            Text("Difficulty")
                .foregroundStyle(Color.primary)
                .fontWeight(.semibold)
            
            Difficulty.icon(difficulty)
                .resizable()
                .scaledToFit()
                .frame(width: 50)
                .foregroundColor(Difficulty.color(for: difficulty))
            
            Text(text)
                .font(.title3)
                .foregroundStyle(Color.gray)
        }
        .onTapGesture {
            self.infoItem = InfoItem(title: "Difficulty Level", text: .difficulty, iconName: "diamond.circle.fill")
        }
    }
    
    fileprivate  func holeCell(iconName: String, text: String, infoItem: Binding<InfoItem?>) -> some View {
        VStack {
            Text("Holes")
                .foregroundStyle(Color.primary)
                .fontWeight(.semibold)
            
            Image(systemName: iconName)
                .resizable()
                .scaledToFit()
                .foregroundColor(.green)
                .frame(height: 50)
            
            Text(text)
                .font(.title2)
                .foregroundStyle(Color.gray)
        }
        .onTapGesture {
            self.infoItem = InfoItem(title: "Holes", text: InfoItemText.numOfHoles, iconName: "flag.circle.fill")
        }
    }
    
    fileprivate func challengeInfoCell(iconName: String, text: String, infoItem: Binding<InfoItem?>) -> some View {
        VStack {
            Text("Challenges")
                .foregroundStyle(Color.primary)
                .fontWeight(.semibold)
            
            Image(systemName: iconName)
                .resizable()
                .scaledToFit()
                .foregroundColor(.yellow)
                .frame(height: 50)
            
            Text(text)
                .font(.title2)
                .foregroundStyle(Color.gray)
        }
        .onTapGesture {
            self.infoItem = InfoItem(title: "Game Changers", text: InfoItemText.numOfChallenges, iconName: "trophy.circle.fill")
        }
    }
    
    fileprivate var hours: some View {
        Section("Hours") {
            VStack(alignment: .leading) {
                ForEach(coursesVM.selectedCourse.hours, id: \.self) { time in
                    if time != coursesVM.selectedCourse.hours.last {
                        let dayTime = time.split(separator: " ", maxSplits: 1)
                        HStack {
                            Text("\(String(dayTime.first ?? "??"))")
                                .foregroundStyle(Color.gray)
                            Text(String(dayTime.last ?? "??"))
                        }
                    } else {
                        Text("\(time)")
                            .padding(.vertical)
                    }
                }
            }
        }
    }
    
    fileprivate var courseRules: some View {
        Section("Course Rules") {
            ForEach(coursesVM.selectedCourse.rules, id: \.self) { rule in
                Text("• \(rule)")
            }
        }
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
                    .padding(.leading, 40)
            }
            
            Text(item.text.rawValue)
                .font(.title3)
                .foregroundColor(.gray)
                .padding(.horizontal)
        }
    }
    
}



// MARK: InfoItem Model
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

