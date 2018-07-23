//
//  CoreDataDBConnection.swift
//  CommonHelper
//
//  Created by Geetanjali M on 12/07/18.
//  Copyright © 2018 Quadlogix. All rights reserved.
//

import Foundation
import CoreData

open class CoreDataDBConnection : PDBConnection
{
    let databaseName: String
    
    /// @author     Geetanjali M    12/10/2017
    /// NSPersistentContainer object .
    @available(iOS 10.0, *)
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        
        let container = NSPersistentContainer(name: self.databaseName)
//        let description = NSPersistentStoreDescription()
//        description.shouldInferMappingModelAutomatically = true
//        description.shouldMigrateStoreAutomatically = true
//        container.persistentStoreDescriptions = [description]
        
        container.loadPersistentStores(completionHandler: {
            (storeDescription, error) in
            if let error = error as NSError?
            {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data context

    /// NSManagedObjectContext object.
    lazy var databaseContext : NSManagedObjectContext = {
        return self.persistentContainer.viewContext
    }()

    /// Initialize CoreDataDBConnection object.
    ///
    /// - Parameter dbName: Name of your database.
    public init(withDatabaseName dbName: String)
    {
        self.databaseName = dbName
    }
    
    open func createRow<T>(tableName: String) throws -> T? {
        let profileTableObj = NSEntityDescription.insertNewObject(forEntityName: tableName, into: self.databaseContext)
        return profileTableObj as? T
    }
    
    /// Save database context object.
    open func saveConnection() throws {
        do {
            try self.databaseContext.save()
        } catch _ {
            /*
             FIXME: Throw proper error
             */
            throw NSError(domain: "Database error", code: 1, userInfo: nil)
        }
    }

    /// Insert data into given table.
    ///
    /// - Parameters:
    ///   - tableName: Table name.
    ///   - newObject: Data to be insert into databse.
    /// - Returns: Returns true if insertion successed, else throw exception.
    open func insert<T>(tableName: String, newObject: T) throws -> Bool {
        do {
//            let tableRowObj = NSEntityDescription.insertNewObject(forEntityName: tableName, into: self.databaseContext)

//            if let newDataDict = newObject as? [String:Any] {
//                for keyValueTuple in newDataDict {
//                    tableRowObj.setValue(keyValueTuple.value, forKey: keyValueTuple.key)
//                }
//            }
            try self.saveConnection()
            return true
        } catch _ {
            /*
             FIXME: Throw proper error
             */
            throw NSError(domain: "Database error", code: 1, userInfo: nil)
        }
    }
    
    /// Update data into given table.
    ///
    /// - Parameters:
    ///   - tableName: Table name.
    ///   - newObject: Data to be updated into databse.
    /// - Returns: Returns true if updation successed, else throw exception.
    open func update<T>(tableName: String, newObject: T) throws -> Bool {
        do {
            let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName: tableName)
            fetchRequest.returnsObjectsAsFaults = false

            let fetchedResults = try self.databaseContext.fetch(fetchRequest)
            for result in fetchedResults {
                let tableRowObj = result as! NSManagedObject
                if let updateDataDict = newObject as? [String:Any] {
                    for keyValueTuple in updateDataDict {
                        tableRowObj.setValue(keyValueTuple.value, forKey: keyValueTuple.key)
                    }
                } else {
                    /*
                     FIXME: Throw proper error
                     */
                    throw NSError(domain: "Database error", code: 1, userInfo: nil)
                }
            }
            try self.saveConnection()
            
            return true
        } catch _ {
            /*
             FIXME: Throw proper error
             */
            throw NSError(domain: "Database error", code: 1, userInfo: nil)
        }
    }

    /// Update data into given table.
    ///
    /// - Parameters:
    ///   - tableName: Table name.
    ///   - newObject: Data to be updated into databse.
    ///   - predicate: Provide predicate (i.e where condition) for updating data.
    /// - Returns: Returns true if updation successed, else throw exception.
    open func update<T>(tableName: String, newObject: T, predicate: NSPredicate) throws -> Bool {
        do {
            let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName: tableName)
            fetchRequest.returnsObjectsAsFaults = false
            fetchRequest.predicate = predicate
        
            let fetchedResults = try self.databaseContext.fetch(fetchRequest)
            for result in fetchedResults {
                let tableRowObj = result as! NSManagedObject
                if let updateDataDict = newObject as? [String:Any] {
                    for keyValueTuple in updateDataDict {
                        tableRowObj.setValue(keyValueTuple.value, forKey: keyValueTuple.key)
                    }
                } else {
                    /*
                     FIXME: Throw proper error
                     */
                    throw NSError(domain: "Invalid data format", code: 2, userInfo: nil)
                }
            }
            try self.saveConnection()
            
            return true
        } catch _ {
            /*
             FIXME: Throw proper error
             */
            throw NSError(domain: "Database error", code: 1, userInfo: nil)
        }
    }
    
    
    /// Delete data from given table.
    ///
    /// - Parameter tableName: Table name.
    /// - Returns: Returns true if deletion successed, else throw exception.
    open func delete(tableName: String) throws -> Bool {
        do {
            let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName: tableName)

            let fetchedResults = try self.databaseContext.fetch(fetchRequest)
            for tableRowObj in fetchedResults {
                self.databaseContext.delete(tableRowObj as! NSManagedObject)
                
            }
            
            try self.saveConnection()
            
            return true
        } catch _ {
            /*
             FIXME: Throw proper error
             */
            throw NSError(domain: "Database error", code: 1, userInfo: nil)
        }
    }
    
