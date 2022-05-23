//
//  Pickers.swift
//

import Foundation
import SwiftUI

struct catePicker: View {
    var cateName: [CateEnt]
    @Binding var selectedCate: CateEnt?
    
    var body: some View {
        Picker(selection: $selectedCate, label: Text("")) {
            ForEach(cateName) { cate in
                Text(cate.cateName ?? "").tag(cate as CateEnt?)
            }
        }
        // Set your initial item here only if the selected item is nil
        .onAppear() {
            if selectedCate == nil{
                selectedCate = cateName.last
            }
        }
    }
}

struct cancelView: View {
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        Button("Cancel") {
            presentationMode.wrappedValue.dismiss()
        }
    }
}

extension Text {
    func HeaderGray() -> Text {
        self
            .foregroundColor(.gray)
            .fontWeight(.semibold)
    }
}

/*
struct BackButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
        HStack {
            Image(systemName: "chevron.backward")
                .resizable()
                .foregroundColor(Color.blue)
                .font(.title3)
                .frame(width: 12, height: 15, alignment: .center)
                .padding(10)
            Text("Back")
                .font(.title3)
                .foregroundColor(Color.blue)
                .offset(x: -10)
        }
    }
}*/

struct mainButtom: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.title3)
            .foregroundColor(.white)
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
            .background(Color.blue.opacity(0.7).cornerRadius(8).shadow(radius: 8))
    }
}

struct plainButtom: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.title3)
            .foregroundColor(.blue)
    }
}
