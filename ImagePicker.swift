//
//  ImagePicker.swift
//  Tracketeer
//
//  Created by Student on 7/9/25.
//

import SwiftUI
import PhotosUI

struct ImagePicker: UIViewControllerRepresentable {
    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        var parent: ImagePicker

        init(parent: ImagePicker) {
            self.parent = parent
        }

        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            if let result = results.first {
                result.itemProvider.loadDataRepresentation(forTypeIdentifier: UTType.image.identifier) { data, error in
                    guard let data = data, error == nil else {
                        print("Error loading image data: \(String(describing: error))")
                        return
                    }
                    DispatchQueue.main.async {
                        self.parent.selectedImageData = data
                        self.parent.isImagePickerPresented = false
                    }
                }
            } else {
                self.parent.isImagePickerPresented = false
            }
        }

        func pickerDidCancel(_ picker: PHPickerViewController) {
            self.parent.isImagePickerPresented = false
        }
    }

    @Binding var isImagePickerPresented: Bool
    @Binding var selectedImageData: Data?

    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }

    func makeUIViewController(context: Context) -> PHPickerViewController {
        var config = PHPickerConfiguration()
        config.selectionLimit = 1
        config.filter = .images

        let picker = PHPickerViewController(configuration: config)
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {}
}
