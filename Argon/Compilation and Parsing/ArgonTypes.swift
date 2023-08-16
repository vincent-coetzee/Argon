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

    public struct Date
        {
        public static let nullDate = Date(day: 0,month: 0,year: 0)
        
        public let day: Int
        public let month: Int
        public let year: Int
        
        public init(string: String)
            {
            let pieces = string.components(separatedBy: "/")
            self.day = Int(pieces[0])!
            self.month = Int(pieces[1])!
            self.year = Int(pieces[2])!
            }
            
        public init(day: Int,month: Int,year: Int)
            {
            self.day = day
            self.month = month
            self.year = year
            }
        }
        
    public struct Time
        {
        public static let nullTime = Time(hour: 0,minute: 0,second: 0,millisecond: 0)
        
        public let hour: Int
        public let minute: Int
        public let second: Int
        public let millisecond: Int
        
        public init(string: String)
            {
            let pieces = string.components(separatedBy: ":")
            self.hour = Int(pieces[0])!
            self.minute = Int(pieces[1])!
            self.second = Int(pieces[2])!
            self.millisecond = pieces.count == 4 ? Int(pieces[3])! : 0
            }
            
        public init(hour: Int,minute: Int,second: Int,millisecond: Int)
            {
            self.hour = hour
            self.minute = minute
            self.second = second
            self.millisecond = millisecond
            }
        }
        
    public struct DateTime
        {
        public let date: Date
        public let time: Time
        
        public init(date: Argon.Date,time: Argon.Time)
            {
            self.date = date
            self.time = time
            }
        }
        
    public struct Range
        {
        public var lowerBound: Integer
        public var upperBound: Integer
        
        public init(lowerBound: Integer,upperBound:Integer)
            {
            self.lowerBound = lowerBound
            self.upperBound = upperBound
            }
            
        public init(lowerBound: Int,upperBound:Int)
            {
            self.lowerBound = Integer(lowerBound)
            self.upperBound = Integer(upperBound)
            }
        }
        
    public enum ArrayIndex
        {
        case none
        case discreteType(TypeNode)
        case enumeration(Enumeration)
        case subType(SubType)
        case integer
        
        public var encoding: String
            {
            switch(self)
                {
                case(.none):
                    fatalError()
                case(.discreteType(let node)):
                    return("m\(node.encoding)")
                case(.enumeration(let enumeration)):
                    return("n\(enumeration.encoding)")
                case(.integer):
                    return("q")
                case(.subType(let subType)):
                    return("q\(subType.encoding)")
                    
                }
            }
        }
    }

public typealias Symbols = Array<Argon.Symbol>

extension NSCoder
    {
    public func decodeArrayIndex(forKey key: String) -> Argon.ArrayIndex
        {
        let index = self.decodeInteger(forKey: key + "_index")
        switch(index)
            {
            case(0):
                return(.none)
            case(1):
                return(.discreteType(self.decodeObject(forKey: key + "discreteType") as! TypeNode))
            case(2):
                return(.enumeration(self.decodeObject(forKey: key + "enumeration") as! Enumeration))
            case(3):
                let lower = self.decodeObject(forKey: key + "enumerationRange.lower") as! EnumerationCase
                let upper = self.decodeObject(forKey: key + "enumerationRange.upper") as! EnumerationCase
                let enumeration = self.decodeObject(forKey: key + "enumerationRange.enumeration") as! Enumeration
                return(.enumerationRange(enumeration,lowerBound: lower,upperBound: upper))
            case(4):
                let lower = Argon.Integer(self.decodeInteger(forKey: key + "integerRange.lower"))
                let upper = Argon.Integer(self.decodeInteger(forKey: key + "integerRange.upper"))
                return(.integerRange(lowerBound: lower,upperBound: upper))
            case(5):
                return(.integer)
            default:
                fatalError("this should not happen")
            }
        }
        
    public func encode(_ arrayIndex: Argon.ArrayIndex,forKey key: String)
        {
        switch(arrayIndex)
            {
            case(.none):
                self.encode(0,forKey: key + "_index")
            case(.discreteType(let type)):
                self.encode(1,forKey: key + "_index")
                self.encode(type,forKey: key + "discreteType")
            case(.enumeration(let enumeration)):
                self.encode(2,forKey: key + "_index")
                self.encode(enumeration,forKey: key + "enumeration")
            case(.enumerationRange(let enumeration,let lower,let upper)):
                self.encode(3,forKey: key + "_index")
                self.encode(enumeration,forKey: key + "enumerationRange.enumeration")
                self.encode(lower,forKey: key + "enumerationRange.lower")
                self.encode(upper,forKey: key + "enumerationRange.upper")
            case(.integerRange(let lower,let upper)):
                self.encode(4,forKey: key + "_index")
                self.encode(lower,forKey: key + "integerRange.lower")
                self.encode(upper,forKey: key + "integerRange.upper")
            case(.integer):
                self.encode(5,forKey: key + "_index")
            }
        }
    }