    /// Delete data from given table.
    ///
    /// - Parameters:
    ///   - tableName: Table name.
    ///   - predicate: Provide predicate (i.e where condition) for deleting data.
    /// - Returns: Returns true if deletion successed, else throw exception.
    open func delete(tableName: String, predicate: NSPredicate) throws -> Bool {
        do {
            let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName: tableName)
            fetchRequest.predicate = predicate
    
            let fetchedResults = try self.databaseContext.fetch(fetchRequest)
            for tableRowObj in fetchedResults {
                self.databaseContext.delete(tableRowObj as! NSManagedObject)
            }
            
            try self.saveConnection()
            
            return true
        } catch _ {
            /*
             FIXME: Throw proper error
             */
            throw NSError(domain: "Database error", code: 1, userInfo: nil)
        }
    }
    
    /// Fetch data from databse.
    ///
    /// - Parameter tableName: Table name.
    /// - Returns: Returns fetched data from databse.
    open func fetch<T>(tableName: String) throws -> [T]? {
        do {
            let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName: tableName)
            fetchRequest.returnsObjectsAsFaults = false

            let fetchedResults = try self.databaseContext.fetch(fetchRequest)
            return fetchedResults as? [T]
        } catch _ {
            /*
             FIXME: Throw proper error
             */
            throw NSError(domain: "Database error", code: 1, userInfo: nil)
        }
    }
    
    /// Fetch data from databse.
    ///
    /// - Parameters:
    ///   - tableName: Table name.
    ///   - predicate: Provide predicate (i.e where condition) for fetching data.
    /// - Returns: Returns fetched data from databse.
    open func fetch<T>(tableName: String, predicate: NSPredicate) throws -> [T]? {
        do {
            let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName: tableName)
            fetchRequest.returnsObjectsAsFaults = false
            fetchRequest.predicate = predicate

            let fetchedResults = try self.databaseContext.fetch(fetchRequest)
            return fetchedResults as? [T]
        } catch _ {
            /*
             FIXME: Throw proper error
             */
            throw NSError(domain: "Database error", code: 1, userInfo: nil)
        }
    }
    open func fetchWithLimit<T>(tableName: String, predicate: NSPredicate, limit: Int) throws -> [T]? {
        do {
            let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName: tableName)
            fetchRequest.returnsObjectsAsFaults = false
            fetchRequest.predicate = predicate
            fetchRequest.fetchLimit = limit
            let fetchedResults = try self.databaseContext.fetch(fetchRequest)
            return fetchedResults as? [T]
        } catch _ {
            /*
             FIXME: Throw proper error
             */
            throw NSError(domain: "Database error", code: 1, userInfo: nil)
        }
    }
    /// Fetch data from databse.
    ///
    /// - Parameters:
    ///   - tableName: Table name.
    ///   - sortKey: Key by which data need to be sort.
    ///   - isAscending: Send true if data need to sort in ascending order.
    /// - Returns: Returns fetched data from databse.
    open func fetch<T>(tableName: String, sortKey: String, isAscending: Bool) throws -> [T]? {
        do {
            let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName: tableName)
            fetchRequest.returnsObjectsAsFaults = false
            fetchRequest.sortDescriptors = [NSSortDescriptor(key: sortKey as String, ascending: isAscending)]

            let fetchedResults = try self.databaseContext.fetch(fetchRequest)
            return fetchedResults as? [T]
        } catch _ {
            /*
             FIXME: Throw proper error
             */
            throw NSError(domain: "Database error", code: 1, userInfo: nil)
        }
    }
    
    /// Fetch data from databse.
    ///
    /// - Parameters:
    ///   - tableName: Table name.
    ///   - predicate: Provide predicate (i.e where condition) for fetching data.
    ///   - sortKey: Key by which data need to be sort.
    ///   - isAscending: Send true if data need to sort in ascending order.
    /// - Returns: Returns fetched data from databse.
    open func fetch<T>(tableName: String, predicate: NSPredicate, sortKey: String, isAscending: Bool) throws -> [T]? {
        do {
            let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName: tableName)
            fetchRequest.returnsObjectsAsFaults = false
            fetchRequest.predicate = predicate
            fetchRequest.sortDescriptors = [NSSortDescriptor(key: sortKey as String, ascending: isAscending)]

            let fetchedResults = try self.databaseContext.fetch(fetchRequest)
            return fetchedResults as? [T]
        } catch _ {
            /*
             FIXME: Throw proper error
             */
            throw NSError(domain: "Database error", code: 1, userInfo: nil)
        }
    }
    
    /// Fetch data from databse.
    ///
    /// - Parameters:
    ///   - tableName: Table name.
    ///   - predicate: Provide predicate (i.e where condition) for fetching data.
    ///   - sortKey: Key by which data need to be sort.
    ///   - isAscending: Send true if data need to sort in ascending order.
    ///   - limit: Specify number of records return from database.
    /// - Returns: Returns fetched data from databse.
   open func fetch<T>(tableName: String, predicate: NSPredicate, sortKey: String, isAscending: Bool,limit:Int) throws -> [T]?
    {
        do {
            let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName: tableName)
            fetchRequest.returnsObjectsAsFaults = false
            fetchRequest.predicate = predicate
            fetchRequest.fetchLimit = limit
            fetchRequest.sortDescriptors = [NSSortDescriptor(key: sortKey as String, ascending: isAscending)]
            
            let fetchedResults = try self.databaseContext.fetch(fetchRequest)
            return fetchedResults as? [T]
        } catch _ {
            /*
             FIXME: Throw proper error
             */
            throw NSError(domain: "Database error", code: 1, userInfo: nil)
        }
    }
  

}

