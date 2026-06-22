//
//  FloatingActionButton.swift
//  CanteenMate
//
//  Created by Chairal Octavyanz on 17/05/25.
//

import Foundation

import SwiftUI

struct MenuFAB: View {
    var action: () -> Void

    var body: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                Button(action: action) {
                    Image("icon_add_menu")
                        .foregroundColor(.white)
                        .font(.system(size: 24, weight: .bold))
                        .padding(.leading, 4)
                        .frame(width: 60, height: 60)
                        .background(Color.black)
                        .clipShape(Circle())
                        .shadow(color: .black.opacity(0.4), radius: 8, x: 0, y: 6)
                }
                .padding(.trailing, 20)
                .padding(.bottom, 120)
            }
        }
    }
}

#Preview {
    MenuFAB(action: {})
}
