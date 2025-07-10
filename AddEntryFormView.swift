import SwiftUI
import PhotosUI

struct AddEntryFormView: View {
    @Environment(\.dismiss) var dismiss // For dismissing the sheet

    @State private var newEntryProjectName: String = ""
    @State private var newEntryHours: Double = 0.0
    @State private var newEntryDate: Date = Date() // Defaults to current date
    @State private var newEntryDescription: String = ""
    @State private var isImagePickerPresented: Bool = false
    @State private var selectedImageData: Data? = nil

    // Closure to pass the new entry back to HomeScreen
    var onAddEntry: (VolunteerEntry) -> Void

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    TextField("Organization Name", text: $newEntryProjectName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal)
                        .padding(.top)
                    
                    
                    
                    
                    
                    TextField("Hours", text: Binding(
                        get: { newEntryHours == 0.0 ? "" : String(format: "%.2f", newEntryHours) },
                        set: {
                            if let value = Double($0) {
                                newEntryHours = value
                            } else if $0.isEmpty {
                                newEntryHours = 0.0
                            }
                        }
                    ))
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.decimalPad)
                    .padding(.horizontal)
                    
                    TextField("Description of Work", text: $newEntryDescription)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal)
                    
                    DatePicker("Date of Service", selection: $newEntryDate, displayedComponents: .date)
                        .datePickerStyle(.graphical)
                        .padding(.horizontal)
                    
                    Button("Upload Proof of Service") {
                        isImagePickerPresented = true
                    }
                    .padding(.vertical, 10)
                    .padding(.horizontal, 20)
                    .background(Color.purple)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    
                    if let imageData = selectedImageData, let uiImage = UIImage(data: imageData) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 100)
                            .padding()
                    }
                    
                    Spacer()
                    
                    Button("Save Entry") {
                        let entry = VolunteerEntry(
                            projectName: newEntryProjectName,
                            hours: newEntryHours,
                            photoData: selectedImageData,
                            date: newEntryDate,
                            description: newEntryDescription
                        )
                        onAddEntry(entry)
                        dismiss()
                    }
                    .padding(.vertical, 12)
                    .padding(.horizontal, 40)
                    .background(Color.green)
                    .foregroundColor(.white)
                    .font(.headline)
                    .cornerRadius(15)
                    .disabled(newEntryProjectName.isEmpty || newEntryHours <= 0)
                }
                .navigationTitle("Add New Entry")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button("Cancel") {
                            dismiss()
                        }
                    }
                }
                .sheet(isPresented: $isImagePickerPresented) {
                    ImagePicker(isImagePickerPresented: $isImagePickerPresented, selectedImageData: $selectedImageData)
                }
            }
        }
    }
}

struct AddEntryFormView_Previews: PreviewProvider {
    static var previews: some View {
        AddEntryFormView(onAddEntry: { _ in })
    }
}
