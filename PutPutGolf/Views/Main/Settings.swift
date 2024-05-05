//
//  Settings.swift
//  PutPutGolf
//
//  Created by Kevin Green on 4/26/24.
//

import SwiftUI
import KGViews

struct Settings: View {
    let dataService: any DataServiceProtocol
    
    @EnvironmentObject var coursesVM: CoursesMap.ViewModel

    @AppStorage("app_audio") var allowAudio: Bool = true
    @AppStorage("app_haptics") var allowHaptics: Bool = true
    
    @State private var backgroundRectSize: CGRect = .zero
    @State private var showLogin: Bool = false
    @State private var loginCredentialsValid = false
    
    
    var body: some View {
        ZStack {
            KGRealBlur(style: .dark).ignoresSafeArea()
                .rectReader($backgroundRectSize, in: .global)
                
            ZStack {
                VStack {
                    title
                    toggles
                    adminLoginButton.padding(.top, 8)
                    Text("Version: \(Bundle.version())")
                        .foregroundStyle(Color.gray)
                        .padding(.bottom, 8)
                }
                .padding(.top, 16)
                .padding(.horizontal, 8)
            }
            .frame(width: backgroundRectSize.size.width * 0.8)
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 25))
            .bordered(shape: RoundedRectangle(cornerRadius: 25), color: Color.accentColor, lineWidth: 5)
        }
        
        .overlay(alignment: .bottom) {
            CloseButton()
                .padding(.bottom, 8)
        } // Close Button
        
        .fullScreenCover(isPresented: $showLogin) {
            if loginCredentialsValid {
                CoursesInfo(loginCredentialsValid: $loginCredentialsValid, dataService: dataService, courses: coursesVM.coursesData)
                    .animation(.easeInOut(duration: 1), value: loginCredentialsValid)
                    .transition(.opacity.combined(with: .scale))
            } else {
                LoginView(loginCredentialsValid: $loginCredentialsValid, dataService: dataService)
                    .animation(.easeInOut(duration: 1), value: loginCredentialsValid)
                    .transition(.opacity.combined(with: .scale))
            }
        }
    }
    
}

#Preview {
    let dataService = MockDataService(mockData: MockData.instance)
    
    return ZStack {
        Image("golf_course").resizable().ignoresSafeArea()
        Settings(dataService: dataService)
            .environmentObject(CoursesMap.ViewModel())
    }
}



// MARK: Components
extension Settings {
    
    var title: some View {
        Text("Settings")
            .font(.largeTitle)
            .fontWeight(.bold)
            .foregroundStyle(Color.accentColor)
    }
    
    var toggles: some View {
        HStack {
            HStack(spacing: 12) {
                Image(systemName: "speaker.wave.2.fill")
                    .resizable()
                    .frame(width: 24, height: 24)
                Toggle("", isOn: $allowAudio)
                    .labelsHidden()
                    .toggleStyle(GolfToggleStyle())
                    .frame(width: 70)
                
            }
            .frame(alignment: .leading)
            .padding(.leading, 8)
            
            Spacer()
            Divider().frame(maxHeight: 35)
            Spacer()
            
            HStack(spacing: 12) {
                Image(systemName: "iphone.gen2.radiowaves.left.and.right")
                    .resizable()
                    .frame(width: 30, height: 26)
                Toggle("", isOn: $allowHaptics)
                    .labelsHidden()
                    .toggleStyle(GolfToggleStyle())
                    .frame(width: 70)
            }
            .frame(alignment: .leading)
            .padding(.trailing, 8)
        }
        .padding(8)
        .background {
            Capsule()
                .fill(Color.gray.opacity(0.7))
        }
        .padding(.horizontal, 8)
    }
    
    var adminLoginButton: some View {
        Button {
            self.showLogin.toggle()
        } label: {
            Text("Admin Login")
                .font(.title)
                .fontWeight(.semibold)
                .padding(.vertical, 4)
                .padding(.horizontal, 28)
        }
        .buttonStyle(.borderedProminent)
        .bordered(shape: Capsule(), color: Color.white, lineWidth: 5)
        .clipShape(Capsule())
        .shadow(radius: 8)
        .padding(.bottom, 12)

    }
    
}




struct GolfToggleStyle: ToggleStyle {
    @State private var handleRect: CGRect = .zero
    
    func makeBody(configuration: Configuration) -> some View {
        GeometryReader { proxy in
            ZStack {
                Capsule()
                    .fill(configuration.isOn ? Color.accentColor : Color.gray)
                    .bordered(shape: Capsule(), color: Color.accentColor, lineWidth: 1)
                
                    .overlay(alignment: .leading) {
                        Image(systemName: "checkmark")
                            .resizable()
                            .scaledToFit()
                            .scaleEffect(0.4)
                            .foregroundStyle(Color.white)
                            .opacity(configuration.isOn ? 1 : 0)
                    }
                
                    .overlay(alignment: .trailing) {
                        Image(systemName: "xmark")
                            .resizable()
                            .scaledToFit()
                            .scaleEffect(0.4)
                            .foregroundStyle(Color.red)
                            .opacity(configuration.isOn ? 0 : 1)
                    }
                
                    .overlay(alignment: .center) {
                        Image("golf_ball")
                            .resizable()
                            .scaledToFit()
                            .shadow(radius: 3)
                            .padding(.vertical, 2)
                            .padding(.leading, 2)
                            .padding(.trailing, 1)
                            .rectReader($handleRect, in: .local)
                            .offset(x: configuration.isOn ? proxy.size.width/2-handleRect.size.width/2 : -proxy.size.width/2+handleRect.size.width/2)
                            .onTapGesture {
                                configuration.isOn.toggle()
                            }
                            .gesture(
                                DragGesture()
                                    .onEnded { value in
                                        configuration.isOn.toggle()
                                    }
                            )
                    }
                configuration.label
            }.animation(.easeInOut(duration: 0.15), value: configuration.isOn)
        }.frame(height: 34)
    }
}

