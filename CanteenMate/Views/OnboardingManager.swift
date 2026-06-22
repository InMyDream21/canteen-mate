//
//  OnboardingState.swift
//  CanteenMate
//
//  Created by Chairal Octavyanz on 19/05/25.
//

import Foundation
import SwiftUI

class OnboardingManager: ObservableObject {
    enum Step: Int {
        case welcome
        case guide1
        case guide2
        case guide3
        case guide4
        case finish
    }

    @Published var currentStep: Step = .welcome

    func nextStep() {
        switch currentStep {
        case .welcome: currentStep = .guide1
        case .guide1: currentStep = .guide2
        case .guide2: currentStep = .guide3
        case .guide3: currentStep = .guide4
        case .guide4: currentStep = .finish
        case .finish: break
        }
    }


    func triggerGuide4() {
        currentStep = .guide4
    }

    func reset() {
        currentStep = .welcome
    }
}
