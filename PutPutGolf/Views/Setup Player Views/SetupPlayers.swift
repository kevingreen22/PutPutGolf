//
//  SetupPlayers.swift
//  PutPutGolf
//
//  Created by Kevin Green on 9/29/23.
//

import SwiftUI

struct SetupPlayers: View {
    @EnvironmentObject var navVM: NavigationStore
    @StateObject var vm = SetupPlayerViewModel()
    @FocusState var focusedTextField
    var course: Course
    var navID: Int = 1

    init(_ course: Course) {
        self.course = course
    }
    
    
    var body: some View {
        GeometryReader { _ in
            ZStack {
                Color.green.ignoresSafeArea()
                VStack {
                    profileImage
                    playerNameTextField
                    Spacer()
                    playerList
                    letsPuttButton
                }
                .animation(.easeInOut, value: vm.playerName)
                .animation(.easeInOut, value: vm.profileImage)
                .padding(.top)
                .onAppear { focusedTextField = true }
                .navigationTitle("Setup Players")
                .navigationDestination(for: [Player].self) { players in
                    ScoreCardView(course: course, players: players)
                }
            }
        }
        .ignoresSafeArea(.keyboard) // this coupled with the GeometryReader makes it so the view doesn't move up when the key board is shown.
    }
}

struct SetupPlayersView_Previews: PreviewProvider {
    static let mockdata = MockData.instance
    
    static var previews: some View {
        SetupPlayers(MockData.instance.courses[0])
            .environmentObject(SetupPlayerViewModel())
            .environmentObject(NavigationStore())
            .environmentObject(CoursesViewModel(dataService: MockDataService(mockData: mockdata)))
    }
}




extension SetupPlayers {
    
    fileprivate var profileImage: some View {
        Image(uiImage: vm.profileImage)
            .resizable()
            .scaledToFit()
            .padding()
            .background { Color.white }
            .modifier(EditButtonOverlay(size: CGSize(width: 150, height: 150)))
            .overlay { Circle() .stroke(lineWidth: 3) } // border
            .frame(width: 150, height: 150)
    }
    
    fileprivate var playerNameTextField: some View {
        TextField("Enter Player Name", text: $vm.playerName)
            .focused($focusedTextField)
            .font(.largeTitle)
            .multilineTextAlignment(.center)
            .padding()
            .keyboardType(.namePhonePad)
            .submitLabel(.next)
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    Button {
                        focusedTextField = false
                    } label: {
                        Text("Done")
                            .fontWeight(.semibold)
                    }
                }
            }
            .onSubmit { vm.textFieldDidSubmit = true; focusedTextField = true }
    }
    
    fileprivate var playerList: some View {
        List {
            ForEach($vm.newPlayers, id: \.self) { player in
                HStack {
                    profileImageThumb(image: $vm.profileImage)
                    Text("\(player.name.wrappedValue)")
                        .font(.title)
                        .padding(.leading)
                    Spacer()
                    Image(systemName: "line.3.horizontal")
                }
            }
            
            .onMove { indexSet, offset in
                vm.newPlayers.move(fromOffsets: indexSet, toOffset: offset)
            }
            .onDelete { indexSet in
                vm.newPlayers.remove(atOffsets: indexSet)
            }
        }
        .frame(minHeight: 300)
    }
    
    fileprivate func profileImageThumb(image: Binding<UIImage>) -> some View {
        Button {
            // choose profile photo here
            
        } label: {
            Image(uiImage: image.wrappedValue)
                .frame(width: 50, height: 50)
                .background(Color.white)
                .clipShape(Circle())
                .padding(3)
                .overlay { Circle() .stroke(lineWidth: 2) }
        }
        .foregroundStyle(Color.primary)
    }
    
    fileprivate var letsPuttButton: some View {
        Button {
            // Navigate to ScoreCard here
            let players = vm.createPlayers(on: course)
            navVM.path.append(players)
        } label: {
            Text("Let's Putt!")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding()
        }
        .disabled(vm.newPlayers.count < 1)
        .padding(.top)
        .buttonStyle(.borderedProminent)
        .buttonBorderShape(.capsule)
        .controlSize(.large)
    }
    
}


fileprivate struct EditButtonOverlay: ViewModifier {
    var size: CGSize
    
    func body(content: Content) -> some View {
        content
            .overlay(alignment: .bottom) {
                Button {
                    // choose profile photo here
                    
                } label: {
                    Text("Edit")
                        .font(.title2)
                        .foregroundColor(.white)
                        .offset(y: -5)
                }
                .background(alignment: .bottom) {
                    Color.gray
                        .frame(width: size.width, height: size.width/4)
                        .blur(radius: 5)
                        .clipped()
                }
            } // edit button
            .clipShape(Circle())
            .padding(3)
    }
}
