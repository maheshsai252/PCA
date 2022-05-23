//
//  ExportData.swift
//

import SwiftUI

struct ExportData: View {
    @Environment(\.managedObjectContext) var context
    @Environment(\.presentationMode) var presentationMode
    @State private var isShareSheetShowing = false

    @FetchRequest(entity: FileEnt.entity(), sortDescriptors: [NSSortDescriptor(key: "fileDate", ascending: false)],animation: .spring())
    var allFiles: FetchedResults<FileEnt>
    
    var body: some View {
        VStack {
            Text("export data")
                .fontWeight(.bold)
                .font(.title)
            List {
                Spacer()
                HStack {
                    Button(action: exportFileData) {
                        HStack(alignment: .firstTextBaseline) {
                            Text("Files").modifier(mainButtom())
                        }
                    }.buttonStyle(BorderlessButtonStyle())
                }.listRowSeparator(.hidden)
                Spacer()
            }
            Button(action: {
                presentationMode.wrappedValue.dismiss()
            }, label: {
                Text("Done").modifier(plainButtom())
            })
        }
    }

    
    func exportFileData() {
        let ExportFileCSV = "FileData_\(Date().string(format: "yyyyMMMdd")).csv"
        let path = NSURL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(ExportFileCSV)
        var FileCSVtext = "File Name, Date, Folder, Tag, Notes\n"
        for FileData in allFiles {
            FileCSVtext += "\(FileData.fileName ?? ""), \(FileData.fileDate ?? Date()), \(FileData.fileCate?.cateName ?? ""), \(FileData.fileTag ?? ""), \(FileData.fileNotes ?? "")\n"
        }
        do {
            try FileCSVtext.write(to: path!, atomically: true, encoding: String.Encoding.utf8)
        } catch {
            print("Failed to create file")
            print("\(error)")
        }
        print(path ?? "not found")
        var FileToShare = [Any]()
        FileToShare.append(path!)
        let av = UIActivityViewController(activityItems: FileToShare, applicationActivities: nil)
        UIApplication.shared.windows.first?.rootViewController?.present(av, animated: true, completion: nil)
        isShareSheetShowing.toggle()
    }
}

struct ExportData_Previews: PreviewProvider {
    static var previews: some View {
        ExportData()
    }
}
