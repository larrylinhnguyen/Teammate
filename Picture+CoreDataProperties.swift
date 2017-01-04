//
//  Picture+CoreDataProperties.swift
//  Quotes
//
//  Created by Larry on 1/4/17.
//  Copyright © 2017 Larry Skyla. All rights reserved.
//

import Foundation
import CoreData


extension Picture {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Picture> {
        return NSFetchRequest<Picture>(entityName: "Picture");
    }

    @NSManaged public var pic: NSData?
    @NSManaged public var teammate: Teammate?

}
