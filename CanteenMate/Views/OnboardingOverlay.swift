//
//  OnboardingState.swift
//  CanteenMate
//
//  Created by Chairal Octavyanz on 19/05/25.
//

import Foundation
import SwiftUI

struct OnboardingOverlay: View {
    @ObservedObject var manager: OnboardingManager
    @Binding var isShowing: Bool
    
    var body: some View {
        switch manager.currentStep {
        case .welcome:
            Color.white
                .overlay(
                    VStack {
                        Image("welcome_illustration")
                        Text("Welcome!").font(.title).bold()
                        Text("Tap anywhere to continue")
                    }
                )
                .onTapGesture {
                    manager.nextStep()
                }
            
        case .guide1:
            TooltipView(
                title: "Create a New Transaction",
                description: "Use this button to record income/expense.",
                step: 1,
                totalSteps: 4,
                position: .bottomRight,
                buttonLabel: "Next",
                onNext: { manager.nextStep() },
                degrees: 0,
                x1: 145,
                y1: 12,
                x2: 0,
                y2: -150
            )
            
        case .guide2:
            TooltipView(
                title: "Time Filter Control",
                description: "Filter income & expenses by date.",
                step: 2,
                totalSteps: 4,
                position: .top,
                buttonLabel: "Next",
                onNext: { manager.nextStep() },
                degrees: 180,
                x1: 0,
                y1: -120,
                x2: 0,
                y2: 120
            )
            
        case .guide3:
            TooltipView(
                title: "Navigate to Menu Page",
                description: "Use this button to switch to the menu tab.",
                step: 3,
                totalSteps: 4,
                position: .bottomLeft,
                buttonLabel: "Next",
                onNext: {
                    manager.nextStep() // Harus ada
                },
                degrees: 0,
                x1: 105,
                y1: 12,
                x2: 0,
                y2: -20
            )
            
        case .guide4:
            TooltipView(
                title: "Create a New Menu Item",
                description: "On the Menu Page, tap this button to add a new item to your menu list.",
                step: 4,
                totalSteps: 4,
                position: .bottomRight,
                buttonLabel: "Finish",
                onNext: { manager.nextStep() },
                degrees: 0,
                x1: 145,
                y1: 12,
                x2: 0,
                y2: -150
            )
            
            
        case .finish:
            Color.white
                .overlay(
                    Text("Start Explore!")
                        .font(.title).bold()
                )
                .onTapGesture {
                    isShowing = false
                    manager.reset()
                }
        }
    }
    
}
