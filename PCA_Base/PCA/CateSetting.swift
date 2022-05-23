//
//  CateSettingOne.swift
//

import SwiftUI
import CoreData

struct CateSetting: View {
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(sortDescriptors: [ NSSortDescriptor(keyPath:\CateEnt.cateOrdinal, ascending:true) ], animation:.default) private
    var allCates: FetchedResults<CateEnt>
    @StateObject var cateData = CateViewModel()
    @State var showAlert = false
    @State private var showReadMe = false

    var body: some View {
        VStack(alignment: .center) {
            NavigationView {
                List {
                    //add
                    HStack {
                        TextField("add a new folder", text: $cateData.cateName)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        Button(action: {
                            cateData.lastValue = Int((allCates.last?.cateOrdinal ?? 0) + 1)
                            cateData.writeCate(context: viewContext);
                        }, label: {
                            title: do { Text(cateData.updateCate == nil ? "Add" : "Rename").modifier(mainButtom())
                            }
                        })
                        .padding()
                        .disabled(cateData.cateName == "" ? true : false)
                        .opacity(cateData.cateName == "" ? 0.4 : 1)
                    }.listRowSeparator(.hidden)
                    //display
                    ForEach(allCates, id: \.id) { aCate in
                      Text("\(aCate.cateName ?? "")")
                      //Text("\(aCate.cateName ?? "") \(aCate.cateOrdinal)")
                        .onTapGesture {
                            withAnimation {
                                cateData.EditCate(cateItem: aCate)
                                //showCateRename.toggle()
                            }
                        }
                    }
                    .onMove(perform: move)
                    .onDelete(perform: delete)
                    .font(.system(size: 20))
                } //List
                .font(.system(size: 18))
                .toolbar { EditButton().font(.title2) }
                .navigationBarTitle("Folders 🗂")
            }
            HStack {
                Spacer()
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }, label: {
                    Text("Done").modifier(plainButtom())
                })
                Spacer()
            }
        }
        /*
        .sheet(isPresented: $cateData.isNewData, content: {
            CateRename(cateData: cateData)
        })*/
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Sorry"), message: Text("this folder is in use"), dismissButton: .default(Text("OK")) )
        }
    }
    /*
    private func save (addedCate: String) {
        if catename != "" {
            let itemToSave = CateEnt(context: self.viewContext)
            itemToSave.id = UUID()
            itemToSave.cateName = "\(catename)"
            itemToSave.cateOrdinal = (cateent.last?.cateOrdinal ?? 0) + 1
            try? self.viewContext.save()
            catename = ""
        }
    }*/

    private func delete(at offsets: IndexSet) {
        for offset in offsets {
            let addedCate = allCates[offset]
//            if addedCate.cateFile?.count == .zero {
            if addedCate.cateFile?.count == .zero {
                viewContext.delete(addedCate)
            } else {
                showAlert = true
            }
            saveData()
        }
    }

    private func saveData() {
        try? self.viewContext.save()
    }

    private func move(from source: IndexSet, to destination: Int) {
        if source.first! > destination {
            allCates[source.first!].cateOrdinal = allCates[destination].cateOrdinal - 1
            for i in destination...allCates.count - 1 {
                allCates[i].cateOrdinal = allCates[i].cateOrdinal + 1
            }
        }
        if source.first! < destination {
            allCates[source.first!].cateOrdinal = allCates[destination-1].cateOrdinal + 1
            for i in 0...destination-1 {
                allCates[i].cateOrdinal = allCates[i].cateOrdinal - 1
            }
        }
        saveData()
    }
    
}

struct CateSetting_Previews: PreviewProvider {
    static var previews: some View {
        CateSetting()
    }
}
