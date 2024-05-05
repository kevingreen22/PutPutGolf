//
//  NotificationPill.swift
//
//  Created by Kevin Green on 1/11/24.
//

import SwiftUI
import Combine

// Model
enum Pills: Pill {
    case uploadComplete
    case uploadFailed
    
    var id: UUID {
        return UUID()
    }
    
    var text: String {
        switch self {
        case .uploadComplete: "Upload Complete"
        case .uploadFailed: "Upload Failed"
        }
    }
    
    var icon: String {
        switch self {
        case .uploadComplete: "checkmark"
        case .uploadFailed: "exclamationmark.triangle.fill"
        }
    }
    
    var color: Color {
        switch self {
        default: Color.white
        }
    }
    
    var diminishingReturn: Double {
        switch self {
        default: 2
        }
    }
    
}

public protocol Pill: Equatable, Identifiable {
    var id: UUID { get }
    var text: String { get }
    var icon: String { get }
    var color: Color { get }
    var diminishingReturn: Double { get }
}

private struct NotificationPillItem<T: Pill>: View {
    @Binding var pill: T?
    
    @State private var show: Bool = false
    @State private var timer = Timer.publish(every: 1, on: .main, in: .common)
    @State private var seconds: Double = 0
    @State private var cancellables = Set<AnyCancellable>()
        
    init(_ pill: Binding<T?>) {
        _pill = pill
    }
    
    var body: some View {
//        ZStack(alignment: .bottom) {
            VStack {
                Spacer()
                Label(pill?.text ?? "", systemImage: pill?.icon ?? "")
                    .font(.title3)
                    .padding()
                    .background(pill?.color.clipShape(Capsule()))
                    .lineLimit(1)
                    .shadow(radius: 10)
            }
//        }
        .offset(y: show ? 20 : 100)
        .animation(.bouncy(duration: 0.3), value: show)
        .onChange(of: show) { value in
            if value {
                timer = Timer.publish(every: 1, on: .main, in: .common)
                timer.connect().store(in: &cancellables)
                print("notification pill - timer started - show: \(String(describing: pill))")
            } else {
                self.timer.connect().cancel()
                print("notification pill - timer canceled - show: \(String(describing: pill))")
            }
        }
        .onReceive(timer) { time in
            print("notification pill - seconds: \(time)")
            if seconds == pill?.diminishingReturn ?? 2 {
                show.toggle()
                pill = nil
                seconds = 0
            } else {
                seconds += 1
            }
        }
        .onChange(of: pill) { value in
            value != nil ? (show = true) : (show = false)
        }
    }
}

private struct NotificationPillBool: View {
    @Binding var show: Bool
    var text: String
    var systemImage: String
    var color: Color
    var diminishingReturn: Double
    
    @State private var timer = Timer.publish(every: 1, on: .main, in: .common)
    @State private var seconds: Double = 0
    @State private var cancellables = Set<AnyCancellable>()
        
    init(_ show: Binding<Bool>, text: String, systemImage: String = "", color: Color = .white, diminishingReturn: Double = 2) {
        _show = show
        self.text = text
        self.systemImage = systemImage
        self.color = color
        self.diminishingReturn = diminishingReturn
    }
    
    var body: some View {
//        ZStack(alignment: .bottom) {
            VStack {
                Spacer()
                Label(text, systemImage: systemImage)
                    .font(.title3)
                    .padding()
                    .background(color.clipShape(Capsule()))
                    .lineLimit(1)
                    .shadow(radius: 10)
            }
//        }
        .offset(y: show ? 20 : 100)
        .animation(.bouncy(duration: 0.3), value: show)
        .onChange(of: show) { value in
            if value {
                timer = Timer.publish(every: 1, on: .main, in: .common)
                timer.connect().store(in: &cancellables)
                print("notification pill - timer started - show: \(show)")
            } else {
                self.timer.connect().cancel()
                print("notification pill - timer canceled - show: \(show)")
            }
        }
        .onReceive(timer) { time in
            print("notification pill - seconds: \(time)")
            if seconds == diminishingReturn {
                show.toggle()
                seconds = 0
            } else {
                seconds += 1
            }
        }
    }
}


public extension View {
    
    /// Presents a notification at the bottom of the screen when a given condition is true, using a localized string key for the text and a localized string key for an optional system icon.
    /// - Parameters:
    ///   - show: A binding to a Boolean value that determines whether to present the notification. The system sets this value to false and dismisses automatically according to the diminishing return value.
    ///   - text: The key for the localized string that describes the title of the notification. Default is empty.
    ///   - systemImage: The key for the localized string that describes a system image of the notification.
    ///   - color: An optional color value to set for the background of the notification. Default is white.
    ///   - diminishingReturn: A value in seconds. Default is 2 seconds.
    ///
    ///   This notification is a non intrusive alternative to the standard alert that needs no user interaction. A great alternative for devices that do not have the dynamic island.
    func notificationPill(_ show: Binding<Bool>, text: String, systemImage: String = "", color: Color = .white, diminishingReturn: Double = 2) -> some View {
        ZStack {
            self
            NotificationPillBool(show, text: text, systemImage: systemImage, color: color)
        }
    }
    
    /// Presents a notification at the bottom of the screen when a given source of true is non-nil, using a localized string key for the text and a localized string key for an optional system icon.
    /// - Parameters:
    ///   - item: A binding to an optional source of truth for the notification pill. If item is non-nil, the system passes the contents to the modifier’s closure. You use this content to populate the fields of a notification pill that you create that the system displays to the user. If item changes, the system dismisses the currently displayed alert and replaces it with a new one using the same process.
    ///
    ///   This notification is a non-intrusive alternative that needs no user interaction to the standard alert. A great alternative for devices that do not have the dynamic island.
    func notificationPill<T: Pill>(_ item: Binding<T?>) -> some View {
        ZStack {
            self
            NotificationPillItem(item)
        }.frame(width: .infinity, height: .infinity)
    }
    
}




/// Preview
struct PreviewContentView: View {
    @State var myPill: Pills? = nil
    
    var body: some View {
        ZStack(alignment: .center) {
            Button("Show pill") {
                myPill = .uploadFailed
            }.buttonStyle(.borderedProminent)
        }.notificationPill($myPill)
    }
    
}
#Preview {
    PreviewContentView()
}



