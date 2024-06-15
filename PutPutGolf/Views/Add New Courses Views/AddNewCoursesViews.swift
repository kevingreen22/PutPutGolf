//
//  AddNewCoursesViews.swift
//  PutPutGolf
//
//  Created by Kevin Green on 11/24/23.
//

import SwiftUI
import KGViews
import KGImageChooser
import Combine

// MARK: Main Views

struct LoginView: View {
    @Binding var loginCredentialsValid: Bool
    let dataService: any DataServiceProtocol
    
    @Environment(\.colorScheme) var colorScheme
    
    @State private var errorAlert: AlertType?
    @State private var username = ""
    @State private var password = ""
    
    
    var body: some View {
        ZStack {
            Image("golf_course")
                .resizable()
                .ignoresSafeArea()
            
            Color.black.opacity(colorScheme == .dark ? 0.4 : 0).ignoresSafeArea()
            
            LoginRectangle()
                .strokeBorder(Color.accentColor, lineWidth: 4)
                .background(LoginRectangle().foregroundColor(Color.secondary).shadow(radius: 10))
                .frame(height: 410)
            
                .overlay(alignment: .bottom) { // <
                    VStack(spacing: 30) {
                        Text("Login")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundStyle(Color.accentColor)
                            .padding(.top)
                        
                        TextField("Username", text: $username)
                            .textFieldStyle(KGTextFieldStyle(
                                image: Image(systemName: "person.fill"),
                                imageColor: .accentColor,
                                keyboardType: .emailAddress)
                            )
                            .bordered(shape: Capsule(), color: Color.accentColor, lineWidth: 2)
                            .padding(.horizontal)
                        
                        TextField("Password", text: $password)
                            .textFieldStyle(                KGPasswordTextFieldStyle(
                                placeholder: "Password",
                                text: $password,
                                imageColor: .accentColor,
                                backgroundColor: colorScheme == .dark ? .black : .white)
                            )
                            .bordered(shape: Capsule(), color: Color.accentColor, lineWidth: 2)
                            .padding(.horizontal)
                                            
                        ButtonWithLoader {
                            await validateCredentials()
                        } label: {
                            Text("LOGIN")
                                .fontWeight(.semibold)
                                .frame(maxWidth: .infinity)
                        }
                        .foregroundStyle(colorScheme == .dark ? .black : .white)
                        .controlSize(.large)
                        .buttonBorderShape(ButtonBorderShape.capsule)
                        .buttonStyle(.borderedProminent)
                        .padding([.horizontal, .bottom])
                    }
                    .padding()
                } // login fields
            
                .overlay(alignment: .top) { // <
                    ZStack {
                        Image(uiImage: UIImage(named: "golf_ball")!)
                            .resizable()
                            .frame(width: 110, height: 110)
                            .shadow(radius: 10)
                            .overlay {
                                Image(uiImage: UIImage(named: "goat_putters")!)
                                    .resizable()
                                    .frame(width: 120, height: 120)
                            }
                    }
                    .padding(8)
                    .offset(y: -62.5)
                } // ball image
            
                .padding(.horizontal, 35)
        }
        
        .overlay(alignment: .bottom) {
            CloseButton()
        } // Close Button
        
        .showAlert(alert: $errorAlert)
        
    }
    
    /// Sends call to server to validates login credentials.
    private func validateCredentials() async {
        try? await Task.sleep(nanoseconds: 2_000_000_000) // <-- For Development only
        withAnimation {
            DispatchQueue.main.async {
                loginCredentialsValid = true
                print("Login successfull.")
            }
        }

        #warning("Uncomment for production use: validate credentials.")
//        Task { // <-- For Production only
//            do {
//                try await dataService.validateCredentials(user: username, password: password)
//                withAnimation {
//                    loginCredentialsValid = true
//                      print("Login in sucsessfull.")
//                }
//            } catch {
//                errorAlert = error as? ErrorAlert
//            }
//        }
    }
    
}

