import SwiftUI
import PhotosUI // Still needed for UIImage and other types

struct HomeScreen: View {
    @State private var totalHours: Double = 0
    @State private var entries: [VolunteerEntry] = []

    @State private var isShowingAddEntryForm: Bool = false // Controls the sheet presentation

    var body: some View {
        NavigationView {
            ScrollView {
                Text("**Volunteer Hours Tracker**")
                    .font(.system(size: 32, weight: .semibold))
                    .padding(.top)
                VStack(spacing: 16) {
                    // Circle with total hours display
                    ZStack {
                        Circle()
                            .fill(Color.purple.opacity(0.2))
                            .frame(width: 150, height: 150)

                        VStack {
                            Text("\(calculateTotalHours(), specifier: "%.1f")")
                                .font(.system(size: 36, weight: .bold))
                            Text("Total Hours")
                                .font(.subheadline)
                        }
                    }
                    .padding(.top)
                    .padding(.bottom)


                    // NEW: Combined HStack for "Add New Entry" and "Reset All Entries" buttons
                    HStack(spacing: 15) { // Added spacing between the buttons
                        Spacer() // Pushes buttons towards the center/right

                        // Add New Entry Button
                        Button("Add New Entry") {
                            isShowingAddEntryForm = true
                        }
                        .padding(.vertical, 12)
                        .padding(.horizontal, 20) // Slightly less horizontal padding for better fit
                        .background(Color.green.opacity(0.7))
                        .foregroundColor(.white)
                        .font(.headline)
                        .cornerRadius(15)

                        // Reset All Entries Button
                        Button("Reset All Entries") {
                            resetAllEntries()
                        }
                        .padding(.vertical, 12)
                        .padding(.horizontal, 25) // Consistent padding
                        .background(Color.red.opacity(0.7))
                        .foregroundColor(.white)
                        .font(.headline) // Make font consistent
                        .cornerRadius(15)

                        Spacer() // Pushes buttons towards the center/left
                    }
                    .padding(.bottom, 20) // Space below the button row

                    // List of entries
                    List {
                        ForEach(entries) { entry in
                            // NavigationLink wraps the row content to make it tappable
                            NavigationLink(destination: EntryDetailView(entry: entry)) {
                                HStack {
                                    Text(entry.projectName)
                                    Spacer()
                                    Text("\(entry.hours, specifier: "%.1f") hours")
                                    if let photoData = entry.photoData, let uiImage = UIImage(data: photoData) {
                                        Image(uiImage: uiImage)
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 50, height: 50)
                                    }
                                }
                                .padding() // Padding inside the background
                                .background(Color.purple.opacity(0.1)) // Light blue background for each entry
                                .cornerRadius(8) // Rounded corners for the background
                            }
                            .listRowSeparator(.hidden) // Hides default list separators
                            .listRowBackground(Color.clear) // Ensures custom background shows
                            .listRowInsets(EdgeInsets(top: 5, leading: 20, bottom: 5, trailing: 5)) // Spacing between rows
                        }
                        .onDelete(perform: deleteEntry) // Swipe-to-delete functionality
                    }
                    .listStyle(.plain) // Clean list style
                    // Workaround for List in ScrollView: dynamically set height
                    .frame(height: max(CGFloat(entries.count) * 400, 0)) // 70 is an approximate row height

                    Spacer(minLength: 0) // Ensures content is pushed to the top
                }
            }
            
        }
        .onAppear {
            loadEntries() // Load saved entries when the view appears
        }
        // Sheet for presenting the AddEntryFormView
        .sheet(isPresented: $isShowingAddEntryForm) {
            AddEntryFormView { newEntry in
                // This closure executes when "Save Entry" is tapped in the form
                entries.append(newEntry)
                saveEntries()
                totalHours = calculateTotalHours()
            }
        }
    }


    private func deleteEntry(at offsets: IndexSet) {
        entries.remove(atOffsets: offsets)
        saveEntries()
        totalHours = calculateTotalHours()
    }

    private func loadEntries() {
        if let data = UserDefaults.standard.data(forKey: "entries") {
            if let decodedEntries = try? JSONDecoder().decode([VolunteerEntry].self, from: data) {
                entries = decodedEntries
                totalHours = calculateTotalHours()
            }
        }
    }

    private func saveEntries() {
        if let encodedData = try? JSONEncoder().encode(entries) {
            UserDefaults.standard.set(encodedData, forKey: "entries")
        }
    }

    private func calculateTotalHours() -> Double {
        return entries.reduce(0) { $0 + $1.hours }
    }

    private func resetAllEntries() {
        entries.removeAll()
        totalHours = 0.0
        saveEntries()
    }
}

struct HomeScreen_Previews: PreviewProvider {
    static var previews: some View {
        HomeScreen()
    }
}
