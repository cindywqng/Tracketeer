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
            
            Text("Description of Work:")  
                            .font(.headline)
                            .padding(.top, 5)

                        Text(entry.description.isEmpty ? "No description provided." : entry.description)  
                            .font(.body)
                            .foregroundColor(.primary)
                            .multilineTextAlignment(.leading)  
                            .lineLimit(nil)  
                            .fixedSize(horizontal: false, vertical: true)  



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

     static let entryDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long  
        formatter.timeStyle = .none  
        return formatter
    }()
}

struct EntryDetailView_Previews: PreviewProvider {
    static var previews: some View {
        EntryDetailView(entry: VolunteerEntry(projectName: "Sample Project", hours: 15.5, photoData: nil, date: Date(),description: "Blah blah description"))
    }
}