#Preview {
    LoginView(loginCredentialsValid: .constant(true), dataService: MockDataService(mockData: MockData.instance))
}



struct CoursesInfo: View {
    @Binding var loginCredentialsValid: Bool
    let dataService: any DataServiceProtocol
    let courses: [Course]
    
    @Environment(\.presentationMode) var presentationMode
    @StateObject var navStore: NavigationStore = NavigationStore()
    
    
    var body: some View {
        NavigationStack(path: $navStore.path) {
            List {
                ForEach(courses) { course in
                    Button {
                        navStore.path.append(course)
                    } label: {
                        HStack {
                            Text(course.name)
                            Spacer()
                            Image(systemName: "chevron.right")
                        }
                    }
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
                    Button {
                        navStore.path.append(1)
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            
            .navigationTitle("Courses")
            .navigationBarTitleDisplayMode(.large)
            .navigationDestination(for: Int.self) { navID in
                AddCourseView(dataService: self.dataService)
                    .environmentObject(navStore)
            }
            .navigationDestination(for: Course.self) { course in
                AddCourseView(course: course, dataService: self.dataService)
                    .environmentObject(navStore)
            }
        }
    }
}

#Preview {
    CoursesInfo(loginCredentialsValid: .constant(true), dataService: MockDataService(mockData: MockData.instance), courses: MockData.instance.courses)
        .environmentObject(NavigationStore())
}



struct AddCourseView: View {
    enum FocusedField: Hashable {
        case id, name, address, latitude, longitude, hours, hoursInfo
    }
    @EnvironmentObject var navStore: NavigationStore
    @StateObject var vm: AddCourseInfoVM
    @StateObject var hoursVM: DailyHoursVM
    let dataService: any DataServiceProtocol
    let navID = 1
//    var course: Course? = nil
    
    @State private var showImageChooser = false
    @State private var showAddHoleSheet = false
    @State private var showAddChallengeSheet = false
    @State private var showAddRuleSheet = false
    @FocusState private var focusedField: FocusedField?
    
//    @State private var id: String = UUID().uuidString
//    @State private var name: String = ""
//    @State private var address: String = ""
//    @State private var latitude: Double?
//    @State private var longitude: Double?
//    @State private var imageData: Data?
    @State private var tempImageHolder: UIImage?
//    @State private var difficulty: Difficulty = .easy
//    @State private var holes: [Hole] = []
//    @State private var challenges: [Challenge] = []
//    @State private var rules: [String] = []
//    @State private var hours: [String] = []
    
    init(dataService: any DataServiceProtocol) {
        _vm = StateObject(wrappedValue: AddCourseInfoVM(dataService: dataService))
        self.dataService = dataService
        _hoursVM = StateObject(wrappedValue: DailyHoursVM())
    }
    
    init(course: Course, dataService: any DataServiceProtocol) {
        _vm = StateObject(wrappedValue: AddCourseInfoVM(course: course, dataService: dataService))
        self.dataService = dataService
//        self.course = course
        _hoursVM = StateObject(wrappedValue: DailyHoursVM(course.hours, separator: ":"))
    }
    
    var body: some View {
        List {
            detailsSection
            hoursSection
            holesSection
            challengesSection
            rulesSection
        }
        .listStyle(.sidebar)
        .dismissKeyboardOnTap($focusedField)
        
        addOrUpdateCourseButton
        
        .navigationBarTitleDisplayMode(.large)
        .navigationTitle(vm.newCourse.id == "" ? "Add Course" : "Edit Course")
        
        .sheet(isPresented: $showImageChooser) {
            KGCameraImageChooser(uiImage: $tempImageHolder) {
                if tempImageHolder != nil {
                    vm.newCourse.imageData = tempImageHolder?.jpegData(compressionQuality: 1)
                }
            }
        }
        
        .sheet(isPresented: $showAddHoleSheet) {
            AddHoleView()
                .environmentObject(vm)
                .environmentObject(navStore)
        }
        
        .sheet(isPresented: $showAddChallengeSheet) {
            AddChallengeView()
                .environmentObject(vm)
                .environmentObject(navStore)
        }
        
        .sheet(isPresented: $showAddRuleSheet) {
            AddCourseRulesView()
                .environmentObject(vm)
                .environmentObject(navStore)
        }
        
        .showAlert(alert: $vm.errorAlert)
        
//        .onAppear {
//            // Setting course info if updating existing course.
//            if let course = course {
//                self.id = course.id
//                self.name = course.name
//                self.address = course.address
//                self.latitude = course.latitude
//                self.longitude = course.longitude
//                self.imageData = course.imageData
//                self.difficulty = course.difficulty
//                self.holes = course.holes
//                self.challenges = course.challenges
//                self.rules = course.rules
//                self.hours = course.hours
//            }
//        }
                
    }
        
    fileprivate var detailsSection: some View {
        Section("Course Details") {
            TextField("Name*", text: $vm.newCourse.name)
                .focused($focusedField, equals: FocusedField.name)
                .submitLabel(.next)
            TextField("Address*", text: $vm.newCourse.address)
                .focused($focusedField, equals: FocusedField.address)
                .submitLabel(.next)
            TextField("latitude*", value: $vm.newCourse.latitude, formatter: NumberFormatter())
                .focused($focusedField, equals: FocusedField.latitude)
                .keyboardType(.numbersAndPunctuation)
                .submitLabel(.next)
            TextField("longitude*", value: $vm.newCourse.longitude, formatter: NumberFormatter())
                .focused($focusedField, equals: FocusedField.longitude)
                .keyboardType(.numbersAndPunctuation)
                .submitLabel(.return)
            DifficultyPicker(difficulty: $vm.newCourse.difficulty)
            chooseImageCell
            TextField("ID", text: $vm.newCourse.id)
                .focused($focusedField, equals: FocusedField.id)
                .submitLabel(.return)
        }
        
        .onSubmit {
            switch focusedField {
            case .id: focusedField = .name
            case .name: focusedField = .address
            case .address: focusedField = .latitude
            case .latitude: focusedField = .longitude
            case .longitude: focusedField = nil
            default: focusedField = nil
            }
        }
    }
    
    fileprivate var chooseImageCell: some View {
        HStack {
            Button("Choose Image") { showImageChooser.toggle() }
            Spacer()
            if let data = vm.newCourse.imageData, let image = UIImage(data: data) {
                Image(uiImage: image)
                    .resizable()
                    .frame(width: 50, height: 50)
                    .clipShape(Circle())
            } else if let tempImage = tempImageHolder {
                Image(uiImage: tempImage)
                    .resizable()
                    .frame(width: 50, height: 50)
                    .clipShape(Circle())
            } else {
                Image(uiImage: UIImage(systemName: "photo.circle.fill")!)
                    .resizable()
                    .frame(width: 50, height: 50)
                    .clipShape(Circle())
            }
        }
    }
    
    fileprivate var hoursSection: some View {
        Section {
            ForEach($hoursVM.dailyHoursArr) { cell in
                hoursCell(cell)
            }
            .onDelete { offsets in
                hoursVM.removeCell(at: offsets)
            }
            HStack(alignment: .top) {
                Text("Other Info:")
                    .foregroundStyle(Color.gray)
                TextEditor(text: $hoursVM.otherInfo)
                    .multilineTextAlignment(.trailing)
                    .focused($focusedField, equals: FocusedField.hoursInfo)
                    .frame(height: 150)
            }
            .padding(.top)
        } header: {
            HStack {
                Text("Hours")
                    .font(.headline)
                    .fontWeight(.semibold)
                Spacer()
                Button {
                    withAnimation { hoursVM.addNewCell() }
                } label: {
                    Image(systemName: "plus")
                }.disabled(hoursVM.usingEveryDay)
            }
        }
        
        .onChange(of: hoursVM.dailyHoursArr) { _ in
            Task {
                await vm.updateHours(hoursVM.encode())
            }
        }
        .onChange(of: hoursVM.otherInfo) { _ in
            Task {
                await vm.updateHours(hoursVM.encode())
            }
        }
    }
    
    fileprivate func hoursCell(_ cell: Binding<DailyHours>) -> some View {
        HStack(alignment: .center) {
            Picker("", selection: cell.day) {
                ForEach(DayOfWeek.allCases, id: \.self) { day in
                    Text(day.rawValue)
                }
            }
            .labelsHidden()
            .onChange(of: cell.wrappedValue.day, perform: { day in
                hoursVM.setPickerListVolume(with: day, for: cell.id)
            })
            TextField("9am - 5pm", text: cell.hours)
                .multilineTextAlignment(.trailing)
                .frame(height: 40)
                .focused($focusedField, equals: FocusedField.hours)
                
        }
        .deleteDisabled(hoursVM.dailyHoursArr.count <= 1)
    }
    
    fileprivate var holesSection: some View {
        Section {
            ForEach(vm.newCourse.holes, id: \.self) { hole in
                holeCell(hole)
            }
            .onDelete { indexSet in
                vm.newCourse.holes.remove(atOffsets: indexSet)
            }
        } header: {
            HStack {
                Text("Holes")
                    .font(.headline)
                    .fontWeight(.semibold)
                Spacer()
                Button {
                    showAddHoleSheet = true
                } label: {
                    Image(systemName: "plus")
                }
            }
        }
    }
    
    fileprivate func holeCell(_ hole: Hole) -> some View {
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
    
    fileprivate var challengesSection: some View {
        Section {
            if let challenges = vm.newCourse.challenges {
                ForEach(challenges, id: \.self) { challenge in
                    challengeCell(challenge)
                }
                .onDelete{ indexSet in
                    vm.newCourse.challenges?.remove(atOffsets: indexSet)
                }
            }
        } header: {
            HStack {
                Text("Challenges")
                    .font(.headline)
                    .fontWeight(.semibold)
                Spacer()
                Button {
                    showAddChallengeSheet = true
                } label: {
                    Image(systemName: "plus")
                }
            }
        }
    }
    
    fileprivate func challengeCell(_ challenge: Challenge) -> some View {
        HStack {
            Text("\"\(challenge.name)\"")
            Spacer()
            Difficulty.icon(challenge.difficulty)
                .foregroundStyle(Difficulty.color(for: challenge.difficulty))
            Text("\(challenge.difficulty.rawValue)")
        }
    }
    
    fileprivate var rulesSection: some View {
        Section {
            ForEach(vm.newCourse.rules, id: \.self) { rule in
                Text("- \(rule)")
            }
            .onDelete { indexSet in
                vm.newCourse.rules.remove(atOffsets: indexSet)
            }
        } header: {
            HStack {
                Text("Course Rules")
                    .font(.headline)
                    .fontWeight(.semibold)
                Spacer()
                Button {
                    showAddRuleSheet = true
                } label: {
                    Image(systemName: "plus")
                }
            }
        }
    }
    
    fileprivate var addOrUpdateCourseButton: some View {
        ButtonWithLoader {
            Task {
//                try await vm.uploadCourse(id: id, name: name, address: address, latitude: latitude, longitude: longitude, imageData: imageData, difficulty: difficulty, holes: holes, challenges: challenges, rules: rules, hours: hours)
                try await vm.uploadCourse()
                navStore.path.removeLast()
            }
        } label: {
            Text(vm.newCourse.id == "" ? "Add Course" : "Update Course")
                .font(.title)
                .fontWeight(.semibold)
        }
        .buttonStyle(.borderedProminent)
        .padding(.top)
    }
    
}

#Preview {
    AddCourseView(course: MockData.instance.courses.first!, dataService: MockDataService(mockData: MockData.instance))
        .environmentObject(NavigationStore())
}




// MARK: Secondary Views

struct AddHoleView: View {
    enum FocusedField: Hashable {
        case id, number, par
    }
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var vm: AddCourseInfoVM
    @FocusState private var focusedField: FocusedField?
    
    @State private var id: String = UUID().uuidString
    @State private var number: String = ""
    @State private var par: String = ""
    @State private var difficulty: Difficulty = .easy
    
    
    var body: some View {
        List {
            Section {
                TextField("Hole Number*", text: $number)
                    .focused($focusedField, equals: FocusedField.number)
                    .keyboardType(.numbersAndPunctuation)
                    .submitLabel(.next)
                TextField("Par*", text: $par)
                    .focused($focusedField, equals: FocusedField.par)
                    .keyboardType(.numbersAndPunctuation)
                    .submitLabel(.next)
                DifficultyPicker(difficulty: $difficulty)
                TextField("ID*", text: $id)
                    .focused($focusedField, equals: FocusedField.id)
                    .submitLabel(.return)
            } header: {
                Text("Create New Hole")
                    .font(.title)
                    .fontWeight(.semibold)
            }
        }
        
        Button {
            print("\(type(of: self)).\(#function).addHoleButton")
            guard let number = Int(number), let par = Int(par) else { return }
            Task {
                await vm.validateHole(id: id, number: number, par: par, difficulty: difficulty)
                DispatchQueue.main.async {
                    if vm.errorAlert == nil {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        } label: {
            Text("Add Hole to Course")
                .font(.title)
                .fontWeight(.semibold)
        }
        .buttonStyle(.borderedProminent)
        
        .onSubmit {
            switch self.focusedField {
            case .number: self.focusedField = .par
            default: self.focusedField = nil
            }
        }
        
        .onAppear {
            self.focusedField = .number
        }
        
        .dismissKeyboardOnTap($focusedField)
        
        .showAlert(alert: $vm.errorAlert)
        
    }
}

#Preview {
    let mockData = MockData.instance
    let dataService = MockDataService(mockData: mockData)
    
    return AddHoleView()
        .environmentObject(AddCourseInfoVM(dataService: dataService))
        .environmentObject(NavigationStore())
}



struct AddChallengeView: View {
    enum FocusedField: Int, Hashable {
        case id, name, rules
    }
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var vm: AddCourseInfoVM
    @FocusState private var focusedField: FocusedField?
    
    @State private var id: String = UUID().uuidString
    @State private var name: String = ""
    @State private var rules: String = ""
    @State private var difficulty: Difficulty = .easy
    
    var body: some View {
        List {
            Section {
                TextField("Name*", text: $name)
                    .focused($focusedField, equals: FocusedField.name)
                    .submitLabel(.next)
                TextEditor(text: $rules)
                    .selectAllTextOnBeginEditing()
                    .focused($focusedField, equals: FocusedField.rules)
                    .submitLabel(.return)
                    .overlay(alignment: .leading) {
                        Text("Add rule(s) separated by comma's*")
                            .foregroundStyle(Color.gray)
                            .opacity(rules == "" ? 0.6 : 0)
                            .animation(.easeInOut, value: rules)
                    }
                DifficultyPicker(difficulty: $difficulty)
                TextField("ID", text: $id)
                    .focused($focusedField, equals: FocusedField.id)
                    .submitLabel(.return)
            } header: {
                Text("Add New Challenge")
                    .font(.title)
                    .fontWeight(.semibold)
            }
        }
        Button {
            Task {
                await vm.validateChallenge(id: id, name: name, rules: rules, difficulty: difficulty)
                DispatchQueue.main.async {
                    if vm.errorAlert == nil {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        } label: {
            Text("Add Challenge to Course")
                .font(.title)
                .fontWeight(.semibold)
        }
        .buttonStyle(.borderedProminent)
        
        .onSubmit {
            switch self.focusedField {
            case .name: self.focusedField = .rules
            default: self.focusedField = nil
            }
        }
        
        .onAppear {
            self.focusedField = .name
        }
        
        .dismissKeyboardOnTap($focusedField)
        
        .showAlert(alert: $vm.errorAlert)
        
    }
}

#Preview {
    let mockData = MockData.instance
    let dataService = MockDataService(mockData: mockData)
    
    return AddChallengeView()
        .environmentObject(AddCourseInfoVM(dataService: dataService))
        .environmentObject(NavigationStore())
}



struct AddCourseRulesView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var vm: AddCourseInfoVM
    @FocusState var isFocused
    @State private var rule: String = "..."
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    TextEditor(text: $rule)
                        .selectAllTextOnBeginEditing()
                        .focused($isFocused)
                } header: {
                    Text("Add A Rule")
                        .font(.title)
                        .fontWeight(.semibold)
                }
            }
            Button {
                Task {
                    await vm.validateRule(rule)
                    DispatchQueue.main.async {
                        if vm.errorAlert == nil {
                            presentationMode.wrappedValue.dismiss()
                        }
                    }
                }
            } label: {
                Text("Add Rule")
                    .font(.title)
                    .fontWeight(.semibold)
            }
            .buttonStyle(.borderedProminent)
        }
        
        .dismissKeyboardOnTap($isFocused)
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

#Preview {
    DifficultyPicker(difficulty: .constant(.easy))
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
        .strokeBorder(Color.primary, lineWidth: 3)
        .background(LoginRectangle().foregroundColor(Color.accentColor))
        .frame(height: 350)
        .padding(.horizontal, 35)
}




// MARK: View Models

final class AddCourseInfoVM: ObservableObject {
    let dataService: any DataServiceProtocol
    @Published var newCourse: Course
//    @Published var newHoles: [Hole]?
//    @Published var newChallenges: [Challenge]?
//    @Published var courseRules: [String]?
    @Published var errorAlert: AlertType?

    var username: String?
    var password: String?
    
    init(dataService: any DataServiceProtocol) {
        self.dataService = dataService
        self.newCourse = Course()
    }
    
    init(course: Course, dataService: any DataServiceProtocol) {
        self.dataService = dataService
        self.newCourse = course
    }
    
    /// Check that all properties are inputed.
    func validateHole(id: String, number: Int?, par: Int?, difficulty: Difficulty) async {
        print("\(type(of: self)).\(#function)")
        if id != "" && number != nil && par != nil {
            let hole = Hole(id: id, number: number!, par: par!, difficulty: difficulty)
//            newHoles == nil ? newHoles = [hole] : newHoles!.append(hole)
            newCourse.holes.append(hole)
        } else {
            errorAlert = AlertType.basic(title: "Hole info incomplete. Please try again.")
        }
    }
    
    /// Check that all properties are inputed.
    func validateChallenge(id: String, name: String, rules: String, difficulty: Difficulty) async {
        print("\(type(of: self)).\(#function)")
        if self.newCourse.challenges != nil {
            if id != "" && name != "" && rules != "Add Challenge Rules" && rules != "" {
                let challenge = Challenge(id: id, name: name, rules: rules, difficulty: difficulty)
                self.newCourse.challenges!.append(challenge)
            } else {
                errorAlert = AlertType.basic(title: "Challenge info incomplete. Please try again.")
            }
        }
    }
    
    /// Check that theres at least one rule, and then create an array of all the rules.
    func validateRule(_ rule: String) async {
        print("\(type(of: self)).\(#function)")
        if rule != "" || rule != "..." {
            self.newCourse.rules.append(rule)
        } else {
            errorAlert = AlertType.basic(title: "Rule incomplete. Please try again.")
        }
    }
    
    func updateHours(_ hours: [String]) async {
        newCourse.hours = hours
    }
    
    /// Check that all properties are inputed.
//    func validateCourse(id: String, name: String, address: String, latitude: Double?, longitude: Double?, imageData: Data?, difficulty: Difficulty, holes: [Hole], challenges: [Challenge], rules: [String], hours: [String]) async throws -> Course {
//        print("\(type(of: self)).\(#function)")
//        if id != "" && name != "" && address != "" && latitude != nil && longitude != nil && holes != [] && rules != [] && hours != [] && newHoles != nil && newChallenges != nil && courseRules != nil {
//            
//            var course = Course(id: id, name: name, address: address, latitude: latitude!, longitude: longitude!, imageData: imageData, difficulty: difficulty, holes: holes, challenges: challenges, rules: rules, hours: hours)
//            
//            course.holes = newHoles!
//            course.challenges = newChallenges!
//            course.rules = courseRules!
//            course.hours = hours
//            
//            return course
//        } else {
//            throw ErrorAlert.validationFailed
//        }
//    }
    
    @discardableResult func validateCourse() async throws -> Course {
        print("\(type(of: self)).\(#function)")
        if newCourse.id != "" && newCourse.name != "" && newCourse.address != "" && newCourse.latitude != 0 && newCourse.longitude != 0 && newCourse.holes != [] && newCourse.rules != [] && newCourse.hours != [] {
//            newCourse.hours = hours
            return newCourse
        } else {
            throw AlertType.basic(title: "Course validation failied. Please try again.")
        }
    }
    
    
    /// Uploads a course. Either adding a new one or updating a current one.
//    func uploadCourse(id: String, name: String, address: String, latitude: Double?, longitude: Double?, imageData: Data?, difficulty: Difficulty, holes: [Hole], challenges: [Challenge], rules: [String], hours: [String]) async throws {
//        print("\(type(of: self)).\(#function)")
//        guard let username = username, let password = password else {
//            throw ErrorAlert.loginFailed
//        }
//        do {
//            let course = try await validateCourse(id: id, name: name, address: address, latitude: latitude, longitude: longitude, imageData: imageData, difficulty: difficulty, holes: holes, challenges: challenges, rules: rules, hours: hours)
//            try await dataService.post(course: course, url: ProductionURLs.post, username: username, password: password)
//        } catch ErrorAlert.validationFailed {
//            errorAlert = ErrorAlert.validationFailed
//        } catch ErrorAlert.postFailed {
//            errorAlert = ErrorAlert.postFailed
//        } catch {
//            errorAlert = ErrorAlert.basic("Error: \(error.localizedDescription)")
//        }
//    }
    
    func uploadCourse() async throws {
        print("\(type(of: self)).\(#function)")
        guard let username = username, let password = password else {
            throw AlertType.loginFailed
        }
        do {
            let course = try await validateCourse()
            try await dataService.post(course: course, url: ProductionURLs.post, username: username, password: password)
        } catch AlertType.validationFailed {
            errorAlert = AlertType.validationFailed
        } catch AlertType.postFailed {
            errorAlert = AlertType.postFailed
        } catch {
            errorAlert = AlertType.error(error: "Error: \(error.localizedDescription)")
        }
    }
    
}


final class DailyHoursVM: ObservableObject {
    @Published var dailyHoursArr: [DailyHours]
    @Published var otherInfo: String = "optional"
    @Published var usingEveryDay: Bool = false
    @Published var isAddingNewCell: Bool = false
    var cancelablles: Set<AnyCancellable> = []
    
    /// Initializes a DailyHours array from a string array.
    /// - Parameters:
    ///   - hours: A string array of Day and time within the same element.
    ///   - separator: Specify your own separator. Defaults to space
    init(_ hours: [String]? = nil, separator: Character = Character(" ")) {
        var tempArr: [DailyHours] = []
        if let hours = hours {
            for (i,dayHour) in hours.enumerated() {
                if i == hours.endIndex-1 {
                    guard let info = dayHour.split(separator: separator, maxSplits: 1).last?.trimmingCharacters(in: [" "]) else { break }
                    otherInfo = info
                    break
                }
                let split = dayHour.split(separator: separator, maxSplits: 1)
                guard let first = split.first, let day = DayOfWeek.from(String(first)) else { break }
                guard let hours = split.last?.trimmingCharacters(in: [" "]) else { break }
                let new = DailyHours(id: i, day: day, hours: hours)
                tempArr.append(new)
            }
            self.dailyHoursArr = tempArr
            
        } else {
            self.dailyHoursArr = [DailyHours(id: 0, day: .sunday, hours: "")]
        }
    }
    
    /// Initializes a DailyHours array from a provided dictionary of Days and times.
    /// - Parameter hours: A dictionary containing the days and hours.
    init(_ hours: [String:String]? = nil) {
        var tempArr: [DailyHours] = []
        if let hours = hours {
            for (i,dayHourCombo) in hours.enumerated() {
                guard let day = DayOfWeek.from(dayHourCombo.key.trimmingCharacters(in: [" "])) else { break }
                let hours = dayHourCombo.value.trimmingCharacters(in: [" "])
                let new = DailyHours(id: i, day: day, hours: hours)
                tempArr.append(new)
            }
            self.dailyHoursArr = tempArr
            
        } else {
            self.dailyHoursArr = [DailyHours(id: 0, day: .sunday, hours: "")]
        }
        
    }
    
    func addNewCell() {
        if let lastID: Int = dailyHoursArr.last?.id, let lastDay = dailyHoursArr.last?.day {
            let nextID = lastID + 1
            let nextDay = DayOfWeek.next(lastDay)
            let newCell: DailyHours = DailyHours(id: nextID, day: nextDay, hours: "")
            dailyHoursArr.append(newCell)
        }
    }
    
    func removeCell(at offsets: IndexSet) {
        dailyHoursArr.remove(atOffsets: offsets)
    }
    
    func setPickerListVolume(with day: DayOfWeek, for id: Int) {
        if day == .everyDay {
            usingEveryDay = true
            dailyHoursArr.removeAll { cell in
                cell.id != id
            }
        } else {
            usingEveryDay = false
        }
    }
    
    
    func encode() -> [String] {
        var encodedString: [String] = []
        dailyHoursArr.forEach { e in
            encodedString.append("\(e.day.rawValue): \(e.hours)")
        }
        encodedString.append("Other info: \(otherInfo)")
        return encodedString
    }
    
    
    func encode() -> [String:String] {
        var encodedDict: [String:String] = [:]
        dailyHoursArr.forEach { e in
            encodedDict.updateValue(e.hours, forKey: e.day.rawValue)
        }
        encodedDict.updateValue(otherInfo, forKey: "Other Info")
        return encodedDict
    }
    
}




// MARK: Models

enum DayOfWeek: String, Equatable, CaseIterable, Identifiable {
    case sunday = "Sunday"
    case monday = "Monday"
    case tuesday = "Tuesday"
    case wednesday = "Wednesday"
    case thursday = "Thursday"
    case friday = "Friday"
    case saturday = "Saturday"
    case everyDay = "Every Day"

    var id: Int {
        switch self {
        case .sunday: 0
        case .monday: 1
        case .tuesday: 2
        case .wednesday: 3
        case .thursday: 4
        case .friday: 5
        case .saturday: 6
        case .everyDay: 7
        }
    }

    static func next(_ day: DayOfWeek) -> DayOfWeek {
        switch day {
        case .sunday: return DayOfWeek.monday
        case .monday: return DayOfWeek.tuesday
        case .tuesday: return DayOfWeek.wednesday
        case .wednesday: return DayOfWeek.thursday
        case .thursday: return DayOfWeek.friday
        case .friday: return DayOfWeek.saturday
        case .saturday, .everyDay: return DayOfWeek.sunday
        }
    }
    
    static func from(_ string: String) -> DayOfWeek? {
        switch string.lowercased() {
        case "sunday": return DayOfWeek.sunday
        case "monday": return DayOfWeek.monday
        case "tuesday": return DayOfWeek.tuesday
        case "wednesday": return DayOfWeek.wednesday
        case "thursday": return DayOfWeek.thursday
        case "friday": return DayOfWeek.friday
        case "saturday": return DayOfWeek.saturday
        case "every day": return DayOfWeek.everyDay
        default: return nil
        }
    }
    
}


struct DailyHours: Identifiable, Equatable, Hashable {
    var id: Int
    var day: DayOfWeek
    var hours: String
}

