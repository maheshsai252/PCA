//
//  AttachmentImageView.swift
//

import SwiftUI

struct Attachments: View {
    @State var image: String
    let onDelete: (String) -> Void
    @State var showEnlargeImage = false

    var body: some View {
        ZStack {
            Image(uiImage: UIImage().load(fileName: image) ?? UIImage())
            .resizable()
            .frame(width: 58, height: 108, alignment: .center)
            .onTapGesture {
                showEnlargeImage.toggle()
            }
            Button {
                onDelete($image.wrappedValue)
            } label: {
                Image(systemName: "xmark.circle.fill")
                    .foregroundColor(.red)
            }
            .offset(x: 27, y: -42)
        }
        .fullScreenCover(isPresented: $showEnlargeImage) {
            EnlargeImageView(image: image)
        }
    }
}

struct Attachments_Previews: PreviewProvider {
    static var previews: some View {
        Attachments(image: "", onDelete: { _ in })
            .previewLayout(.sizeThatFits)
    }
}
