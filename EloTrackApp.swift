//
//  EloTrackApp.swift
//  EloTrack
//
//  Created by Hellman Zhao on 5/15/22.
//

import SwiftUI

@main

struct EloTrackApp: App {
    
    let persistenceContainer = PersistenceController.shared
    
    var body: some Scene {
        WindowGroup {
            HomeView()
                .environment(\.managedObjectContext, persistenceContainer.persistentContainer.viewContext)
        }
    }
}
