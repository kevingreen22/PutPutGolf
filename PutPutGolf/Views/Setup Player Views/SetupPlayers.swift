//
//  SetupPlayers.swift
//  PutPutGolf
//
//  Created by Kevin Green on 9/29/23.
//

import SwiftUI
import KGImageChooser

struct SetupPlayers: View {
    @EnvironmentObject var navVM: NavigationStore
    @StateObject var vm = SetupPlayerViewModel()
    @FocusState var isFocused: Bool
    var course: Course
    var navID: Int = 1

    init(_ course: Course) {
        print("\(type(of: self)).\(#function)")
        self.course = course
    }
    
    
    var body: some View {
//        GeometryReader { _ in
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
                .onAppear { isFocused = true }
                .navigationTitle("Setup Players")
                .navigationDestination(for: SavedGame.self) { savedGame in
                    ScoreCardView(course: savedGame.course, players: savedGame.players, isResumingGame: true)
                }
            }
            .fullScreenCover(isPresented: $vm.showImageChooser) {
                KGCameraImageChooser(uiImage: $vm.profileImage)
            }
//        }
        
            .staticKeyboard()
        
//        .task {
//            vm.checkForCurrentGameOn(course: course)
//        }
        
//        .alert("It looks like you are already playing a game on this course. Would you like to continue that game?", isPresented: $vm.showCurrentGameAlert) {
//            Button("Yes, Lets Putt!", systemImage: "figure.golf") {
//                navVM.path.append(vm.savedGame)
//            }
//            Button("No, start a new game.", systemImage: "xmark", role: .cancel) {}
//        }
        
//        .ignoresSafeArea(.keyboard) // this coupled with the GeometryReader makes it so the view doesn't move up when the key board is shown.
        
    }
}

struct SetupPlayersView_Previews: PreviewProvider {
    static let mockData = MockData.instance
    
    static var previews: some View {
        SetupPlayers(mockData.courses[0])
            .environmentObject(SetupPlayerViewModel())
            .environmentObject(NavigationStore())
            .environmentObject(CoursesViewModel(coursesData: mockData.courses))
    }
}




extension SetupPlayers {
    
    fileprivate var profileImage: some View {
        Image(uiimage: vm.profileImage)
            .resizable()
            .frame(width: 150, height: 150)
            .foregroundStyle(vm.profileImage == nil ? Color.gray.opacity(0.2) : Color.clear)
            .background { Color.white }
            .clipShape(Circle())
            .shadow(radius: 10)
            .overlay { Circle().stroke(lineWidth: 3) } // border
            .overlay(alignment: .bottom) {
                HStack {
                    Button(action: { vm.showImageChooser = true }, label: {
                        Image(systemName: "pencil")
                            .resizable()
                            .foregroundStyle(Color.primary)
                            .frame(width: 15, height: 15)
                            .background(
                                Circle()
                                    .fill(Color.white)
                                    .frame(width: 27, height: 27)
                            )
                            .shadow(radius: 5)
                            .offset(x: 7)
                    })
                    Spacer()
                    ColorPicker("", selection: $vm.pickedColor, supportsOpacity: false)
                        .shadow(radius: 5)
                }
                .offset(y: -10)
            } // edit & color buttons
            .environmentObject(vm)
    }
    
    fileprivate var playerNameTextField: some View {
        TextField("Enter Player Name", text: $vm.playerName)
            .focused($isFocused)
            .font(.largeTitle)
            .multilineTextAlignment(.center)
            .padding()
            .keyboardType(.namePhonePad)
            .submitLabel(.next)
            .toolbar { // keyboard upper done button
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    Button("Done") { vm.textFieldDidSubmit = true; isFocused = false }
                        .buttonStyle(.automatic)
                }
            }
            .onSubmit {
                vm.textFieldDidSubmit = true
                isFocused = true
            }
    }
    
    fileprivate var playerList: some View {
        List {
            ForEach($vm.newPlayers, id: \.self) { player in
                HStack {
                    profileImageThumb(image: player.image.wrappedValue, color: player.color.wrappedValue)
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
    
    fileprivate func profileImageThumb(image: UIImage?, color: Color) -> some View {
        Image(uiimage: image)
            .resizable()
            .frame(width: 50, height: 50)
            .foregroundStyle(image == nil ? Color.gray : Color.clear)
            .background(Color.white)
            .clipShape(Circle())
            .padding(3)
            .overlay { Circle().stroke(color, lineWidth: 2) } // border
    }
    
    fileprivate var letsPuttButton: some View {
        Button {
            // Navigate to ScoreCard here
            let players = vm.createPlayers(on: course)
            navVM.path.append(players)
        } label: {
            Image("plain_ball")
                .resizable()
                .frame(width: 100, height: 100)
                .overlay {
                    Text("Lets Putt!")
                        .foregroundStyle(Color.red)
                        .font(.title3)
                        .fontWeight(.bold)
                        .padding()
                }
        }
        .padding([.top, .bottom])
        .disabled(vm.newPlayers.count > 0 ? false : true)
        .grayscale(vm.newPlayers.count > 0 ? 0 : 1)
        .opacity(vm.newPlayers.count > 0 ? 1 : 0.5)
    }
    
}

