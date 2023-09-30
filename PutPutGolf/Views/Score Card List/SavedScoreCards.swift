//
//  ScoreCardsList.swift
//  PutPutGolf
//
//  Created by Kevin Green on 9/28/23.
//

import SwiftUI

struct SavedScoreCards: View {
//    var scoreCards: [ScoreCards]
        
    var body: some View {
        List {
//            ForEach(MockData.instance.players[0].savedScoreCards, id: \.self) { savedCard in
//                Text(savedCard.course.name)
//            }
            Text("score card list")
        }
    }
}

struct ScoreCardsList_Previews: PreviewProvider {
    static var previews: some View {
        SavedScoreCards()
    }
}


