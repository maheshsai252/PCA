//
//  Settings.swift
//

import SwiftUI

struct Settings: View {
    var body: some View {
        VStack {
            NavigationView {
                Form {
                    Section(header: Text("Settings")
                        .fontWeight(.semibold)
                        .foregroundColor(.gray)
                        .font(.system(size: 24))
                    ) {
                        NavigationLink(destination: CateSetting()) {
                            Text("Folders")//.fontWeight(.semibold)
                        }.padding(8)
                    }.textCase(nil)
                    
                    Section(header: Text("Tools")
                        .fontWeight(.semibold)
                        .foregroundColor(.gray)
                        .font(.system(size: 24))
                    ) {
                        NavigationLink(destination: ExportData()) {
                            Text("Export Data")//.fontWeight(.semibold)
                        }.padding(8)
                    }.textCase(nil)
                }
                .font(.system(size: 24))
                .foregroundColor(.blue)
                .navigationBarTitle("")
                .navigationBarHidden(true)
            }
            Divider()
        }
    }
}

struct Settings_Previews: PreviewProvider {
    static var previews: some View {
        Settings()
    }
}
