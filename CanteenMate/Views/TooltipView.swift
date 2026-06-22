//
//  OnboardingState.swift
//  CanteenMate
//
//  Created by Chairal Octavyanz on 19/05/25.
//

import SwiftUI

enum TooltipPosition {
    case top, bottomLeft, bottomRight
}

struct TooltipView: View {
    let title: String
        let description: String
        let step: Int
        let totalSteps: Int
        let position: TooltipPosition // ✅ Ganti dari Alignment ke TooltipPosition
        let buttonLabel: String
        let onNext: () -> Void
    
    let degrees: Double
    let x1: CGFloat
    let y1: CGFloat
    let x2: CGFloat
    let y2: CGFloat

    var body: some View {
        ZStack {
            // Layer hitam transparan di belakang
            Color.black.opacity(0.5)
                .ignoresSafeArea()

            VStack {
                if position == .bottomRight || position == .bottomLeft {
                    Spacer()
                }

                HStack {
                    if position == .bottomRight {
                        Spacer()
                    }

                    VStack(alignment: .leading, spacing: 8) {
                        Text(title)
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.black)

                        Text(description)
                            .font(.system(size: 14))
                            .foregroundColor(.black)

                        Divider()

                        HStack {
                            Text("\(step)/\(totalSteps)")
                                .font(.caption)
                                .foregroundColor(.gray)

                            Spacer()

                            Button(action: onNext) {
                                Text(buttonLabel)
                                    .font(.system(size: 14, weight: .bold))
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 6)
                                    .background(Color.black)
                                    .foregroundColor(.white)
                                    .cornerRadius(8)
                            }
                        }
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(20)
                    .overlay(
                        TrianglePointer()
                            .fill(Color.white)
                            .frame(width: 20, height: 12)
                            .rotationEffect(.degrees(degrees))
                            .offset(x: x1, y: y1),
                        alignment: .bottom
                    )
                    .padding(.bottom, 40)
                    .offset(x: x2, y: y2)

                    if position == .bottomLeft {
                        Spacer()
                    }
                }

                if position == .top {
                    Spacer()
                }
            }
            .padding()
        }
        .transition(.opacity)
    }
}

struct TrianglePointer: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.maxY)) // bottom
        path.addLine(to: CGPoint(x: rect.minX, y: rect.minY)) // left
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY)) // right
        path.closeSubpath()
        return path
    }
}

