//
//  AddCourseInfo.swift
//  PutPutGolf
//
//  Created by Kevin Green on 11/24/23.
//

import SwiftUI
import KGViews
import KGImageChooser

struct LoginView: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var loginCredentialsValid: Bool
    let dataService: any DataServiceProtocol
    @State var showButtonLoader = false
    @State private var errorAlert: ErrorAlert?
    @State private var username = ""
    @State private var password = ""
    
    var body: some View {
        ZStack {
            Image("golf_course")
                .resizable()
                .ignoresSafeArea()
            
            LoginRectangle()
                .strokeBorder(Color.green, lineWidth: 4)
                .background(LoginRectangle().foregroundColor(Color.white).shadow(radius: 10))
                .frame(height: 410)
                .overlay(alignment: .bottom) { // <
                    VStack(spacing: 30) {
                        Text("Login")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundStyle(Color.green)
                            .padding(.top)
                        
                        TextField("Username", text: $username)
                            .textFieldStyle(KGTextFieldStyle(
                                image: Image(systemName: "person.fill"),
                                imageColor: .green,
                                keyboardType: .emailAddress)
                            )
                            .bordered(shape: Capsule(), color: Color.green, lineWidth: 2)
                            .padding(.horizontal)
                        
                        TextField("Password", text: $password)
                            .textFieldStyle(                KGPasswordTextFieldStyle(placeholder: "Password", text: $password, imageColor: .green, shape: Capsule())
                            )
                            .bordered(shape: Capsule(), color: Color.green, lineWidth: 2)
                            .padding(.horizontal)
                                                
                        ButtonWithLoader(showLoader: $showButtonLoader) {
                            validateCredentials()
                        } content: {
                            Text("LOGIN")
                                .fontWeight(.semibold)
                                .frame(maxWidth: .infinity)
                        }
                        .controlSize(.large)
                        .buttonBorderShape(ButtonBorderShape.capsule)
                        .buttonStyle(.borderedProminent)
                        .padding([.horizontal, .bottom])
                    } // login fields
                    .padding()
                } // login fields
                .overlay(alignment: .top) { // <
                    ZStack {
                        Image(uiImage: UIImage(named: "plain_ball")!)
                            .resizable()
                            .frame(width: 110, height: 110)
                            .shadow(radius: 10)
                    }
                    .padding(8)
                    .offset(y: -62.5)
                } // ball image
                .padding(.horizontal, 35)
            
            VStack { // <
                HStack {
                    Spacer()
                    Button {
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .font(.title)
                            .foregroundStyle(Color.gray)
                            .padding(.trailing)
                    }
                }
                Spacer()
            } // close button
        }
        
        .showErrorAlert(alert: $errorAlert)
    }
    
    /// Sends call to server to validates login credentials.
    private func validateCredentials() {
        DispatchQueue.main.asyncAfter(deadline: .now()+2) {
//            do {
//                try await dataService.validateCredentials(user: username, password: password)
                withAnimation {
                    loginCredentialsValid = true
                    showButtonLoader = false
                }
//            } catch {
//                showButtonLoader = false
//                errorAlert = ErrorAlert.loginFailed
//            }
        }
    }
    
}
#Preview {
    LoginView(loginCredentialsValid: .constant(true), dataService: MockDataService(mockData: MockData.instance))
}


struct AddCourseInfo: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject var navStore: NavigationStore = NavigationStore()
    @Binding var loginCredentialsValid: Bool
    let dataService: any DataServiceProtocol
    let courses: [Course]
    
    var body: some View {
        NavigationStack(path: $navStore.path) {
            List {
                ForEach(courses) { course in
                    Button(action: {
                        navStore.path.append(course)
                    }, label: {
                        HStack {
                            Text(course.name)
                                .foregroundStyle(Color.black)
                            Spacer()
                            Image(systemName: "chevron.right")
                        }
                    })
                }
            }
            
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        navStore.path = NavigationPath()
                        loginCredentialsValid = false
                        presentationMode.wrappedValue.dismiss()
                    }
                }
                
                ToolbarItem {
                    Button(action: {
                        navStore.path.append(1)
                    }, label: {
                        Image(systemName: "plus")
                    })
                }
            }
            
            .navigationTitle("Courses")
            .navigationBarTitleDisplayMode(.large)
            .navigationDestination(for: Int.self) { navID in
                AddCourseView(dataService: self.dataService)
            }
            .navigationDestination(for: Course.self) { course in
                AddCourseView(course: course, dataService: self.dataService)
            }
        }
    }
}
#Preview {
    AddCourseInfo(loginCredentialsValid: .constant(true), dataService: MockDataService(mockData: MockData.instance), courses: MockData.instance.courses)
}


