//
//  TypeStore.swift
//  Argon
//
//  Created by Vincent Coetzee on 14/09/2023.
//

import Foundation

public class TypeRepository
    {
    private static var registeredTypes = Dictionary<Int,ArgonType>()
    
    public class func registerType(_ someType: ArgonType) -> ArgonType
        {
        guard let oldType = Self.registeredTypes[someType.typeHash] else
            {
            Self.registeredTypes[someType.typeHash] = someType
            return(someType)
            }
        return(oldType)
        }
    }
