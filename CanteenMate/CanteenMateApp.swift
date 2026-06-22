import SwiftUI
import SwiftData

@main
struct CanteenMateApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
//                .environment(\.font, .custom("Poppins-Regular", size: 16))
        }
        .modelContainer(for: [MenuModel.self, Transaction.self])
    }
}
