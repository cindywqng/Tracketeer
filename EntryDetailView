import SwiftUI

struct EntryDetailView: View {
    let entry: VolunteerEntry

    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Project: \(entry.projectName)")
                .font(.title2)
                .fontWeight(.bold)

            Text("Hours: \(entry.hours, specifier: "%.1f")")
                .font(.headline)
                .foregroundColor(.gray)
            
            Text("Description of Work:") // <--- ADD THIS LABEL
                            .font(.headline)
                            .padding(.top, 5)

                        Text(entry.description.isEmpty ? "No description provided." : entry.description) // <--- ADD THIS TEXT
                            .font(.body)
                            .foregroundColor(.primary)
                            .multilineTextAlignment(.leading) // Ensure text aligns left
                            .lineLimit(nil) // Allow unlimited lines
                            .fixedSize(horizontal: false, vertical: true) // Allow vertical expansion



            // Display the date of the entry
            Text("Date: \(entry.date, formatter: Self.entryDateFormatter)")
                .font(.subheadline)
                .foregroundColor(.secondary)

            if let photoData = entry.photoData, let uiImage = UIImage(data: photoData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: .infinity, maxHeight: 200)
                    .cornerRadius(10)
                    .shadow(radius: 5)
            } else {
                Text("No photo available for this entry.")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }

            Spacer()
        }
        .padding()
        .navigationTitle(entry.projectName)
        .navigationBarTitleDisplayMode(.inline)
    }

    // Date Formatter for consistent display
    static let entryDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long // Example: "July 9, 2025"
        formatter.timeStyle = .none // No time needed
        return formatter
    }()
}

struct EntryDetailView_Previews: PreviewProvider {
    static var previews: some View {
        EntryDetailView(entry: VolunteerEntry(projectName: "Sample Project", hours: 15.5, photoData: nil, date: Date(),description: "This is a sample description of the work performed during this volunteer activity. It can be multiple lines long."))
    }
}
