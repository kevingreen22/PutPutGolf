//
//  ForceOrientation.swift
//  PutPutGolf
//
//  Created by Kevin Green on 12/12/23.
//

import SwiftUI

extension View {
    
    /// Forces the view to rotate to the spcecified orientation.
    /// Add this line in the @main app file: @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    /// - Parameter orientation: The iPhone orientation to show.
    @ViewBuilder func forceRotation(orientation: UIInterfaceOrientationMask) -> some View {
        if UIDevice.current.userInterfaceIdiom == .phone {
            let currentOrientation = AppDelegate.orientationLock
            self.onAppear() {
                AppDelegate.orientationLock = orientation
            }.onDisappear() {
                AppDelegate.orientationLock = currentOrientation
            } // <- Reset orientation to previous setting
        } else {
            self
        }
    }
    
    /// Locks a view to a specified orientation.
    /// Add this line in the @main app file: @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    /// - Parameter orientation: The orientation to lock the view in.
    @ViewBuilder func lockOrientation(to orientation: UIInterfaceOrientationMask) -> some View {
        if UIDevice.current.userInterfaceIdiom == .phone {
            self.onAppear() {
                AppDelegate.orientationLock = orientation
            }
        } else {
            self
        }
    }
    
}

enum Orientation: Int, CaseIterable {
    case landscapeLeft
    case landscapeRight
    case portrait
    
    var title: String {
        switch self {
        case .landscapeLeft:
            return "LandscapeLeft"
        case .landscapeRight:
            return "LandscapeRight"
        case .portrait:
            return "Portrait"
        }
    }
    
    var mask: UIInterfaceOrientationMask {
        switch self {
        case .landscapeLeft:
            return .landscapeLeft
        case .landscapeRight:
            return .landscapeRight
        case .portrait:
            return .portrait
        }
    }
}


class AppDelegate: NSObject, UIApplicationDelegate {

    static var orientationLock = UIInterfaceOrientationMask.portrait {
        didSet {
            if #available(iOS 16.0, *) {
                UIApplication.shared.connectedScenes.forEach { scene in
                    if let windowScene = scene as? UIWindowScene {
                        windowScene.requestGeometryUpdate(.iOS(interfaceOrientations: orientationLock))
                        windowScene.windows.first?.rootViewController?.setNeedsUpdateOfSupportedInterfaceOrientations()
                    }
                }
                
            } else {
                if orientationLock == .landscape {
                    UIDevice.current.setValue(UIInterfaceOrientation.landscapeRight.rawValue, forKey: "orientation")
                } else {
                    UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
                }
            }
        }
    }
    
}
