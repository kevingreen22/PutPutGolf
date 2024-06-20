//
//  Toggle3Way.swift
//  PutPutGolf
//
//  Created by Kevin Green on 3/18/24.
//

import SwiftUI

public struct Toggle3Way: View {
    
    fileprivate struct DragPosition {
        static var leading: CGPoint = .zero
        static var zero: CGPoint = .zero
        static var trailing: CGPoint = .zero
        
        init(leading: CGPoint, zero: CGPoint, trailing: CGPoint) {
            Toggle3Way.DragPosition.leading = leading
            Toggle3Way.DragPosition.zero = zero
            Toggle3Way.DragPosition.trailing = trailing
        }
    }
    
    var onSlideLeading: ()->Bool
    var onSlideTrailing: ()->Bool
    
    @State private var dragPosition: CGPoint = .zero
    @State private var sliderRect: CGRect = .zero
    @State private var guideRect: CGRect = .zero
    @State private var slideCompleted = false
    
    @State private var leadingArrowOffset: CGFloat = 20
    @State private var trailingArrowOffset: CGFloat = -20
    @State private var arrowOpacity: Double = 1
    
    @State private var timer = Timer.publish(every: 0.01, on: .main, in: .common).autoconnect()
    @State private var isTimerRunning = true
    
    var sliderHandleImage: Image?
    var leadingSliderImage: Image?
    var trailingSliderImage: Image?
    
    
    init(
        sliderHandleImage: Image? = nil,
        leadingSliderImage: Image? = nil,
        trailingSliderImage: Image? = nil,
        onSlideLeading: @escaping ()->Bool,
        onSlideTrailing: @escaping ()->Bool
    ) {
        self.sliderHandleImage = sliderHandleImage
        self.leadingSliderImage = leadingSliderImage
        self.trailingSliderImage = trailingSliderImage
        self.onSlideLeading = onSlideLeading
        self.onSlideTrailing = onSlideTrailing
    }
    
    
    public var body: some View {
        Capsule() // Slider guide background
            .foregroundStyle(Color.gray)
            .coordinateSpace(name: "slider_guide")
            .rectReader($guideRect, in: .named("slider_guide"))
        
            .overlay { // Slider guide grove line
                ZStack {
                    Capsule()
                        .frame(width: leadingSliderImage != nil || trailingSliderImage != nil ? guideRect.width * 0.6 : guideRect.width * 0.75, height: 2)
                        .opacity(0.1)
                        .padding(.horizontal)
//                    HStack {
//                        Spacer()
//                        Image(systemName: "arrowtriangle.backward.fill")
//                            .foregroundStyle(Color.white)
//                            .offset(x: leadingArrowOffset)
//                            .opacity(arrowOpacity)
//                        Spacer()
//                        Image(systemName: "arrowtriangle.forward.fill")
//                            .foregroundStyle(Color.white)
//                            .offset(x: trailingArrowOffset)
//                            .opacity(arrowOpacity)
//                        Spacer()
//                    }
                }
            } // Slider guide grove line
        
            .overlay(alignment: .leading) { // Leading image
                if let leadingSliderImage {
                    leadingSliderImage
                        .resizable()
                        .scaledToFit()
                        .scaleEffect(0.4)
                        .opacity(0.5)
                }
            } // Leading image
        
            .overlay(alignment: .trailing) { // Trailing image
                if let trailingSliderImage {
                    trailingSliderImage
                        .resizable()
                        .scaledToFit()
                        .scaleEffect(0.4)
                        .opacity(0.5)
                }
            } // Trailing image
        
            .overlay { // Handle
                toggleHandle
            } // Handle
        
            .task {
                dragPosition.x = guideRect.midX
                dragPosition.y = guideRect.midY
                
                let _ = DragPosition(
                    leading: CGPoint(x: guideRect.minX+sliderRect.width/2, y: 0) ,
                    zero: CGPoint(x: guideRect.midX, y: 0),
                    trailing: CGPoint(x: guideRect.maxX-sliderRect.width/2, y: 0)
                )
            }
        
        // This is used for the animating arrows.
        //            .onReceive(timer) { output in
        //                withAnimation(.linear(duration: 1.5).delay(0.3).repeatForever(autoreverses: false)) {
        //                    leadingArrowOffset = -45
        //                    trailingArrowOffset = 45
        //                    arrowOpacity = 0
        //                }
        //            }
        
        // This is used for the animating arrows.
        //            .onAppear {
        //                stop()
        //                start()
        //            }
        
    }
    
