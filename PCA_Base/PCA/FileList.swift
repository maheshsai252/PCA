//
//  FileList.swift
//

import SwiftUI

struct FileList: View {
    @Environment(\.managedObjectContext) var context
    @FetchRequest(entity: FileEnt.entity(), sortDescriptors: [NSSortDescriptor(key: "fileDate", ascending: false)], animation: .spring())
    var allFiles: FetchedResults<FileEnt>
    @FetchRequest(sortDescriptors: [ NSSortDescriptor(keyPath: \CateEnt.cateOrdinal, ascending: true) ], animation: .default)
    var cateName: FetchedResults<CateEnt>
    @StateObject var fileData = FileViewModel()

    @State var showFileAdd = false
    @State var isDeleting = false

    @State var searchWord = ""
    @State var appearCount = 0
    @State var didAppear = false
    @State var selectedCateValue = "Folders All"
    @State var categories = ["Folders All"]
    @State private var keyboardHeight: CGFloat = 0
       
    static let fileDateFormat: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd yy"
        return formatter
    }()
    
    let columns = [
        GridItem(.flexible(), spacing: 18),
        GridItem(.flexible(), spacing: 18),
    ]

    var body: some View {
        NavigationView {
            //VStack(alignment: .center) {
                //Divider()
            VStack {
                ScrollView {
                    LazyVGrid(columns : columns, alignment: .center, spacing: 18) {
                        if selectedCateValue != "Folders All" {
                            ForEach(allFiles.filter({ ("\($0)".contains(searchWord) || searchWord.isEmpty ) && $0.fileCate?.cateName == selectedCateValue}), id: \.self) { aFile in
                                if selectedCateValue == aFile.fileCate?.cateName {
                                    NavigationLink(destination: FileDetail(aFile: aFile)) {

                                        // this ZStack is copied from one in else
                                        ZStack(alignment: .topLeading) {
                                            Image("folder") //outline color to gray
                                                .resizable()
                                                .frame(width: 148, height: 112)
                                            VStack(alignment: .leading, spacing: 2) {
                                                Text(aFile.fileCate?.cateName ?? "")
                                                    .fontWeight(.semibold)
                                                    .frame(maxWidth: 60)
                                                    .lineLimit(1)
                                                    .padding(.leading, 8)
                                                    .padding(.top, 6)
                                                HStack {
                                                    Text("tag:").foregroundColor(.gray)
                                                    Text(aFile.fileTag ?? "")
                                                        .fontWeight(.semibold)
                                                }
                                                .padding(.leading, 10)
                                                .padding(.top, 6)
                                                HStack {
                                                    Text("date:").foregroundColor(.gray)
                                                    Text(aFile.fileDate ?? Date(), formatter: FileList.fileDateFormat)
                                                        .fontWeight(.semibold)
                                                }.padding(.leading, 10)
                                                HStack {
                                                    Text("name:").foregroundColor(.gray)
                                                    Text(aFile.fileName ?? "")
                                                        .fontWeight(.semibold)
                                                        .frame(maxWidth: 70)
                                                        .lineLimit(1)
                                                }
                                                .padding(.leading, 10)
                                            }.padding(.trailing, 6)
                                            HStack {  //deleting
                                                Spacer()
                                                if isDeleting == true {
                                                    Button(action: {
                                                        context.delete(aFile)
                                                        try! context.save()
                                                    }, label: {
                                                        Image(systemName: "minus.circle.fill")
                                                            .foregroundColor(.red)
                                                            .font(.system(size: 24.0))
                                                    })
                                                }
                                            }
                                        } //ZStack

                                    } //NaviLink
                                } //if 2nd
                            } //ForEach
                        } //if 1st
                        else {
                            ForEach(allFiles.filter({ "\($0)".contains(searchWord) || searchWord.isEmpty}), id: \.self) { aFile in
                                NavigationLink(destination: FileDetail(aFile: aFile)) {

                                    //copy this ZStack to the 2nd if above
                                    ZStack(alignment: .topLeading) {
                                        Image("folder") //outline color to gray
                                            .resizable()
                                            .frame(width: 148, height: 112)
                                        VStack(alignment: .leading, spacing: 2) {
                                            Text(aFile.fileCate?.cateName ?? "")
                                                .fontWeight(.semibold)
                                                .frame(maxWidth: 60)
                                                .lineLimit(1)
                                                .padding(.leading, 8)
                                                .padding(.top, 6)
                                            HStack {
                                                Text("tag:").foregroundColor(.gray)
                                                Text(aFile.fileTag ?? "")
                                                    .fontWeight(.semibold)
                                            }
                                            .padding(.leading, 10)
                                            .padding(.top, 6)
                                            HStack {
                                                Text("date:").foregroundColor(.gray)
                                                Text(aFile.fileDate ?? Date(), formatter: FileList.fileDateFormat)
                                                    .fontWeight(.semibold)
                                            }.padding(.leading, 10)
                                            HStack {
                                                Text("name:").foregroundColor(.gray)
                                                Text(aFile.fileName ?? "")
                                                    .fontWeight(.semibold)
                                                    .frame(maxWidth: 70)
                                                    .lineLimit(1)
                                            }
                                            .padding(.leading, 10)
                                        }.padding(.trailing, 6)
                                        HStack {  //deleting
                                            Spacer()
                                            if isDeleting == true {
                                                Button(action: {
                                                    context.delete(aFile)
                                                    try! context.save()
                                                }, label: {
                                                    Image(systemName: "minus.circle.fill")
                                                        .foregroundColor(.red)
                                                        .font(.system(size: 24.0))
                                                })
                                            }
                                        }
                                    } //ZStack

                                } //NaviLink
                            } //ForEach
                       } //else
                    } //Lazy
                    .padding(.horizontal, 32)
                    .padding(.top, 12)
                } //Scroll
                HStack {    //cateMenu & search
                    Spacer()
                    Text("search by").foregroundColor(.gray)
                    VStack {
                        TextField("a keyword", text: $searchWord)
                            .frame(height: 10)
                    }.fixedSize()
                    if searchWord != "" {
                        Button(action: { searchWord = "" }, label: {
                            Image(systemName: "xmark.circle")
                        }).padding(3)
                    }
                    Text("in category").foregroundColor(.gray)
                    Menu(selectedCateValue) {
                        ForEach(categories, id:\.self) { cate in
                            Button(action: {
                                selectedCateValue = cate
                            }, label: {
                                Text(cate)
                            })
                        }
                    }
                    Spacer()
                    .onAppear(perform: onLoad)

                }
                .padding(.vertical, 4)
                .padding(.horizontal, 12)
                .background(Color.gray.opacity(0.1))
            } //VStack
            .navigationTitle("Files")
            .navigationBarItems(
                leading:
                Button(action: {
                    self.isDeleting.toggle()
                }) {
                    Text(isDeleting ? "Done" : "\(Image(systemName: "minus.circle"))")
                        .font(.system(size: 20))
                }.disabled(cateName.isEmpty),
                trailing:
                    Button(action: {
                        showFileAdd = true
                    }, label: {
                        Image(systemName: "plus.circle")
                            .font(.system(size: 24))
                    }).disabled(cateName.isEmpty)
                .sheet(isPresented: $showFileAdd) {
                    FileAddEdit()
                }
            )
            .padding(1)
            .environmentObject(File())  // fixed + button
        } //Navi
    }
    
    func onLoad() {
        if !didAppear {
            appearCount += 1
            cateName.reversed().forEach { val in
                categories.append(val.cateName ?? "")
            }
            didAppear = true
        }
    }

}

struct FileList_Previews: PreviewProvider {
    static var previews: some View {
        FileList().previewInterfaceOrientation(.portrait)
    }
}