struct AddCourseView: View {
    @EnvironmentObject var navStore: NavigationStore
    @StateObject var vm: AddCourseInfoVM
    let dataService: any DataServiceProtocol
    let navID = 1
    var course: Course? = nil
    
    @State private var showAddHoleSheet = false
    @State private var showAddChallengeSheet = false
    @State private var showAddRuleSheet = false
    
    @State private var id: String = UUID().uuidString
    @State private var name: String = ""
    @State private var address: String = ""
    @State private var latitude: Double?
    @State private var longitude: Double?
    @State private var imageData: Data?
    @State private var difficulty: Difficulty = .easy
    @State private var holes: [Hole] = []
    @State private var challenges: [Challenge] = []
    @State private var rules: [String] = []
    @State private var hours: [String] = []
    
    init(dataService: any DataServiceProtocol) {
        _vm = StateObject(wrappedValue: AddCourseInfoVM(dataService: dataService))
        self.dataService = dataService
    }
    
    init(course: Course, dataService: any DataServiceProtocol) {
        _vm = StateObject(wrappedValue: AddCourseInfoVM(dataService: dataService))
        self.dataService = dataService
        self.course = course
    }
    
    var body: some View {
        List {
            Section("Course Details") {
                TextField("ID", text: $id).foregroundColor(.gray)
                TextField("Name*", text: $name)
                TextField("Address*", text: $address)
                TextField("latitude*", value: $latitude, formatter: NumberFormatter())
                TextField("longitude*", value: $longitude, formatter: NumberFormatter())
//                TextField("ImageData", text: $imageData)
                DifficultyPicker(difficulty: $difficulty)
            }
            
            // Holes
            Section {
                ForEach(holes, id: \.self) { hole in
                    HStack {
                        Text("# \(hole.number)")
                        Spacer()
                        Text("Par \(hole.par)")
                        Spacer()
                        Difficulty.icon(hole.difficulty)
                            .foregroundStyle(Difficulty.color(for: hole.difficulty))
                        Text("\(hole.difficulty.rawValue)")
                    }
                }
            } header: {
                HStack {
                    Text("Holes")
                        .font(.headline)
                        .fontWeight(.semibold)
                    Spacer()
                    Button(action: {
                        showAddHoleSheet = true
                    }, label: {
                        Image(systemName: "plus")
                    })
                }
            }
            
            // Challenges
            Section {
                ForEach(challenges, id: \.self) { challenge in
                    HStack {
                        Text("\"\(challenge.name)\"")
                        Spacer()
                        Difficulty.icon(challenge.difficulty)
                            .foregroundStyle(Difficulty.color(for: challenge.difficulty))
                        Text("\(challenge.difficulty.rawValue)")
                    }
                }
            } header: {
                HStack {
                    Text("Challenges")
                        .font(.headline)
                        .fontWeight(.semibold)
                    Spacer()
                    Button(action: {
                        showAddChallengeSheet = true
                    }, label: {
                        Image(systemName: "plus")
                    })
                }
            }
            
            // Rules
            Section {
                ForEach(rules, id: \.self) { rule in
                    Text("- \(rule)")
                        .foregroundStyle(Color.gray)
                }
            } header: {
                HStack {
                    Text("Rules")
                        .font(.headline)
                        .fontWeight(.semibold)
                    Spacer()
                    Button(action: {
                        showAddRuleSheet = true
                    }, label: {
                        Image(systemName: "plus")
                    })
                }
            }
            
            // Hours
//            TextField("hours*", text: $hours)
            
        }
        
        Button(action: {
            if vm.validateCourse(id: id, name: name, address: address, latitude: latitude, longitude: longitude, imageData: imageData, difficulty: difficulty, holes: holes, challenges: challenges, rules: rules, hours: hours) {
                
                Task {
                    do {
                        try await vm.uploadNewCourse()
                    } catch {
                        throw ErrorAlert.basic(error.localizedDescription)
                    }
                }
                
                navStore.path.removeLast()
            } else {
                // maybe show alert here ??
//                $vm.errorAlert = ErrorAlert.basic("Failed to validate course. Please make sure all required fields.")
            }
        }, label: {
            Text(course == nil ? "Add Course" : "Update Course")
                .font(.title)
                .fontWeight(.semibold)
        })
        .buttonStyle(.borderedProminent)
        
        .navigationTitle(course == nil ? "Add Course" : "Edit Course")
        
        .sheet(isPresented: $showAddHoleSheet) {
            AddHoleView()
        }
        
        .sheet(isPresented: $showAddChallengeSheet) {
            AddChallengeView()
        }
        
        .sheet(isPresented: $showAddRuleSheet) {
            AddCourseRulesView()
        }
        
        .showErrorAlert(alert: $vm.errorAlert)
        
        .onAppear {
            if let course = course {
                self.id = course.id
                self.name = course.name
                self.address = course.address
                self.latitude = course.latitude
                self.longitude = course.longitude
                self.imageData = course.imageData
                self.difficulty = course.difficulty
                self.holes = course.holes
                self.challenges = course.challenges
                self.rules = course.rules
                self.hours = course.hours
            }
        }
    }
}
#Preview {
    AddCourseView(course: MockData.instance.courses.first!, dataService: MockDataService(mockData: MockData.instance))
}





