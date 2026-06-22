import SwiftUI
import SwiftData

struct PreviewContainerView: View {
    var body: some View {
        IncomeModeMenuView(
            isCustomMode: .constant(false),
            isIncomeMode: .constant(false)
        )
        .modelContainer(previewContainer)
    }
}

@MainActor
private let previewContainer: ModelContainer = {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: MenuModel.self, configurations: config)
    let context = container.mainContext

    context.insert(MenuModel(name: "Mie Ayam Dinosaurus", price: 15000, category: "Food"))
    context.insert(MenuModel(name: "Bakso Tahu", price: 20000, category: "Food"))
    context.insert(MenuModel(name: "Es Teh Manis", price: 5000, category: "Drinks"))

    return container
}()
