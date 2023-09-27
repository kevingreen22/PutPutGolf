//
//  MainView.swift
//  PutPutGolf
//
//  Created by Kevin Green on 9/24/23.
//

import SwiftUI

struct MainView: View {
    let courseAPIurl = URL(string: "https://my.apiEndpoint.courses")
    
    var body: some View {
        TabView {
            CoursesMapView(url: nil)
                .tabItem {
                    Label("Courses", systemImage: "figure.golf")
                }
            
            ScoreCardView()
                .tabItem {
                    Label("Scorecards", systemImage: "menucard.fill")
                }
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}













// Set:
//someView()
//  .environment(\.kgScreenSize, KGScreenSize(view: contentView)

//struct KGScreenSize {
//    @State var screenSize: CGSize = .zero
//
//    init(view: any View) {
//        let _ = view
//            .overlay(
//                GeometryReader { proxy in
//                    Color.clear.preference(key: SizePreferenceKey.self, value: proxy.size)
//                }
//            )
//            .onPreferenceChange(SizePreferenceKey.self) { value in
//                screenSize = value
//            }
//    }
    
//    private struct SizePreferenceKey: PreferenceKey {
//        static var defaultValue: CGSize = .zero
//        static func reduce(value: inout CGSize, nextValue: () -> CGSize) {
//            value = nextValue()
//        }
//    }
//}


//struct KGScreenSizeKey: EnvironmentKey {
//    static var defaultValue: KGScreenSize = KGScreenSize(view: )
//}
//
//extension EnvironmentValues {
//    var kgScreenSize: KGScreenSize {
//        get { self[KGScreenSizeKey.self] }
//        set { self[KGScreenSizeKey.self] = newValue }
//    }
//}
