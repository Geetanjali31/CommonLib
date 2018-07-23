//
//  DBConnectionAbstraction.swift
//  CommonHelper
//
//  Created by Geetanjali M on 12/07/18.
//  Copyright © 2018 Quadlogix. All rights reserved.
//

import Foundation

//This protocol defines the rules for the DB managers to get the data from the persistence storage.
//This way we can provide multiple implementation for persistance storage.

public protocol PDBConnection
{
    /// Save database context object.
    func saveConnection() throws

	func createRow<T>(tableName: String) throws -> T?
    
    /// Insert data into given table.
    ///
    /// - Parameters:
    ///   - tableName: Table name.
    ///   - newObject: Data to be insert into databse.
    /// - Returns: Returns true if insertion successed, else throw exception.
    func insert<T>(tableName: String, newObject: T) throws -> Bool

    /// Update data into given table.
    ///
    /// - Parameters:
    ///   - tableName: Table name.
    ///   - newObject: Data to be updated into databse.
    /// - Returns: Returns true if updation successed, else throw exception.
    func update<T>(tableName: String, newObject: T) throws -> Bool

    /// Update data into given table.
    ///
    /// - Parameters:
    ///   - tableName: Table name.
    ///   - newObject: Data to be updated into databse.
    ///   - predicate: Provide predicate (i.e where condition) for updating data.
    /// - Returns: Returns true if updation successed, else throw exception.
    func update<T>(tableName: String, newObject: T, predicate: NSPredicate) throws -> Bool

    /// Delete data from given table.
    ///
    /// - Parameter tableName: Table name.
    /// - Returns: Returns true if deletion successed, else throw exception.
    func delete(tableName: String) throws -> Bool
    
    /// Delete data from given table.
    ///
    /// - Parameters:
    ///   - tableName: Table name.
    ///   - predicate: Provide predicate (i.e where condition) for deleting data.
    /// - Returns: Returns true if deletion successed, else throw exception.
    func delete(tableName: String, predicate: NSPredicate) throws -> Bool

    /// Fetch data from databse.
    ///
    /// - Parameter tableName: Table name.
    /// - Returns: Returns fetched data from databse.
    func fetch<T>(tableName: String) throws -> [T]?
    
    /// Fetch data from databse.
    ///
    /// - Parameters:
    ///   - tableName: Table name.
    ///   - predicate: Provide predicate (i.e where condition) for fetching data.
    /// - Returns: Returns fetched data from databse.
    func fetch<T>(tableName: String, predicate: NSPredicate) throws -> [T]?

    /// Fetch data from databse.
    ///
    /// - Parameters:
    ///   - tableName: Table name.
    ///   - sortKey: Key by which data need to be sort.
    ///   - isAscending: Send true if data need to sort in ascending order.
    /// - Returns: Returns fetched data from databse.
    func fetch<T>(tableName: String, sortKey: String, isAscending: Bool) throws -> [T]?

    /// Fetch data from databse.
    ///
    /// - Parameters:
    ///   - tableName: Table name.
    ///   - predicate: Provide predicate (i.e where condition) for fetching data.
    ///   - sortKey: Key by which data need to be sort.
    ///   - isAscending: Send true if data need to sort in ascending order.
    /// - Returns: Returns fetched data from databse.
    func fetch<T>(tableName: String, predicate: NSPredicate, sortKey: String, isAscending: Bool) throws -> [T]?
    
    /// Fetch data from databse.
    ///
    /// - Parameters:
    ///   - tableName: Table name.
    ///   - predicate: Provide predicate (i.e where condition) for fetching data.
    ///   - sortKey: Key by which data need to be sort.
    ///   - isAscending: Send true if data need to sort in ascending order.
    ///   - limit: Specify number of records return from database.
    /// - Returns: Returns fetched data from databse.
    func fetch<T>(tableName: String, predicate: NSPredicate, sortKey: String, isAscending: Bool,limit:Int) throws -> [T]?
}


