//
//  RecentSearch+CoreDataProperties.swift
//  Weather app
//
//  Created by Nataliia Shusta on 14/06/2023.
//
//

import Foundation
import CoreData

extension RecentSearch {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<RecentSearch> {
        return NSFetchRequest<RecentSearch>(entityName: "RecentSearch")
    }

    @NSManaged public var query: String?

}

extension RecentSearch: Identifiable {

}
