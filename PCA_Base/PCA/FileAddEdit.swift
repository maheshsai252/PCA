//
//  FileAddEdit.swift
//

import SwiftUI
import PhotosUI

struct FileAddEdit: View {
    @Environment(\.managedObjectContext) var context
    @Environment(\.presentationMode) var presentationMode
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \CateEnt.cateOrdinal, ascending: true)], animation: .default) var cateName: FetchedResults<CateEnt>
    @StateObject var fileData = FileViewModel()
    @EnvironmentObject var getFile : File

    @State var pickerType : UIImagePickerController.SourceType = .photoLibrary    // for camera
    @State private var isCameraPresented: Bool = false
    var config_camera: PHPickerConfiguration {
        var config = PHPickerConfiguration(photoLibrary: PHPhotoLibrary.shared())
        config.filter = .images //  videos, livePhotos...
        config.selectionLimit = 0
        return config
    }    // for camera

    @State private var isPresented: Bool = false
    @State var isDocumentPickerPresented = false
    var config: PHPickerConfiguration  {    //  photoPicker
        var config = PHPickerConfiguration(photoLibrary: PHPhotoLibrary.shared())
        config.filter = .images
        config.selectionLimit = 0
        return config
    }
    
    var body: some View {
        NavigationView {
            VStack {
                Form {
                    Section {
                        HStack {
                            Text("Name").HeaderGray()
                            TextField("required", text: $fileData.fileName)
                                .multilineTextAlignment(.leading)
                            DatePicker("", selection: $fileData.fileDate, displayedComponents: .date)
                                .colorInvert()
                                .colorMultiply(Color.blue)
                        } //.listRowSeparator(.hidden)
                        HStack(alignment: .top) {
                            Text("Notes").HeaderGray()
                            TextEditor(text: $fileData.fileNotes)
                                .modifier(textEditorBox())
                        }.listRowSeparator(.hidden) //Notes
                        HStack {
                            Text("Folder").HeaderGray()
                            catePicker(cateName: Array(cateName), selectedCate: $fileData.selectedCate)
                                .colorInvert()
                                .colorMultiply(Color.blue)
                            Text("")
                            Text("Tag").HeaderGray()
                            TextField("a keyword", text: $fileData.fileTag)
                                .multilineTextAlignment(.center)
                        } //Folder-Tag
                    }
                    VStack(alignment: .leading) {
                        HStack (alignment: .center) {
                            Text("Images").HeaderGray()
                            Image(systemName: "photo.on.rectangle")
                                .font(.system(size: 24.0))
                                .foregroundColor(.blue)
                                .padding(.top, 1)
                                .onTapGesture {
                                    self.pickerType = .photoLibrary
                                    isPresented.toggle()
                                }
                                .sheet(isPresented: $isPresented) {
                                    ImagePicker(configuration: self.config, pickerResult: $fileData.pickerResult, isPresented: $isPresented)
                                }
                            Image(systemName: "camera.shutter.button")
                                .font(.system(size: 24.0))
                                .foregroundColor(.blue)
                                .padding(.top, 1)
                                .onTapGesture {
                                    self.pickerType = .camera
                                    isCameraPresented.toggle()
                                }.padding(4)
                                .sheet(isPresented: $isCameraPresented) {
                                     ImagePickerView(sourceType: .camera) { newImage in
                                         let image = newImage
                                         let imagePath = image.save()
                                         DispatchQueue.main.async {
                                             self.fileData.pickerResult.append(imagePath ?? "")
                                         }
                                     }
                                }
                        }.listRowSeparator(.hidden)
                        ScrollView(.horizontal) {
                            HStack {
                                ForEach($fileData.pickerResult, id: \.self) { image in
                                    Attachments(image: image.wrappedValue) { removedImage in
                                        if let index = fileData.pickerResult.firstIndex(of: removedImage) {
                                            fileData.temporaryStorage.append(removedImage)
                                            fileData.pickerResult.remove(at: index)
                                            }
                                    }
                                }
                            }
                        } //ScrollView
                    } //Images
                    
                    //Documents from Files
                    VStack(alignment: .leading) {
                        HStack (alignment: .center) {
                            Text("Images").HeaderGray()
                            Image(systemName: "folder")
                                .font(.system(size: 24.0))
                                .foregroundColor(.blue)
                                .padding(.top, 1)
                                .onTapGesture {
                                    isDocumentPickerPresented.toggle()
                                }
                                .sheet(isPresented: $isDocumentPickerPresented) {
                                    // Pick Documents
                                    DocumentPicker(pickerResult: $fileData.documents, added: $isDocumentPickerPresented, context: context)

                                }
                            
                        }.listRowSeparator(.hidden)
                        ScrollView(.horizontal) {
                            VStack {
                                ForEach(fileData.documents) { doc in
                                    HStack {
                                        Image(systemName: "doc")
                                        Text(doc.name ?? "")
                                        Text(doc.date?.formatted() ?? "")
                                        Button {
                                            if let index = fileData.documents.firstIndex(of: doc) {
//                                                fileData.temporaryStorage.append(doc.name ?? "")
                                                fileData.documents.remove(at: index)
                                                // Remove Immediately
                                                DispatchQueue.global(qos: .background).async {
                                                    FileManager.default.deleteFiles(fileNames: [doc.name ?? ""])
                                                }
                                                
                                                }
                                        } label: {
                                            Image(systemName: "xmark.circle.fill")
                                                .foregroundColor(.red)
                                        }
                                    }
                                }
                                    
                            }
                        }
                    } //Documents from Files

                } //Form
                .font(.system(size: 18))

                HStack {
                    Spacer()
                    Button(action: {
                        fileData.writeData(context: context)
                        presentationMode.wrappedValue.dismiss()
                    }, label: {
                        title: do {
                            Text(fileData.updateFile == nil ? "Add" : "Save").modifier(mainButtom())
                        }
                    })
                    .padding()
                    .disabled(fileData.fileName == "" ? true : false)  // on no data
                    .opacity(fileData.fileName == "" ? 0.4 : 1)
                    Spacer()
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }, label: {
                        Text("Cancel").modifier(plainButtom())
                    })
                    Spacer()
                }  //HStack

            } //VStack
            .navigationTitle("\(fileData.updateFile == nil ? "add" : "edit") a file")
        } //Navi
        .onAppear {
            //let value  = getFile.file!  // fixes + button on List 20220204
            guard let value  = getFile.file else { return }
            fileData.fileName = value.fileName ?? ""
            fileData.fileDate = value.fileDate!
            fileData.selectedCate = value.fileCate!
            fileData.fileTag = value.fileTag ?? ""
            fileData.fileNotes = value.fileNotes ?? ""
            fileData.pickerResult = value.fileAttach ?? []
            fileData.updateFile = value
            fileData.documents = value.docs?.allObjects as? [DocEnt] ?? []
        }
    }
}

struct FileAddEdit_Previews: PreviewProvider {
    static var previews: some View {
        FileAddEdit().environmentObject(File())  // fixed preview
    }
}
