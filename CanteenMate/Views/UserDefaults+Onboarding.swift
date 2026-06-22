//
//  OnboardingState.swift
//  CanteenMate
//
//  Created by Chairal Octavyanz on 19/05/25.
//

import Foundation
import SwiftUI

extension UserDefaults {
    var hasSeenOnboarding: Bool {
        get { bool(forKey: "hasSeenOnboarding") }
        set { set(newValue, forKey: "hasSeenOnboarding") }
    }
}
