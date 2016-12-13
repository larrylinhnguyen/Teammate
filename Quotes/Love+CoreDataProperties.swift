//
//  Love+CoreDataProperties.swift
//  Quotes
//
//  Created by Larry on 9/6/16.
//  Copyright © 2016 Larry Skyla. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Love {

    @NSManaged var isLove: NSNumber?
    @NSManaged var quote: Quote?

}
