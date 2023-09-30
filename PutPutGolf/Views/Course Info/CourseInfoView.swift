//
//  CourseInfoView.swift
//  PutPutGolf
//
//  Created by Kevin Green on 9/23/23.
//

import SwiftUI

struct CourseInfoView: View {
    @EnvironmentObject var vm: CoursesViewModel
    @Binding var course: Course!
    @State private var image: Image = Image(systemName: "photo") /* Image("placeholder") */
    @State private var infoItem: InfoItem?
    
    init(course: Binding<Course?>) {
        _course = course
        
        if let course = course.wrappedValue, let data = course.imageData, let img = UIImage(data: data) {
            image = Image(uiImage: img)
        }
        
        self.infoItem = infoItem
    }
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            image
                .resizable()
                .scaledToFill()
                .frame(height: 300)
                .opacity(0.3)
                .overlay(alignment: .topLeading) {
                    VStack(alignment: .leading) {
                        Text("\(course.name)")
                            .font(.largeTitle)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .lineLimit(2)
                            .padding(.leading)
                        Button {
                            getDirections()
                        } label: {
                            Text(course.address)
                                .font(.title2)
                                .fontWeight(.thin)
                                .padding(.leading)
                        }
                    }
                }
                .overlay(alignment: .top) {
//                    NavigationLink(value: course) {
//                        Text("Play Course")
//                            .font(.largeTitle)
//                            .fontWeight(.semibold)
//                            .controlSize(.large)
//                            .buttonStyle(.borderedProminent)
//                            .buttonBorderShape(.capsule)
//                            .shadow(radius: 10)
//                    }
//                    .offset(y: 125)

                    Button {
                        // Navigate to PlayerSetup here
                        vm.path.append(course)
                        vm.showCourseInfo = false
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
                .padding(.top)
            
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
            .frame(height: 1000)
            .scrollDisabled(true)
        }
        
        .sheet(item: $infoItem) { item in
            InfoItemView(item: item)
                .presentationDetents([.height(300)])
                .presentationDragIndicator(.visible)
        }
    }
    
    
    fileprivate func getDirections() {
        if course != nil {
            let longitude = course!.location[1]
            let latitude = course!.location[0]
            let directionsURL = URL(string: "maps://?saddr=&daddr=\(longitude),\(latitude)")
            if let url = directionsURL, UIApplication.shared.canOpenURL(url) {
                print("\(type(of: self)).\(#function) - opening maps with directions: \(url)")
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
    }
    
}

struct CourseInfoView_Previews: PreviewProvider {
    static let course: Binding<Course?> = .constant(MockData.instance.courses.first!)
    
    static var previews: some View {
        CourseInfoView(course: course)
            .environmentObject(CoursesViewModel(url: nil))
    }
}



struct InfoItem: Identifiable {
    var id = UUID()
    var title: String
    var text: InfoItemText
    var iconName: String
}

struct InfoItemView: View {
    var item: InfoItem
    
    var body: some View {
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
}

enum InfoItemText: String {
    case difficulty = "The level of difficulty of the course. There are 4 levels,\n \"●\"-easy,\n \"■\"-medium,\n \"▲\"-hard,\n \"♦︎\"-very hard\n Depending on your Putter's Golf Club experience level will depend on how challenging the course will be for you."
    
    case numOfHoles = "This denotes the total number of holes on the course. Not including \"Game Changer\" holes. Each hole will have it's par rating at the begining of the hole for your information as well as along the top of the score card."
    
    case numOfChallenges = "This denotes the total number of \"Game Changer\" holes on the course. Game Changers are unique putting challenges that add an extra layer of competition. These holes do not have numbers but are marked with checkered race flags. Each Game Changer hole will have instructions to tell you how to play and how the scoring is calculated. These holes can change the outcome of the game big time!"
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
                self.infoItem = InfoItem(title: "Difficulty Level", text: .difficulty, iconName: "diamond.circle.fill")
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
                self.infoItem = InfoItem(title: "Number Of Holes", text: InfoItemText.numOfHoles, iconName: "flag.circle.fill")
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
                self.infoItem = InfoItem(title: "Number of Game Changers", text: InfoItemText.numOfChallenges, iconName: "trophy.circle.fill")
            } label: {
                Image(systemName: "info.circle")
                    .foregroundColor(.blue)
            }
        }
    }
}





