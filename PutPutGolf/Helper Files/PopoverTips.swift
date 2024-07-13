//
//  Tips.swift
//
//  Created by Kevin Green on 6/20/24.
//
// EXAMPLE FILE

import SwiftUI
import TipKit

@available(iOS, introduced: 17.0)
struct AppTips {
    
    struct ExampleTip: Tip {
        static var someEvent = Event(id: "someEvent")
        static var visitedView = Event(id: "visited")
        
        var title: Text {
            Text("Example Tip")
        }
        
        var message: Text?
        
        var image: Image?
        
        var rules: [Rule] {
            #Rule(Self.someEvent) { event in
                event.donations.count == 0
            }
            #Rule(Self.visitedView) { event in
                event.donations.count > 2
            }
        }
    }
    
    static var exampleTip = ExampleTip()
    
}



@available(iOS 17.0, *)
#Preview {
    Rectangle()
        .fill(Color.indigo)
        .frame(width: 200, height: 200)
        .popoverTip(AppTips.exampleTip)
        .task {
            await AppTips.ExampleTip.someEvent.donate() // <-- increments the "donation" amount for the tips specific rule event.
        }
        .onAppear {
            Task {
                await AppTips.ExampleTip.visitedView.donate() // <-- increments the "donation" amount for the tips specific rule event.
            }

        }
        .task {
            try? Tips.resetDatastore()
            try? Tips.configure([
                .datastoreLocation(.applicationDefault)
            ])
        }
}

