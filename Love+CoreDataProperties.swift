//
//  Love+CoreDataProperties.swift
//  Quotes
//
//  Created by Larry on 1/4/17.
//  Copyright © 2017 Larry Skyla. All rights reserved.
//

import Foundation
import CoreData


extension Love {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Love> {
        return NSFetchRequest<Love>(entityName: "Love");
    }

    @NSManaged public var islove: Bool
    @NSManaged public var teammate: Teammate?

}
