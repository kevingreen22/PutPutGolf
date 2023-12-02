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
    @State var showButtonLoader = false
    @State private var username = ""
    @State private var password = ""
    
    var body: some View {
        ZStack {
            Color.green.ignoresSafeArea()
            
            VStack {
                Image(uiImage: UIImage(named: "logo_banner")!)
                    .resizable()
                    .scaledToFit()
                    .padding()
                    .padding(.top, 20)
                Spacer()
            }
            
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
                
//                Button(action: {
//                    // login code here
//                    showButtonLoader = true
//                    validateCredentials(username: username, password: password) { success in
//                        if success {
//                            withAnimation {
//                                loginCredentialsValid = true
//                            }
//                            showButtonLoader = false
//                        } else {
//                            showButtonLoader = false
//                            // show login error
//                            
//                        }
//                    }
//                }, label: {
//                    if showButtonLoader {
//                        ProgressView()
//                    } else {
//                        Text("LOGIN")
//                            .fontWeight(.semibold)
//                            .frame(maxWidth: .infinity)
//                    }
//                })
//                .controlSize(.large)
//                .buttonBorderShape(ButtonBorderShape.capsule)
//                .buttonStyle(.borderedProminent)
//                .padding([.horizontal, .bottom])
                
                ButtonWithLoader(showLoader: $showButtonLoader) {
                    validateCredentials(username: username, password: password) { success in
                        if success {
                            withAnimation {
                                loginCredentialsValid = true
                                showButtonLoader = false
                            }
                        } else {
                            showButtonLoader = false
                            // show login error
                            
                        }
                    }
                } content: {
                    Text("LOGIN")
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity)
                }
                .controlSize(.large)
                .buttonBorderShape(ButtonBorderShape.capsule)
                .buttonStyle(.borderedProminent)
                .padding([.horizontal, .bottom])

            }
            .frame(height: 350)
            .bordered(shape: RoundedRectangle(cornerRadius: 20), color: Color.green, lineWidth: 2)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .foregroundStyle(Color.white)
                    .shadow(radius: 10, y: 8)
            )
            .padding(.horizontal, 35)
            
        }
        .overlay(alignment: .topTrailing) {
            Button {
                presentationMode.wrappedValue.dismiss()
            } label: {
                Image(systemName: "xmark.circle.fill")
                    .font(.title)
                    .foregroundStyle(Color.white)
                    .padding(.trailing)
            }
        }
        
    }
    
    /// Validates login credentials.
    private func validateCredentials(username: String, password: String, completion: @escaping (Bool)->Void) {
        
        completion(true)
    }
    
}
#Preview {
    LoginView(loginCredentialsValid: .constant(true))
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
    @EnvironmentObject var navVM: NavigationStore
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
                
                vm.uploadNewCourse()
                
                navVM.path.removeLast()
            } else {
                // maybe show alert here ??
                
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
    var newHoles: [Hole]?
    var newChallenges: [Challenge]?
    var courseRules: [String]?
    var userName: String?
    var password: String?

    
    init(dataService: any DataServiceProtocol) {
        self.dataService = dataService
//        Task {
//            dataService.fetchCourses(handler: { courses in
//                guard let courses = courses else { return }
//                self.courses = courses
//            })
//        }
    }
    
//    /// Validates login credentials.
//    func validateCredentials(username: String, password: String, completion: @escaping (Bool)->Void) {
//        
//        completion(true)
//    }
//    
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
    func uploadNewCourse() {
        guard let course = newCourse, let userName = userName, let password = password else { return }
        dataService.post(course: course, url: ProductionURLs.post, username: userName, password: password)
    }
    
    
}









public extension View {
    
    func bordered<S:Shape>(shape: S, color: Color, lineWidth: CGFloat = 1) -> some View {
        self
            .overlay {
                shape
                    .stroke(color, lineWidth: lineWidth)
            }
    }
    
}
