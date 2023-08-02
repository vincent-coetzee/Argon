//
//  ArgonTypes.swift
//  Argon
//
//  Created by Vincent Coetzee on 24/05/2023.
//

import Foundation

public struct Argon
    {
    private static var _nextIndex = 1
    
    public static var nextIndex: Int
        {
        let index = self._nextIndex
        self._nextIndex += 1
        return(index)
        }
        
    public static func nextIndex(named: String) -> String
        {
        "\(named)\(Self.nextIndex)"
        }
        
    public typealias Byte = UInt8
    public typealias Character = Swift.UInt16
    public typealias Boolean = Bool
    public typealias String = Swift.String
    public typealias Float = Swift.Double
    public typealias Integer = Swift.Int64
    public typealias Symbol = Swift.String
    }

public typealias Symbols = Array<Argon.Symbol>
