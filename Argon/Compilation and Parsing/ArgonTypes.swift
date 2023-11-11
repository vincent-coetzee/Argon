//
//  ArgonTypes.swift
//  Argon
//
//  Created by Vincent Coetzee on 24/05/2023.
//

import Foundation

//
//
// Master TODO List
//
// TODO: 1. Resolve pattern matching
// TODO: 2. Resolve generators
//
//
public struct Argon
    {
    public static let projectStateFilename = "ProjectState.argons"
    
    public static let moduleExtension = "argonm"
    public static let sourceExtension = "argon"
    public static let projectExtension = "argonp"
    public static let stateExtension = "argons"
    
    public static let dateRegex = try! NSRegularExpression(pattern: "^[0-3]?[0-9]/[0-1]?[0-9]/[0-9]{4}$")
    public static let timeRegex = try! NSRegularExpression(pattern: "^[0-2]?[0-9]:[0-5]?[0-9]:[0-5]?[0-9](\\.[0-9]{1,4})?$")
    public static let dateTimeRegex = try! NSRegularExpression(pattern: "^[0-3]?[0-9]/[0-1]?[0-9]/[0-9]{4} [0-2]?[0-9]:[0-5]?[0-9]:[0-5]?[0-9](\\.[0-9]{1,4})?$")
    
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
    public typealias Atom = Swift.String

    public struct Date: Hashable
        {
        public static func ==(lhs: Date,rhs: Date) -> Bool
            {
            lhs.day == rhs.day && lhs.month == rhs.month && lhs.year == rhs.year
            }
            
        public static let nullDate = Date(day: 0,month: 0,year: 0)
        
        public let day: Int
        public let month: Int
        public let year: Int
        
        public init(matchString: String)
            {
            let pieces = matchString.components(separatedBy: CharacterSet.decimalDigits.inverted).filter{!$0.isEmpty}
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
            
        public func hash(into hasher:inout Hasher)
            {
            hasher.combine("DATE")
            hasher.combine(self.day)
            hasher.combine(self.month)
            hasher.combine(self.year)
            }
        }
        
    public struct Time: Hashable
        {
        public static func ==(lhs: Time,rhs: Time) -> Bool
            {
            lhs.hour == rhs.hour && lhs.minute == rhs.minute && lhs.second == rhs.second && lhs.millisecond == rhs.millisecond
            }
            
        public static let nullTime = Time(hour: 0,minute: 0,second: 0,millisecond: 0)
        
        public let hour: Int
        public let minute: Int
        public let second: Int
        public let millisecond: Int
        
        public init(matchString: String)
            {
            let pieces = matchString.components(separatedBy: CharacterSet.decimalDigits.inverted).filter{!$0.isEmpty}
            self.hour = Int(pieces[0])!
            self.minute = Int(pieces[1])!
            self.second = Int(pieces[2])!
            self.millisecond = pieces.count == 4 ? Int(pieces[3])! : 0
            }
            
        public init(hour: Int,minute: Int,second: Int,millisecond: Int = 0)
            {
            self.hour = hour
            self.minute = minute
            self.second = second
            self.millisecond = millisecond
            }
            
        public func hash(into hasher:inout Hasher)
            {
            hasher.combine("TIME")
            hasher.combine(self.hour)
            hasher.combine(self.minute)
            hasher.combine(self.second)
            hasher.combine(self.millisecond)
            }
        }
        
    public struct DateTime: Hashable
        {
        public static func ==(lhs: DateTime,rhs: DateTime) -> Bool
            {
            lhs.date == rhs.date && lhs.time == rhs.time
            }
            
        public let date: Date
        public let time: Time
        
        public init(date: Argon.Date,time: Argon.Time)
            {
            self.date = date
            self.time = time
            }
            
        public func hash(into hasher:inout Hasher)
            {
            hasher.combine("DATE_TIME")
            hasher.combine(self.date)
            hasher.combine(self.time)
            }
        }
        
    public struct Tuple: Hashable
        {
        public func hash(into hasher:inout Hasher)
            {
            fatalError()
            }
            
        public static func ==(lhs: Tuple,rhs:Tuple) -> Bool
            {
            fatalError()
            }
            
        public var symbolType: ArgonType!
        
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
        case discreteType(ArgonType)
        case enumeration(EnumerationType)
        case subType(Subtype)
        case integer
        
//        public var _mangledName: String
//            {
//            switch(self)
//                {
//                case(.none):
//                    fatalError()
//                case(.discreteType(let node)):
//                    let encoding = ArgonModule.encoding(for: "IndexDiscreteType")!
//                    return("\(encoding)\(node.mangledName)")
//                case(.enumeration(let enumeration)):
//                    let encoding = ArgonModule.encoding(for: "IndexEnumeration")!
//                    return("\(encoding)\(enumeration.mangledName)")
//                case(.integer):
//                    let encoding = ArgonModule.encoding(for: "IndexInteger")!
//                    return(encoding + ArgonModule.encoding(for: "Integer")!)
//                case(.subType(let subType)):
//                    let encoding = ArgonModule.encoding(for: "IndexSubType")!
//                    return("\(encoding)\(subType.mangledName)")
//                    
//                }
//            }
        }
        
    public static func possiblePathsForImportedModule(named: String) -> Identifiers
        {
        var identifiers = Identifiers()
        identifiers.append(Identifier(string: NSHomeDirectory().replacingOccurrences(of: "/", with: "\\")))
        if let value = try? FileManager.default.url(for: .libraryDirectory, in: FileManager.SearchPathDomainMask(arrayLiteral: .localDomainMask,.userDomainMask), appropriateFor: nil, create: false)
            {
            identifiers.append(Identifier(string: value.absoluteString.replacingOccurrences(of: "/", with: "\\")))
            }
        if let value = try? FileManager.default.url(for: .desktopDirectory, in: FileManager.SearchPathDomainMask(arrayLiteral: .localDomainMask,.userDomainMask), appropriateFor: nil, create: false)
            {
            identifiers.append(Identifier(string: value.absoluteString.replacingOccurrences(of: "/", with: "\\")))
            }
        if let url = try? FileManager.default.url(for: .applicationSupportDirectory, in: FileManager.SearchPathDomainMask(arrayLiteral: .localDomainMask,.userDomainMask), appropriateFor: nil, create: false)
            {
            var value = url.absoluteString
            value.append("/Argon/")
            identifiers.append(Identifier(string: value.replacingOccurrences(of: "/", with: "\\")))
            }
        if let url = try? FileManager.default.url(for: .documentDirectory, in: FileManager.SearchPathDomainMask(arrayLiteral: .localDomainMask,.userDomainMask), appropriateFor: nil, create: false)
            {
            var value = url.absoluteString
            value.append("/Argon/")
            identifiers.append(Identifier(string: value.replacingOccurrences(of: "/", with: "\\")))
            }
        return(identifiers)
        }
    }

public typealias Atoms = Array<Argon.Atom>

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
                return(.discreteType(self.decodeObject(forKey: key + "discreteType") as! ArgonType))
            case(2):
                return(.enumeration(self.decodeObject(forKey: key + "enumeration") as! EnumerationType))
            case(3):
                let type = self.decodeObject(forKey: key + "subType") as! Subtype
                return(.subType(type))
            case(4):
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
            case(.subType(let type)):
                self.encode(3,forKey: key + "_index")
                self.encode(type,forKey: key + "subType")
            case(.integer):
                self.encode(4,forKey: key + "_index")
            }
        }
    }

extension NSCoder
    {
    public func encode(_ tuple: Argon.Tuple,forKey key: String)
        {
        fatalError()
        }
        
    public func decodeTuple(forKey key: String) -> Argon.Tuple
        {
        fatalError()
        }
    }