struct AddHoleView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var vm: AddCourseInfoVM
    
    @State private var id: String = UUID().uuidString
    @State private var number: Int?
    @State private var par: Int?
    @State private var difficulty: Difficulty = .easy
    
    var body: some View {
        List {
            Section("Hole Details") {
                TextField("ID", text: $id).foregroundStyle(Color.gray)
                TextField("Number*", value: $number, formatter: NumberFormatter())
                TextField("Par*", value: $par, formatter: NumberFormatter())
                DifficultyPicker(difficulty: $difficulty)
            }
        }
        Button(action: {
            if vm.validateHole(id: id, number: number, par: par, difficulty: difficulty) {
                presentationMode.wrappedValue.dismiss()
            } else {
                // maybe show alert here ??
            }
        }, label: {
            Text("Add Hole to Course")
                .font(.title)
                .fontWeight(.semibold)
        })
        .buttonStyle(.borderedProminent)
        
        .navigationTitle("Add Hole")
    }
}
#Preview {
    AddHoleView()
}


struct AddChallengeView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var vm: AddCourseInfoVM

    @State private var id: String = UUID().uuidString
    @State private var name: String = ""
    @State private var rules: String = "Add Challenge Rules"
    @State private var difficulty: Difficulty = .easy
    
    var body: some View {
        List {
            Section("Challenge Details") {
                TextField("ID", text: $id).foregroundStyle(Color.gray)
                TextField("Name*", text: $name)
                TextEditor(text: $rules)
                DifficultyPicker(difficulty: $difficulty)
            }
        }
        Button(action: {
            if vm.validateChallenge(id: id, name: name, rules: rules, difficulty: difficulty) {
                presentationMode.wrappedValue.dismiss()
            } else {
                // maybe show alert here ??
            }
        }, label: {
            Text("Add Challenge to Course")
                .font(.title)
                .fontWeight(.semibold)
        })
        .buttonStyle(.borderedProminent)
        
        .navigationTitle("Add Challenge")
    }
}
#Preview {
    AddChallengeView()
}


struct AddCourseRulesView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var vm: AddCourseInfoVM

    @State private var rule: String = "..."
    
    var body: some View {
        NavigationStack {
            List {
                Section("One Rule at a time") {
                    TextEditor(text: $rule)
                }
            }
            Button(action: {
                if vm.validateCourse(rule: rule) {
                    presentationMode.wrappedValue.dismiss()
                } else {
                    // maybe show alert here ??
                    
                }
            }, label: {
                Text("Add Rule")
                    .font(.title)
                    .fontWeight(.semibold)
            })
            .buttonStyle(.borderedProminent)
            
            .navigationTitle("Add Rule")
            .navigationBarTitleDisplayMode(.large)
        }
    }
}
#Preview {
    AddCourseRulesView()
}


struct DifficultyPicker: View {
    @Binding var difficulty: Difficulty
    
    var body: some View {
        Picker(selection: $difficulty) {
            Text("Easy").tag(Difficulty.easy)
            Text("Medium").tag(Difficulty.medium)
            Text("Hard").tag(Difficulty.hard)
            Text("Very Hard").tag(Difficulty.veryHard)
        } label: {
            Text("Difficulty")
                .foregroundStyle(Difficulty.color(for: difficulty))
        }
    }
}







final class AddCourseInfoVM: ObservableObject {
    let dataService: any DataServiceProtocol
    @Published var newCourse: Course?
    @Published var errorAlert: ErrorAlert?
    var newHoles: [Hole]?
    var newChallenges: [Challenge]?
    var courseRules: [String]?
    var username: String?
    var password: String?
    
    init(dataService: any DataServiceProtocol) {
        self.dataService = dataService
    }
    
    /// Check that all properties are inputed.
    /// then maybe show a review view to double check that everything is proper?
    func validateCourse(id: String, name: String, address: String, latitude: Double?, longitude: Double?, imageData: Data?, difficulty: Difficulty, holes: [Hole], challenges: [Challenge], rules: [String], hours: [String]) -> Bool {
        if id != "" &&
            name != "" &&
            address != "" &&
            latitude != nil &&
            longitude != nil &&
            holes != [] &&
            rules != [] &&
            hours != [] {
            var course = Course(id: id, name: name, address: address, latitude: latitude!, longitude: longitude!, imageData: imageData, difficulty: difficulty, holes: holes, challenges: challenges, rules: rules, hours: hours)
            if newHoles != nil {
                course.holes = newHoles!
            }
            if newChallenges != nil {
                course.challenges = newChallenges!
            }
            if courseRules != nil {
                course.rules = courseRules!
            }
            course.hours = hours
            newCourse = course
            return true
        }
        return false
    }
    
