//
//  CoreDataManager.swift
//  EloTrack
//
//  Created by Hellman Zhao on 5/18/22.
//

import Foundation
import CoreData

struct PersistenceController{
    
    static let shared = PersistenceController()
    
    let persistentContainer: NSPersistentContainer
    
    init() {
        persistentContainer = NSPersistentContainer(name: "CoreDataModel")
        persistentContainer.loadPersistentStores { (description, error) in
            if let error = error {
                fatalError("Core Data Store failed \(error.localizedDescription)")
            }
        }
    }
    
    func updateGroup() {
        
        do{
            try persistentContainer.viewContext.save()
        } catch {
            persistentContainer.viewContext.rollback()
        }
        
    }
    
    func deleteGroup(group: Group){
        
        persistentContainer.viewContext.delete(group)
        
        do{
            try persistentContainer.viewContext.save()
        } catch {
            persistentContainer.viewContext.rollback()
            print("Failed to save context \(error)")
        }
        
    }
    
    func getallGroups() -> [Group] {
        
        let fetchRequest: NSFetchRequest<Group> = Group.fetchRequest()
        
        do{
            return try persistentContainer.viewContext.fetch(fetchRequest)
        } catch{
            return []
        }
        
    }
    
    func saveGroup(groupName: String, numPlayers: Int16, players: [Player]){
        
        let group = Group(context: persistentContainer.viewContext)
        group.groupName=groupName
        group.numPlayers=(numPlayers) as NSNumber
        group.rankByWins=Int16(0)
        group.numMatches=Int16(0)
        
        for index in 0..<players.count {
            group.addToPlayers(players[index])
        }
        
        do{
            try persistentContainer.viewContext.save()
        } catch{
            print("Failed to save group \(error)")
        }
    }
    
}
