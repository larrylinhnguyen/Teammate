//
//  Teammate+CoreDataProperties.swift
//  Quotes
//
//  Created by Larry on 1/4/17.
//  Copyright © 2017 Larry Skyla. All rights reserved.
//

import Foundation
import CoreData


extension Teammate {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Teammate> {
        return NSFetchRequest<Teammate>(entityName: "Teammate");
    }

    @NSManaged public var avatar: NSData?
    @NSManaged public var bio: String?
    @NSManaged public var firstname: String?
    @NSManaged public var id: String?
    @NSManaged public var isLove: Bool
    @NSManaged public var lastname: String?
    @NSManaged public var title: String?
    @NSManaged public var love: Love?
    @NSManaged public var picture: Picture?

}
