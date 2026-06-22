import SwiftUI
import SwiftData

enum ActiveSheet {
    case first, second
}

struct MenuView: View {
    @ObservedObject var manager: OnboardingManager
    @Binding var isShowing: Bool

    @Environment(\.modelContext) private var modelContext
    @Query private var menus: [MenuModel]
    @State private var selectedItem: MenuModel? = nil

    var body: some View {
        ZStack {
            NavigationView {
                VStack {
                    menuHeader()
                    menuListView()
                }
                .sheet(item: $selectedItem) { item in
                    EditMenuModal(
                        item: Binding(get: { item }, set: { selectedItem = $0 }),
                        isPresented: Binding(get: {
                            selectedItem != nil
                        }, set: { newValue in
                            if !newValue {
                                selectedItem = nil
                            }
                        })
                    )
                    .presentationDetents([.medium])
                }
                .overlay {
                    if menus.isEmpty {
                        ContentUnavailableView(
                            label: {
                                Label("No Menu", systemImage: "list.bullet.rectangle.portrait")
                            },
                            description: {
                                Text("Start adding menus to see your list.")
                            }
                        )
                        .offset(y: -60)
                    }
                }
                .background(Color.white.ignoresSafeArea())
            }

            if isShowing && manager.currentStep == .guide4 {
                TooltipView(
                    title: "Create a New Menu Item",
                    description: "Add new item to the menu list.",
                    step: 4,
                    totalSteps: 4,
                    position: .bottomRight,
                    buttonLabel: "Finish",
                    onNext: {
                        isShowing = false
                        manager.reset()
                    },
                    degrees: 0,
                    x1: 145,
                    y1: 12,
                    x2: 0,
                    y2: -150
                )
                .zIndex(100)
            }
        }
    }

    // MARK: - Subviews

    @ViewBuilder
    func menuHeader() -> some View {
        HStack {
            Spacer()
            Text("Menu")
                .font(.system(size: 32, weight: .bold))
                .foregroundColor(.black)
            Spacer()
        }
    }

    @ViewBuilder
    func menuListView() -> some View {
        List {
            ForEach(menus) { item in
                menuRow(for: item)
                    .onTapGesture {
                        selectedItem = item
                    }
                    .listRowSeparator(.hidden)
            }
        }
        .listRowBackground(Color.clear)
        .background(Color.white)
        .scrollContentBackground(.hidden)
    }

    @ViewBuilder
    func menuRow(for item: MenuModel) -> some View {
        HStack {
            Image(iconName(for: item.category))
                .resizable()
                .scaledToFit()
                .frame(width: 32, height: 31)
                .foregroundColor(.white)
                .padding(8)
                .background(backgroundColor(for: item.category))
                .clipShape(Circle())
                .frame(width: 50, height: 50, alignment: .center)
                .padding(.leading, 16)
                .padding(.trailing, 6)

            Text(item.name)
                .font(.system(size: 16, weight: .medium))

            Spacer()

            Text("Rp\(item.price)")
                .font(.system(size: 12, weight: .regular))
                .foregroundStyle(Color.gray)
                .padding(.trailing, 16)
        }
        .frame(width: 342, height: 70)
        .background(Color(hex: "#F0F0F0"))
        .cornerRadius(20)
    }

    // MARK: - Helpers

    func iconName(for category: String) -> String {
        switch category.lowercased() {
        case "food": return "icon_food"
        case "drinks": return "icon_drinks"
        case "snack": return "icon_snack"
        default: return "icon_default"
        }
    }

    func backgroundColor(for category: String) -> Color {
        switch category.lowercased() {
        case "food": return Color(hex: "#4592AF")
        case "drinks": return Color(hex: "#EF6C35")
        case "snack": return Color(hex: "#DE9F65")
        default: return Color.gray
        }
    }
}

#Preview {
    @Previewable @State var showing = true
    MenuView(manager: OnboardingManager(), isShowing: $showing)
        .modelContainer(for: MenuModel.self, inMemory: true)
}
