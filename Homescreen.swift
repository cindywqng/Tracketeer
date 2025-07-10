import SwiftUI
import PhotosUI 
struct HomeScreen: View {
    @State private var totalHours: Double = 0
    @State private var entries: [VolunteerEntry] = []

    @State private var isShowingAddEntryForm: Bool = false  

    var body: some View {
        NavigationView {
            ScrollView {
                Text("**Volunteer Hours Tracker**")
                    .font(.system(size: 32, weight: .semibold))
                    .padding(.top)
                VStack(spacing: 16) {
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


                     HStack(spacing: 15) {  
                        Spacer()  

                         Button("Add New Entry") {
                            isShowingAddEntryForm = true
                        }
                        .padding(.vertical, 12)
                        .padding(.horizontal, 20)  
                        .background(Color.green.opacity(0.7))
                        .foregroundColor(.white)
                        .font(.headline)
                        .cornerRadius(15)

                         Button("Reset All Entries") {
                            resetAllEntries()
                        }
                        .padding(.vertical, 12)
                        .padding(.horizontal, 25) 
                        .background(Color.red.opacity(0.7))
                        .foregroundColor(.white)
                        .font(.headline)  
                        .cornerRadius(15)

                        Spacer()  
                    }
                    .padding(.bottom, 20) 

                     List {
                        ForEach(entries) { entry in
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
                                .padding()  
                                .background(Color.purple.opacity(0.1))  
                                .cornerRadius(8) 
                            }
                            .listRowSeparator(.hidden)  
                            .listRowBackground(Color.clear)  
                            .listRowInsets(EdgeInsets(top: 5, leading: 20, bottom: 5, trailing: 5))  
                        }
                        .onDelete(perform: deleteEntry)  
                    }
                    .listStyle(.plain)  
                     .frame(height: max(CGFloat(entries.count) * 400, 0))  

                    Spacer(minLength: 0) 
                }
            }
            
        }
        .onAppear {
            loadEntries()  
        }
         .sheet(isPresented: $isShowingAddEntryForm) {
            AddEntryFormView { newEntry in
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
