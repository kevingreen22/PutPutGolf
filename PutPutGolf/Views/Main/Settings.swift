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

    @AppStorage(UDKeys.audio) var allowAudio: Bool = true
    @AppStorage(UDKeys.haptics) var allowHaptics: Bool = true
    
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



// MARK: View Components
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
                    .onChange(of: allowAudio) { _ in
                        if allowAudio {
                            try? SoundManager.instance.playeffect("golf_swing")
                        }
                    }
                
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
                    .haptic(impact: .rigid, trigger: allowHaptics) { _ in
                        allowHaptics ? true : false
                    }
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
                .haptic(impact: .soft, trigger: showLogin) { _ in
                    allowHaptics ? true : false
                }
        }
        .buttonStyle(.borderedProminent)
        .bordered(shape: Capsule(), color: Color.white, lineWidth: 5)
        .clipShape(Capsule())
        .shadow(radius: 8)
        .padding(.bottom, 12)

    }
    
}




// MARK: User Defaults Keys
struct UDKeys {
    static let audio = "app_audio"
    static let haptics = "app_haptics"
}
