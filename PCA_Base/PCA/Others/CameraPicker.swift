//
//  ImagePickerView.swift
//

import SwiftUI
import Foundation
import AVFoundation
import MobileCoreServices

public struct ImagePickerView: UIViewControllerRepresentable {

    private let sourceType: UIImagePickerController.SourceType
    private let onImagePicked: (UIImage) -> Void
//    private let onVideoPicked: (URL) -> Void
    @Environment(\.presentationMode) private var presentationMode
    
//    private let kuttyValue : String

    public init(sourceType: UIImagePickerController.SourceType, onImagePicked: @escaping (UIImage) -> Void) {
//        self.kuttyValue = kuttyValue
        self.sourceType = sourceType
        self.onImagePicked = onImagePicked
//        self.onVideoPicked = onVideoPicked
    }

    public func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = self.sourceType
//        if kuttyValue == "Video"{
//            picker.mediaTypes = [kUTTypeMovie as String]
//        }else{
            picker.mediaTypes = [kUTTypeImage as String]
//        }
        
        picker.delegate = context.coordinator
        return picker
    }

    public func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}

    public func makeCoordinator() -> Coordinator {
        Coordinator(
            onDismiss: { self.presentationMode.wrappedValue.dismiss() },
            onImagePicked: self.onImagePicked
//            onVideoPicked: self.onVideoPicked
        )
    }

    final public class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

        private let onDismiss: () -> Void
        private let onImagePicked: (UIImage) -> Void
//        private let onVideoPicked: (URL) -> Void

        init(onDismiss: @escaping () -> Void, onImagePicked: @escaping (UIImage) -> Void) {
            self.onDismiss = onDismiss
            self.onImagePicked = onImagePicked
//            self.onVideoPicked = onVideoPicked
        }

        public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            
            let mediaType = info[UIImagePickerController.InfoKey.mediaType] as AnyObject

            //VIDEO
               if mediaType as! String == kUTTypeMovie as String {
                let videoURL = info[UIImagePickerController.InfoKey.mediaURL] as? URL
                       
                
                let thumbNail = generateThumbnail(path: videoURL!)
                self.onImagePicked(thumbNail!)
//                self.onVideoPicked(videoURL!)
                
               }
               
               //PHOTO
               else{
                if let image = info[.originalImage] as? UIImage {
                    self.onImagePicked(image)
//                    self.onVideoPicked(URL(string: ""))
                }
               }
            self.onDismiss()
        }

        public func imagePickerControllerDidCancel(_: UIImagePickerController) {
            self.onDismiss()
        }

        func generateThumbnail(path: URL) -> UIImage? {
            do {
                let asset = AVURLAsset(url: path, options: nil)
                let imgGenerator = AVAssetImageGenerator(asset: asset)
                imgGenerator.appliesPreferredTrackTransform = true
                let cgImage = try imgGenerator.copyCGImage(at: CMTimeMake(value: 0, timescale: 1), actualTime: nil)
                let thumbnail = UIImage(cgImage: cgImage)
                return thumbnail
            } catch let error {
                print("*** Error generating thumbnail: \(error.localizedDescription)")
                return nil
            }
        }
        
    }

}

