//
//  DocOpener.swift
//  PCA
//
//  Created by Mahesh sai on 28/05/22.
//

import Foundation
import SwiftUI

struct DocumentOpener: View {
    @Binding var selectedURL: URL?
    @Binding var open: Bool
    @State var errorInAccess = false
    var body: some View {
        NavigationView {
                VStack(alignment: .center, spacing: 0) {
                    if let url = selectedURL {
                            PreviewController(url: url, error: $errorInAccess)
                    } else {
                        ProgressView()
                    }
                }
            
            .navigationTitle(                    Text(selectedURL?.lastPathComponent ?? "")
            )
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        self.selectedURL=nil
                        self.open = false

                    }
                }
                           
            }
        }
    }
}

import PDFKit
import QuickLook
import SwiftUI

struct PreviewController: UIViewControllerRepresentable {
    let url: URL
    var error: Binding<Bool>
    func makeUIViewController(context: Context) -> QLPreviewController {
        let controller = QLPreviewController()
        controller.dataSource = context.coordinator
        controller.isEditing = false
        return controller
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }
    
    func updateUIViewController(
        _ uiViewController: QLPreviewController, context: Context) {}
    
    class Coordinator: QLPreviewControllerDataSource {
        var parent: PreviewController
        
        init(parent: PreviewController) {
            self.parent = parent
        }
        
        func numberOfPreviewItems(
            in controller: QLPreviewController
        ) -> Int {
            return 1
        }
        
        func previewController(
            _ controller: QLPreviewController, previewItemAt index: Int
        ) -> QLPreviewItem {
            
            guard self.parent.url.startAccessingSecurityScopedResource()
            else {
                print("problem starting");
//                print(parent.url)
                return NSURL(fileURLWithPath: parent.url.path)
            }
            defer {
                self.parent.url.stopAccessingSecurityScopedResource()
            }
            
            return NSURL(fileURLWithPath: self.parent.url.path)
        }
        
    }
}
