//
//  DetailImageView.swift
//

import SwiftUI

struct DetailImageView: View {
    @State var image: String
    @State var showEnlargeImage = false
    @Environment(\.presentationMode) private var presentationMode

    var body: some View {
        ZStack {
            Image(uiImage: UIImage().load(fileName: image) ?? UIImage())
            .resizable()
            .frame(width: 58, height: 108, alignment: .center)
            .onTapGesture {
                showEnlargeImage.toggle()
            }
        }
        .fullScreenCover(isPresented: $showEnlargeImage) {
            EnlargeImageView(image: image)
        }
    }
}

struct DetailImageView_Previews: PreviewProvider {
    static var previews: some View {
        DetailImageView(image: "")
            .previewLayout(.sizeThatFits)
    }
}
