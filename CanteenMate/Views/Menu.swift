import SwiftUI
import SwiftData

enum ActiveSheet {
    case first, second
}

struct Menu: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var menus: [MenuModel]
    @State private var isAddMenuPresented = false
    @State private var selectedItem: MenuModel? = nil

    var body: some View {
        NavigationView {
            VStack {
                List(menus) { item in
                    HStack {
                        Text(item.name)
                        Spacer()
                        Text("Rp\(item.price)")
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        selectedItem = item
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .principal){
                    Text("Menu")
                        .font(.title)
                        .fontWeight(.bold)
                }
                ToolbarItem(placement: .topBarTrailing){
                    Button(action: {
                        isAddMenuPresented = true
                    }) {
                        Image(systemName: "plus")
                            .font(.title2)
                    }
                }
            }
            .sheet(isPresented: $isAddMenuPresented) {
                AddMenuModal(isPresented: $isAddMenuPresented)
                    .presentationDetents([.medium])
            }
            .sheet(item: $selectedItem) { item in
                EditMenuModal(item: Binding(get: { item }, set: { selectedItem = $0 }), isPresented: Binding(get: {
                    selectedItem != nil
                }, set: { newValue in
                    if !newValue {
                        selectedItem = nil
                    }
                }))
                .presentationDetents([.medium])
            }
            .overlay {
                if menus.isEmpty {
                    ContentUnavailableView(label: {
                        Label("No Menu", systemImage: "list.bullet.rectangle.portrait")
                    }, description: {
                        Text("Start adding menus to see your list.")
                    })
                    .offset(y: -60)
                }
            }
            .background(Color(.systemGray6))
        }
    }
}

#Preview {
    Menu().modelContainer(for: MenuModel.self, inMemory: true)
}
