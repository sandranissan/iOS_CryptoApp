//
//  Final_ProjectApp.swift
//  Final Project
//
//  Created by Sandra Nissan on 2021-11-29.
//

import SwiftUI

@main
struct Final_ProjectApp: App {
    @StateObject var crypto = CurrencyModel()
    let persistanceContainer = PersistenceController.shared
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(crypto)
                .environment(\.managedObjectContext, persistanceContainer.container.viewContext)
        }
        
    }
}
