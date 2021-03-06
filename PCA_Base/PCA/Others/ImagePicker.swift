//
//  ImagePicker.swift
//

import PhotosUI
import SwiftUI

struct ImagePicker: UIViewControllerRepresentable {
    let configuration: PHPickerConfiguration
    @Binding var pickerResult: [String]
    @Binding var isPresented: Bool
    func makeUIViewController(context: Context) -> PHPickerViewController {
        let controller = PHPickerViewController(configuration: configuration)
        controller.delegate = context.coordinator
        return controller
    }
    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) { }
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    /// PHPickerViewControllerDelegate => Coordinator
    class Coordinator: PHPickerViewControllerDelegate {
        private let parent: ImagePicker
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func picker(_ picker: PHPickerViewController, didFinishPicking allFiles: [PHPickerResult]) {
            for image in allFiles {
                if image.itemProvider.canLoadObject(ofClass: UIImage.self)  {
                    image.itemProvider.loadObject(ofClass: UIImage.self) { (newImage, error) in
                        if let error = error {
                            print(error.localizedDescription)
                        } else {
                            let image = newImage as! UIImage
                            let imagePath = image.save()
                            DispatchQueue.main.async {
                                self.parent.pickerResult.append(imagePath ?? "")
                            }
                        }
                    }
                } else {
                    print("Loaded Assest is not a Image")
                }
            }
            parent.isPresented = false
        }
        
    }
}
