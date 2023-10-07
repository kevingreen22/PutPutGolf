//
//  SetupPlayers.swift
//  PutPutGolf
//
//  Created by Kevin Green on 9/29/23.
//

import SwiftUI

struct SetupPlayers: View {
    @EnvironmentObject var navVM: NavigationStore
    @EnvironmentObject var coursesVM: CoursesViewModel
    @StateObject var vm = SetupPlayerViewModel()
    var course: Course
    var navID: Int = 1
    
    init(_ course: Course) {
        self.course = course
    }
    
    
    var body: some View {
        VStack {
            Image(uiImage: vm.profileImage)
                .resizable()
                .scaleEffect(0.7)
                .foregroundColor(.gray)
                .modifier(EditButtonOverlay())
            
            TextField("Enter Player Name", text: $vm.playerName)
                .focused(vm.$focusedTextField)
                .font(.largeTitle)
                .multilineTextAlignment(.center)
                .padding()
                .keyboardType(.namePhonePad)
                .submitLabel(.next)
                .toolbar {
                    ToolbarItemGroup(placement: .keyboard) {
                        Button("Done") {
                            vm.focusedTextField = false
                        }
                    }
                }
                .onSubmit { vm.textFieldDidSubmit = true }
            
            Spacer()
            
            List {
                ForEach($vm.newPlayers, id: \.self) { player in
                    HStack {
                        ProfileImageThumb(image: $vm.profileImage)
                        Text("\(player.name.wrappedValue)")
                            .font(.title)
                    }
                }
                .onMove { indexSet, offset in
                    vm.newPlayers.move(fromOffsets: indexSet, toOffset: offset)
                }
                .onDelete { indexSet in
                    vm.newPlayers.remove(atOffsets: indexSet)
                }
            }
            
        }
        .animation(.easeInOut, value: vm.playerName)
        .animation(.easeInOut, value: vm.profileImage)
        .padding(.top)
        .navigationTitle("Setup Players")
        .onAppear { vm.focusedTextField = true }
        
        // LETS PUTT! button
        .overlay(alignment: .bottom) {
            Button {
                // Navigate to ScoreCard here
                let players = vm.createPlayers(on: course)
                navVM.path.append(players)
            } label: {
                VStack {
                    if vm.newPlayers.count > 0 {
                        Image("plain_ball")
                            .resizable()
                            .frame(width: 50, height: 50)
                            .animation(.easeInOut(duration: 1.0), value: vm.newPlayers)
                    }
                    Text("Let's Putt!")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding()
                }
            }
            .disabled(vm.newPlayers.count < 1)
            .padding(.top)
            .buttonStyle(.borderedProminent)
            .buttonBorderShape(.capsule)
            .controlSize(.large)
        }
        
        .navigationDestination(for: [Player].self) { players in
            ScoreCardView(course: course, players: players)
        }
    }
    
}

struct SetupPlayersView_Previews: PreviewProvider {
    static var previews: some View {
        SetupPlayers(MockData.instance.courses[0])
            .environmentObject(SetupPlayerViewModel())
            .environmentObject(NavigationStore())
            .environmentObject(CoursesViewModel(url: nil))
    }
}




fileprivate struct EditButtonOverlay: ViewModifier {
    func body(content: Content) -> some View {
        content
            .frame(width: 150, height: 150)
            .overlay(alignment: .bottom) {
                Button {
                    // choose profile photo here
                    
                } label: {
                    Text("Edit")
                        .font(.title2)
                        .foregroundColor(.white)
                        .offset(y: 5)
                        .padding()
                }
                .background(alignment: .bottom) {
                    Color.black.opacity(0.6)
                        .frame(width: 150, height: 45)
                        .blur(radius: 5)
                        .clipped()
                }
            } // edit button
            .clipShape(Circle())
            .padding(3)
            .overlay { Circle() .stroke(lineWidth: 2) } // border
    }
}


fileprivate struct ProfileImageThumb: View {
    @Binding var image: UIImage
    
    var body: some View {
        Image(uiImage: image)
            .foregroundColor(.clear)
            .frame(width: 50, height: 50)
            .clipShape(Circle())
            .padding(3)
            .overlay {
                Circle()
                    .stroke(lineWidth: 2)
            }
            .onTapGesture {
                // choose profile photo here
                
            }
    }
}