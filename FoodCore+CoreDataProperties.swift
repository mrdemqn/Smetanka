//
//  FoodCore+CoreDataProperties.swift
//  Smetanka
//
//  Created by Димон on 15.08.23.
//
//

import Foundation
import CoreData


extension FoodCore {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FoodCore> {
        return NSFetchRequest<FoodCore>(entityName: "FoodCore")
    }

    @NSManaged public var id: String?
    @NSManaged public var title: String?
    @NSManaged public var difficulty: String?
    @NSManaged public var image: String?
    @NSManaged public var portion: String?
    @NSManaged public var time: String?
    @NSManaged public var recipeDescription: String?
    @NSManaged public var ingredients: [String]?
    @NSManaged public var method: [[String: String]]?

}

extension FoodCore : Identifiable {

}
