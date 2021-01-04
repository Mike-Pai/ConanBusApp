//
//  ConanBusApp.swift
//  ConanBus
//
//  Created by 白謹瑜 on 2021/1/4.
//

import SwiftUI

@main
struct ConanBusApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
