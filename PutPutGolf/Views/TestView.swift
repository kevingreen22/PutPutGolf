//
//  TestView.swift
//  PutPutGolf
//
//  Created by Kevin Green on 10/20/23.
//

import SwiftUI

struct TestView: View {
    var body: some View {
        VStack(spacing: 0) {
            Rectangle()
                .fill(Color(uiColor: .separator))
                .frame(height: 0.5)
            Rectangle()
                .fill(Color(uiColor: .secondarySystemBackground))
                .frame(height: 45)
                .overlay(alignment: .trailing) {
                    Button("Done") {}.padding()
                }
        }
    }
}

#Preview {
    TestView()
}
