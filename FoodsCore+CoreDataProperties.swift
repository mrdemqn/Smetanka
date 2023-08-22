//
//  FoodsCore+CoreDataProperties.swift
//  Smetanka
//
//  Created by Димон on 15.08.23.
//
//

import Foundation
import CoreData


extension FoodsCore {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FoodsCore> {
        return NSFetchRequest<FoodsCore>(entityName: "FoodsCore")
    }

    @NSManaged public var foods: NSSet?

}

// MARK: Generated accessors for foods
extension FoodsCore {

    @objc(addFoodsObject:)
    @NSManaged public func addToFoods(_ value: FoodCore)

    @objc(removeFoodsObject:)
    @NSManaged public func removeFromFoods(_ value: FoodCore)

    @objc(addFoods:)
    @NSManaged public func addToFoods(_ values: NSSet)

    @objc(removeFoods:)
    @NSManaged public func removeFromFoods(_ values: NSSet)

}

extension FoodsCore : Identifiable {

}
