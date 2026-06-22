//
//  MenuCashierCard.swift
//  CanteenMate
//
//  Created by Chairal Octavyanz on 02/04/25.
//

import Foundation

extension Int {
    func formattedWithSeparator() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = "."
        formatter.locale = Locale(identifier: "id_ID")
        return "Rp" + (formatter.string(from: NSNumber(value: self)) ?? "0")
    }
}

extension Color {
    init(hex: String) {
        let scanner = Scanner(string: hex)
        _ = scanner.scanString("#")

        var rgb: UInt64 = 0
        scanner.scanHexInt64(&rgb)

        let r = Double((rgb >> 16) & 0xFF) / 255
        let g = Double((rgb >> 8) & 0xFF) / 255
        let b = Double(rgb & 0xFF) / 255

        self.init(red: r, green: g, blue: b)
    }
}

import SwiftUI

struct MenuCashierCard: View{
    @Environment(\.colorScheme) var colorScheme
    var title: String
    var price: Int
    
    @Binding var numberOfTotal: Int
    
    
    var body: some View{
        VStack {
            HStack{
//                Spacer()
                VStack(alignment: .leading){
                    Text("\(title)")
                        .font(.system(size: 16, weight: .medium)) // Ukuran dan berat font
                    
                    Text("Rp\(price)")
                        .font(.system(size: 12, weight: .regular)) // Ukuran dan berat font
                        .foregroundStyle(Color.gray)
                }
                .padding(.leading, 20)

                
                Spacer()
                
                HStack{
                    Button(action: minusPressed){
                        Image(systemName: "minus")
                            .foregroundStyle(colorScheme == .dark ? .white : .black)
                    }.padding(.horizontal, 6)
                    Text("\(numberOfTotal)")
                        .padding(.horizontal, 4)
                    Button(action: plusPressed){
                        Image(systemName: "plus")
                            .foregroundStyle(colorScheme == .dark ? .white : .black)
                    }.padding(.horizontal, 6)
                }
                .padding(8)
                .background(Color(hex: "#787880").opacity(0.4))
                .cornerRadius(10)
                .padding(.trailing, 20)
                
            }
            .frame(width: 343, height: 70)
            .background(Color(hex: "#F0F0F0"))
            .cornerRadius(20)
            .padding(.horizontal, 25)
            .padding(.bottom, 8)
            
//            Divider()
//                .background(Color(.systemGray5))
//                .padding(.horizontal)
        }
    }
    
    func minusPressed(){
        if numberOfTotal > 0 {
            numberOfTotal -= 1
        }
    }
    
    func plusPressed(){
        numberOfTotal += 1
    }
}

#Preview {
    MenuCashierCard(title: "Mie Ayam Spesial", price: 15000, numberOfTotal: .constant(0))
}

