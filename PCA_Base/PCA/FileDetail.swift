//
//  FileDetail.swift
//

import SwiftUI
import CoreData

class File : ObservableObject{
    @Published var file : FileEnt!
}

struct FileDetail: View {
    @Environment(\.managedObjectContext) var context
    @Environment(\.presentationMode) var presentationMode
    @StateObject var segueFile  = File()
    @State var showingFileEdit = false

    let aFile: FileEnt
    var fileDateFormat: String {
        if let launchDate = aFile.fileDate {
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            return formatter.string(from: launchDate)
        }
        return ""
    }
    
    var body: some View {
        VStack {
            Form {
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text("File name    ").HeaderGray()
                        Text(self.aFile.fileName ?? "").fontWeight(.semibold)
                    }
                    HStack {
                        Text("Filing date   ").HeaderGray()
                        Text(self.fileDateFormat).fontWeight(.semibold)
                    }
                    HStack {
                        Text("Folder - Tag").HeaderGray()
                        Text(aFile.fileCate?.cateName ?? "").fontWeight(.semibold)
                        Text("-")
                        Text(self.aFile.fileTag ?? "").fontWeight(.semibold)
                    }
                    
                    Text("Images")
                        .HeaderGray()
                        .padding(.top, 10)
                    ScrollView(.horizontal) {
                        HStack {
                            ForEach(self.aFile.fileAttach!, id: \.self) { image in DetailImageView(image: image)
                            }
                        }
                    }
                    
                    //Documents from Files
                    Text("Documents")
                        .HeaderGray()
                        .padding(.top, 10)
                    ScrollView(.horizontal) {
                        VStack {
                            HStack {
                                /*
                                ForEach
                                    // code to list documents with name & date
                                */
                            }
                        }
                    } //Documents from Files

                    Text("Notes")
                        .HeaderGray()
                        .padding(.top, 10)
                    Text(self.aFile.fileNotes ?? "")
                        .padding(12)
                        .background(Color.gray.opacity(0.1))
                }.padding(8) //VStack
            }.font(.system(size: 18)) //Form
            
            HStack {
                Spacer()
                Button(action: {
                    showingFileEdit.toggle()
                }, label: {    // to Edit page
                    title: do { Text("Edit").modifier(mainButtom())
                    }
                }).padding()
                Spacer()
                Button("< Back") {
                    presentationMode.wrappedValue.dismiss()
                }.modifier(plainButtom())
                Spacer()
            }
            .sheet(isPresented: $showingFileEdit) {
                FileAddEdit()
            }
        } //VStack
        .navigationTitle("a file details")
        //.navigationTitle("'\(self.aFile.fileName ?? "")' details")
        .onAppear(perform: {
            segueFile.file = aFile
        })
        .environmentObject(segueFile)
    }
}
        
struct FileDetail_Previews: PreviewProvider {
    static let context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
    static var previews: some View {
        let aFile = FileEnt(context: context)
        return NavigationView {
            FileDetail(aFile: aFile)
        }
    }
}
