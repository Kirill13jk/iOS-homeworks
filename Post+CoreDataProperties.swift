//
//  Post+CoreDataProperties.swift
//  Navigation
//
//  Created by prom1 on 13.09.2024.
//
//

import Foundation
import CoreData


extension Post {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Post> {
        return NSFetchRequest<Post>(entityName: "Post")
    }

    @NSManaged public var title: String?
    @NSManaged public var viewCount: Int32
    @NSManaged public var author: String?
    @NSManaged public var postDescription: String?
    @NSManaged public var image: Data?
    @NSManaged public var likes: Int32

}

extension Post : Identifiable {

}
