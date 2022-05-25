//
//  Group+CoreDataProperties.swift
//  EloTap
//
//  Created by Hellman Zhao on 5/24/22.
//
//

import Foundation
import CoreData


extension Group {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Group> {
        return NSFetchRequest<Group>(entityName: "Group")
    }

    @NSManaged public var groupName: String?
    @NSManaged public var numPlayers: NSNumber?
    @NSManaged public var rankByWins: Int16
    @NSManaged public var players: NSSet?
    @NSManaged public var matches: NSSet?
    @NSManaged public var numMatches: Int16
    
    public var playerArray: [Player] {
        let set = players as? Set<Player> ?? []
        return set.sorted{
            $0.id!.intValue < $1.id!.intValue
        }
    }
    
    public var matchesArray: [Match] {
        let set2 = matches as? Set<Match> ?? []
        return set2.sorted{
            $0.identify!.intValue < $1.identify!.intValue
        }
    }

}

// MARK: Generated accessors for players
extension Group {

    @objc(addPlayersObject:)
    @NSManaged public func addToPlayers(_ value: Player)

    @objc(removePlayersObject:)
    @NSManaged public func removeFromPlayers(_ value: Player)

    @objc(addPlayers:)
    @NSManaged public func addToPlayers(_ values: NSSet)

    @objc(removePlayers:)
    @NSManaged public func removeFromPlayers(_ values: NSSet)

}

// MARK: Generated accessors for matches
extension Group {

    @objc(addMatchesObject:)
    @NSManaged public func addToMatches(_ value: Match)

    @objc(removeMatchesObject:)
    @NSManaged public func removeFromMatches(_ value: Match)

    @objc(addMatches:)
    @NSManaged public func addToMatches(_ values: NSSet)

    @objc(removeMatches:)
    @NSManaged public func removeFromMatches(_ values: NSSet)

}

extension Group : Identifiable {

}