    @ViewBuilder private var toggleHandle: some View {
        if let sliderHandleImage {
            sliderHandleImage
                .resizable()
                .scaledToFit()
                .scaleEffect(0.92)
                .rectReader($sliderRect, in: .named("slider_guide"))
                .position(dragPosition)
                .gesture(dragGesture)
        } else {
            Image(systemName: "circle.fill")
                .resizable()
                .foregroundStyle(Color.white)
                .bordered(shape: Circle(), color: Color.gray, lineWidth: 3)
                .scaledToFit()
                .scaleEffect(0.92)
                .rectReader($sliderRect, in: .named("slider_guide"))
                .position(dragPosition)
                .gesture(dragGesture)
        }
    }
    
    fileprivate var dragGesture: some Gesture {
        DragGesture()
            .onChanged { value in
                // Check for sliding to leading edge.
                if dragPosition.x-sliderRect.width/2 <= guideRect.minX {
                    dragPosition.x = max(value.location.x, DragPosition.leading.x)
                    
                // Check for sliding to trailing edge.
                } else if dragPosition.x+sliderRect.width/2 >= guideRect.maxX {
                    dragPosition.x = min(value.location.x, DragPosition.trailing.x)
                } else {
                    dragPosition.x = value.location.x
                }
            }
        
            .onEnded { value in
                if dragPosition.x == DragPosition.leading.x {
                    onSlideLeading() ? (resetHandle(.now()+1)) : (resetHandle())
                } else if dragPosition.x == DragPosition.trailing.x {
                    onSlideTrailing() ? (resetHandle(.now()+1)) : (resetHandle())
                } else {
                    dragPosition.x = DragPosition.zero.x
                }
            }
    }
    
    
    //    fileprivate func hideArrows(_ hide: Bool) {
    //        if hide {
    //            if isTimerRunning {
    //                print("cancel timer")
    //                arrowOpacity = 0
    //                stop()
    //                isTimerRunning = false
    //            }
    //        } else {
    //            print("start timer")
    //            isTimerRunning = true
    //            start()
    //            arrowOpacity = 1
    //        }
    //    }
    //    func stop() {
    //      timer.upstream.connect().cancel()
    //    }
    //    func start() {
    //      timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    //    }
    
    fileprivate func resetHandle(_ delay: DispatchTime = .now(), animation: Animation = .bouncy) {
        DispatchQueue.main.asyncAfter(deadline: delay) {
            withAnimation(animation) {
                dragPosition.x = guideRect.midX
            }
        }
    }
}

#Preview {
    return VStack {
        Toggle3Way(onSlideLeading: {
            print("slide leading")
            return true
        }, onSlideTrailing: {
            print("slide trailing")
            return true
        })
        .frame(height: 100)
        .padding(.horizontal, 16)
        
        Toggle3Way(
            sliderHandleImage: Image("golf_ball"),
            leadingSliderImage: Image(systemName: "flag.checkered.circle"),
            trailingSliderImage: Image(systemName: "flag.circle"),
            onSlideLeading: {
                return false
            }, onSlideTrailing: {
                return false
            }
        )
        .bordered(shape: Capsule(), color: .accentColor, lineWidth: 5)
        .frame(height: 100)
        .padding(.horizontal, 16)
    }
}