    /// Check that all properties are inputed.
    func validateHole(id: String, number: Int?, par: Int?, difficulty: Difficulty) -> Bool {
        if id != "" &&
            number != nil &&
            par != nil {
            let hole = Hole(id: id, number: number!, par: par!, difficulty: difficulty)
            newHoles!.append(hole)
            return true
        }
        return false
    }
    
    /// Check that all properties are inputed.
    func validateChallenge(id: String, name: String, rules: String, difficulty: Difficulty) -> Bool {
        if id != "" &&
            name != "" &&
            rules != "Add Challenge Rules" && rules != "" {
            let challenge = Challenge(id: id, name: name, rules: rules, difficulty: difficulty)
            newChallenges!.append(challenge)
            return true
        }
        return false
    }
    
    /// Check that theres at least one rule, and then create an array of all the rules.
    func validateCourse(rule: String) -> Bool {
        if rule != "" || rule != "..." {
            courseRules?.append(rule)
            return true
        }
        return false
    }
    
    /// Uploads a new course.
    func uploadNewCourse() async throws {
        guard let course = newCourse, let username = username, let password = password else { return }
        do {
            try await dataService.post(course: course, url: ProductionURLs.post, username: username, password: password)
        } catch  {
            throw ErrorAlert.postFailed
        }
    }
    

}





struct LoginRectangle: InsettableShape {
    var insetAmount = 0.0
    let imageNegativeRect: CGRect = CGRect(origin: .zero, size: CGSize(width: 120, height: 120))
    let radius: CGFloat = 20
    
    func path(in rect: CGRect) -> Path {
        let topLeadingAfterRadius = CGPoint(x: rect.minX+radius, y: rect.minY)
        let topLeadingBeforeRadius = CGPoint(x: rect.minX, y: rect.minY+radius)
        let topTrailing = CGPoint(x: rect.maxX-radius, y: rect.minY)
        let bottomTrailing = CGPoint(x: rect.maxX, y: rect.maxY-radius)
        let bottomLeading = CGPoint(x: rect.minX+radius, y: rect.maxY)
        
        return Path { path in
            //start point origin + radius
            path.move(to: topLeadingAfterRadius)
            
            // START point of image negative space arc. i.e. half circle
            path.addLine(to: CGPoint(x: rect.midX-imageNegativeRect.width/2, y: rect.minY))
            
            // image negative space arc. i.e. half circle
            path.addArc(center:
                            CGPoint(x: rect.midX, y: rect.minY),
                        radius: imageNegativeRect.height/2,
                        startAngle: Angle(degrees: 180),
                        endAngle: Angle(degrees: 0),
                        clockwise: true)
            
            // finish top trailing horizontal line to just before corner radius
            path.addLine(to: topTrailing)
            
            // top trailing corner
            path.addArc(center: 
                            CGPoint(x: rect.maxX-radius, y: rect.minY+radius),
                        radius: radius,
                        startAngle: Angle(degrees: 270),
                        endAngle: Angle(degrees: 0),
                        clockwise: false)
                                          
            // trailing vertical line to bottom just before corner radius
            path.addLine(to: bottomTrailing)
            
            // bottom trailing corner
            path.addArc(center:
                            CGPoint(x: rect.maxX-radius, y: rect.maxY-radius),
                        radius: radius,
                        startAngle: Angle(degrees: 0),
                        endAngle: Angle(degrees: 90),
                        clockwise: false)
            
            // bottom horizontal line to bottom leading just before corner radius
            path.addLine(to: bottomLeading)
            
            // bottom leading corner
            path.addArc(center:
                            CGPoint(x: rect.minX+radius, y: rect.maxY-radius),
                        radius: radius,
                        startAngle: Angle(degrees: 90),
                        endAngle: Angle(degrees: 180),
                        clockwise: false)
            
            // leading line from bottom to top/origin just before corner radius
            path.addLine(to: topLeadingBeforeRadius)
            
            // origin corner
            path.addArc(center:
                            CGPoint(x: rect.minX+radius, y: rect.minY+radius),
                        radius: radius,
                        startAngle: Angle(degrees: 180),
                        endAngle: Angle(degrees: 270),
                        clockwise: false)
        }
    }
    
    func inset(by amount: CGFloat) -> some InsettableShape {
        var shape = self
        shape.insetAmount += amount
        return shape
    }
    
}
#Preview {
    LoginRectangle()
        .strokeBorder(Color.black, lineWidth: 3)
        .background(LoginRectangle().foregroundColor(Color.green))
        .frame(height: 350)
        .padding(.horizontal, 35)
}
