//  PCA_v2.0.1_20220514
//  Home.swift
//

import SwiftUI

struct Home: View {
    let numTabs = 4
    let minDragTranslationForSwipe: CGFloat = 50
    @State private var selectedTab = 0

    var body: some View {
        TabView(selection: $selectedTab) {
            FileList()
                .tabItem {
                    Image(systemName: "folder.badge.gearshape")
                    Text("Files")
                }
                .tag(0)
            //  .highPriorityGesture(DragGesture().onEnded( {
            //      self.handleSwipe(translation: $0.translation.width)
            //  }))
            Settings()
                .tabItem {
                    Image(systemName: "gearshape")
                    Text("Settings")
                }
                .tag(1)
            //  .highPriorityGesture(DragGesture().onEnded( {
            //      self.handleSwipe(translation: $0.translation.width)
            //  }))
        }
    }

    private func handleSwipe(translation: CGFloat) {
        if translation > minDragTranslationForSwipe && selectedTab > 0 {
            selectedTab -= 1
        } else  if translation < -minDragTranslationForSwipe && selectedTab < numTabs-1 {
            selectedTab += 1
        }
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}
