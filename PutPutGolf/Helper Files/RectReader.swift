//
//  RectReader.swift
//
//  Created by Kevin Green on 3/23/24.
//

import SwiftUI

public extension View {
    
    
    func rectReader(_ binding: Binding<CGRect>, in space: CoordinateSpace) -> some View {
        self.background(GeometryReader { (geometry) -> AnyView in
            let rect = CGRectMake(0, 0, geometry.frame(in: space).width, geometry.frame(in: space).height)
            DispatchQueue.main.async {
                binding.wrappedValue = rect
            }
            return AnyView(Rectangle().fill(Color.clear))
        })
    }
}
