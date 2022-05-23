//
//  EnlargeImageView.swift
//

import SwiftUI

struct EnlargeImageView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @State var image: String
    @State private var currentscale: CGFloat = 1
    @State private var lastScale: CGFloat = 1.0
    
    var body: some View {
        VStack {
            HStack {
                Button("< Back") {
                    presentationMode.wrappedValue.dismiss()
                }.modifier(plainButtom())
                Spacer()
                
            } // HSTACK
            .padding()
            Image(uiImage: UIImage().load(fileName: image) ?? UIImage())
                .resizable()
                .scaledToFill()
              //.frame(width: UIScreen.main.bounds.width * 0.85, alignment: .center)
                .frame(width: UIScreen.main.bounds.width * 0.75,height: UIScreen.main.bounds.height * 0.75, alignment: .center)
                .padding()
                .scaleEffect(currentscale)
                .clipped()
                .gesture(MagnificationGesture()
                            .onChanged({ newScale in
                    currentscale = newScale
                }).onEnded({ endScale in
                })
                )
            Spacer()
            Button("< Back") {
                presentationMode.wrappedValue.dismiss()
            }.modifier(plainButtom())
/*
            Button {
                presentation.wrappedValue.dismiss()
            } label: {
                HStack {
                    Image(systemName: "chevron.backward")
                        .resizable()
                        .foregroundColor(Color.blue)
                        .frame(width: 12, height: 15, alignment: .center)
                        .padding(10)
                    Text("Back")
                        .foregroundColor(Color.blue)
                        .offset(x: -10)
                }
            }*/
        }
    }
}

struct EnlargeImageView_Previews: PreviewProvider {
    static var previews: some View {
        EnlargeImageView(image: "")
    }
}
