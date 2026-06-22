//
//  FloatingActionButton.swift
//  CanteenMate
//
//  Created by Chairal Octavyanz on 17/05/25.
//

import Foundation

import SwiftUI

struct TransactionRowView: View {
    let label: String
    let amount: Int
    let icon: String
    let color: Color
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(.white)
                .frame(width: 24, height: 24)
                .padding()
                .background(color)
                .clipShape(RoundedRectangle(cornerRadius: 8))
            
            Text(label)
                .font(.system(size: 16, weight: .medium))
            
            Spacer()
            
            Text("\(amount.formattedWithSeparator())")
                .fontWeight(.semibold)
        }
    }
}

