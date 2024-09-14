//
//  FavoritePostE+CoreDataProperties.swift
//  Navigation
//
//  Created by prom1 on 14.09.2024.
//
//

import Foundation
import CoreData


extension FavoritePostE {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FavoritePostE> {
        return NSFetchRequest<FavoritePostE>(entityName: "FavoritePostE")
    }

    @NSManaged public var title: String?
    @NSManaged public var author: String?
    @NSManaged public var content: String?
    @NSManaged public var likes: Int64
    @NSManaged public var views: Int64
    @NSManaged public var imageData: Data?

}

extension FavoritePostE : Identifiable {

}
