import SwiftUI

struct ContentView: View {
    @EnvironmentObject var store: Store
    @EnvironmentObject var purchases: PurchaseManager

    @State private var showAddSheet = false
    @State private var showPaywall = false
    @State private var showSettings = false
    @State private var newTitle = ""
    @State private var newDetail = ""
    @State private var newValue = ""

    var body: some View {
        NavigationStack {
            List {
                Section {
                    HStack {
                        Text("Total")
                            .font(Theme.headlineFont)
                        Spacer()
                        Text(String(format: "%.2f", store.totalValue))
                            .font(Theme.headlineFont)
                            .foregroundStyle(Theme.accent)
                    }
                }
                Section("Entries") {
                    ForEach(store.items) { item in
                        VStack(alignment: .leading, spacing: 4) {
                            Text(item.title).font(Theme.bodyFont).bold()
                            Text(item.detail).font(Theme.captionFont).foregroundStyle(.secondary)
                            Text(item.date, style: .date).font(Theme.captionFont).foregroundStyle(.secondary)
                        }
                        .accessibilityIdentifier("itemRow_\(item.title)")
                    }
                    .onDelete { offsets in
                        store.delete(at: offsets)
                    }
                }
            }
            .navigationTitle("Volunteerhrs")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        showSettings = true
                    } label: {
                        Image(systemName: "gearshape")
                    }
                    .accessibilityIdentifier("settingsButton")
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        if store.canAddMore || purchases.isPro {
                            showAddSheet = true
                        } else {
                            showPaywall = true
                        }
                    } label: {
                        Image(systemName: "plus")
                    }
                    .accessibilityIdentifier("addButton")
                }
            }
            .sheet(isPresented: $showAddSheet) {
                addSheet
            }
            .sheet(isPresented: $showPaywall) {
                PaywallView()
            }
            .sheet(isPresented: $showSettings) {
                SettingsView()
            }
        }
    }

    private var addSheet: some View {
        NavigationStack {
            Form {
                TextField("Title", text: $newTitle)
                    .accessibilityIdentifier("titleField")
                TextField("Detail", text: $newDetail)
                    .accessibilityIdentifier("detailField")
                TextField("Value", text: $newValue)
                    .keyboardType(.decimalPad)
                    .accessibilityIdentifier("valueField")
            }
            .contentShape(Rectangle())
            .onTapGesture {
                hideKeyboard()
            }
            .navigationTitle("New Entry")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        showAddSheet = false
                    }
                    .accessibilityIdentifier("cancelAddButton")
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        let v = Double(newValue) ?? 0
                        store.add(title: newTitle.isEmpty ? "Entry" : newTitle, detail: newDetail, value: v)
                        newTitle = ""; newDetail = ""; newValue = ""
                        showAddSheet = false
                    }
                    .accessibilityIdentifier("saveAddButton")
                }
            }
        }
    }
}

extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

#Preview {
    ContentView()
        .environmentObject(Store())
        .environmentObject(PurchaseManager())
}
