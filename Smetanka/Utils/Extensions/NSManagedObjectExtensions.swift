//
//  E.swift
//  Smetanka
//
//  Created by Димон on 2.08.23.
//

import CoreData

extension NSManagedObject {
    
    @nonobjc public class func fetchTypedRequest<T: NSManagedObject>(_ type: T.Type) -> NSFetchRequest<T> {
        return NSFetchRequest<T>(entityName: String(describing: type))
    }
}
