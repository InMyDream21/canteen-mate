//
//  FloatingActionButton.swift
//  CanteenMate
//
//  Created by Chairal Octavyanz on 17/05/25.
//

import Foundation

import SwiftUI

struct TransactionFAB: View {
    @State private var showMenu = false
    var onExpense: () -> Void
    var onIncome: () -> Void

    var body: some View {
        ZStack {
            if showMenu {
                // Overlay background
                Color(hex: "#D9D9D9")
                    .opacity(0.9)
                    .ignoresSafeArea()
                    .onTapGesture {
                        showMenu = false
                    }

                // Buttons
                VStack(spacing: 20) {
                    Button(action: {
                        onExpense()
                        showMenu = false
                    }) {
                        HStack {
                            Text("Expense")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.black)
                            Image(systemName: "arrow.up.right")
                                .foregroundColor(.white)
                                .font(.system(size: 24, weight: .bold))
                                .frame(width: 60, height: 60)
                                .background(Color.black)
                                .clipShape(Circle())
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    
                    Button(action: {
                        onIncome()
                        showMenu = false
                    }) {
                        HStack {
                            Text("Income")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.black)
                            Image(systemName: "arrow.down.left")
                                .foregroundColor(.white)
                                .font(.system(size: 24, weight: .bold))
                                .frame(width: 60, height: 60)
                                .background(Color.black)
                                .clipShape(Circle())
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .trailing)

                    Button(action: {
                        showMenu = false
                    }) {
                        Image(systemName: "xmark")
                            .foregroundColor(.black)
                            .font(.system(size: 24, weight: .bold))
                            .frame(width: 60, height: 60)
                            .background(Color.white)
                            .clipShape(Circle())
                    }
                    .frame(maxWidth: .infinity, alignment: .trailing)
                }
                .padding(.bottom, 120)
                .padding(.trailing, 20)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
//                .transition(.scale)
            }

            // Floating button utama (+)
            if !showMenu {
                Button(action: {
                    withAnimation {
                        showMenu = true
                    }
                }) {
                    Image(systemName: "plus")
                        .foregroundColor(.white)
                        .font(.system(size: 24, weight: .bold))
                        .frame(width: 60, height: 60)
                        .background(Color.black)
                        .clipShape(Circle())
                        .shadow(color: .black.opacity(0.3), radius: 8, x: 0, y: 4)
                }
                .padding(.bottom, 120)
                .padding(.trailing, 20)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
            }
        }
    }
}



#Preview {
    TransactionFAB(
        onExpense: {},
        onIncome: {}
    )
}

