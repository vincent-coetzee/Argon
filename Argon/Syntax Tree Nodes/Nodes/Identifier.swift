//
//  Identifier.swift
//  Argon
//
//  Created by Vincent Coetzee on 14/01/2023.
//

import Foundation


        
public class Identifier: NSObject,NSCoding
    {
    public static func ==(lhs: Identifier,rhs: Identifier) -> Bool
        {
        if lhs.parts.count != rhs.parts.count
            {
            return(false)
            }
        for (left,right) in zip(lhs.parts,rhs.parts)
            {
            if left != right
                {
                return(false)
                }
            }
        return(true)
        }
        
    public static func isEqual(lhs: Identifier,rhs: Identifier) -> Bool
        {
        if lhs.parts.count != rhs.parts.count
            {
            return(false)
            }
        for (left,right) in zip(lhs.parts,rhs.parts)
            {
            if left != right
                {
                return(false)
                }
            }
        return(true)
        }
        
    public var car: String?
        {
        if self.parts.count > 0
            {
            return(self.parts.first!.stringPart)
            }
        return(nil)
        }
        
    public var cdr: Identifier
        {
        if self.parts.count > 0
            {
            return(Identifier(parts: Array(self.parts.dropFirst(1))))
            }
        return(Identifier())
        }
        
    public override var hash: Int
        {
        var hashValue = 0
        for part in self.parts
            {
            hashValue = hashValue << 13 ^ part.hash
            }
        return(hashValue)
        }
        
    public static let empty = Identifier(parts: [])
    
    internal enum IdentifierPart: Equatable
        {
        case root
        case part(String)
        
        public static func ==(_ part1:IdentifierPart,_ part2:IdentifierPart) -> Bool
            {
            switch(part1,part2)
                {
                case (.root,.root):
                    return(true)
                case (.part(let string1),.part(let string2)):
                    return(string1 == string2)
                default:
                    return(false)
                }
            }
            
        internal var stringPart: String
            {
            switch(self)
                {
                case(.root):
                    return("/")
                case(.part(let piece)):
                    return(piece)
                }
            }
            
        internal var isRoot: Bool
            {
            switch(self)
                {
                case(.root):
                    return(true)
                default:
                    return(false)
                }
            }
            
        public var hash: Int
            {
            switch(self)
                {
                case(.root):
                    return(0)
                case(.part(let string)):
                    return(string.polynomialRollingHash)
                }
            }
        }
    
    public static func +(lhs: Identifier,rhs: String) -> Identifier
        {
        Identifier(parts: lhs.parts.appending(IdentifierPart.part(rhs)))
        }
        
    public override var description: String
        {
        self.parts.map{$0.stringPart}.joined(separator: "/")
        }
     
    public var firstPart: String
        {
        if self.parts.isEmpty
            {
            fatalError("There is no first in this identifier")
            }
        if self.parts.first!.isRoot
            {
            return("//")
            }
        return(self.parts.first!.stringPart)
        }
        
    public var isRooted: Bool
        {
        return(self.parts.count > 0 && self.parts[0].isRoot)
        }
        
    public var isEmpty: Bool
        {
        return(self.parts.isEmpty)
        }
        
    public var count: Int
        {
        return(self.parts.count)
        }
        
    public var lastPart: String
        {
        if self.count < 1
            {
            fatalError("Attempt to use lastPart of empty identifier.")
            }
        return(self.parts.last!.stringPart)
        }
        
    public var remainingPart: Identifier
        {
        if self.isEmpty || self.count == 1
            {
            return(Identifier())
            }
        return(Identifier(parts: Array(self.parts.dropFirst(1))))
        }
        
    private var parts: Array<IdentifierPart> = []
    
    public var isCompoundIdentifier: Bool
        {
        self.parts.count > 1
        }
        
    public var isSingleIdentifier: Bool
        {
        self.parts.count == 1
        }
        
    internal init(parts: Array<IdentifierPart>)
        {
        self.parts = parts
        }
        
    private override init()
        {
        self .parts = []
        super.init()
        }
        
    public init(string: String)
        {
        if string.isEmpty
            {
            self.parts = []
            }
        else
            {
            var pieces = string.components(separatedBy: "/")
            if pieces.count > 0
                {
                if pieces[0] == ""
                    {
                    pieces.remove(at: 0)
                    }
                }
            self.parts = pieces.map{$0 == "" ? IdentifierPart.root : IdentifierPart.part($0)}
            }
        }
        
    required public init(coder: NSCoder)
        {
        let count = coder.decodeInteger(forKey: "count")
        var someParts = Array<IdentifierPart>()
        for index in 0..<count
            {
            let type = coder.decodeInteger(forKey: "part_\(index)")
            if type == 0
                {
                someParts.append(.root)
                }
            else
                {
                let string = coder.decodeObject(forKey: "part_\(index)_string") as! String
                someParts.append(.part(string))
                }
            }
        self.parts = someParts
        }
        
    public func encode(with coder: NSCoder)
        {
        coder.encode(self.parts.count,forKey: "count")
        var index = 0
        for part in self.parts
            {
            switch(part)
                {
                case(.root):
                    coder.encode(0,forKey: "part_\(index)")
                case(.part(let string)):
                    coder.encode(1,forKey: "part_\(index)")
                    coder.encode(string,forKey: "part_\(index)_string")
                }
            index += 1
            }
        }
        
    public override func isEqual(_ object: Any?)-> Bool
        {
        if object.isNil
            {
            return(false)
            }
        if let identifier = object as? Identifier
            {
            return(self.parts == identifier.parts)
            }
        return(false)
        }
    }

extension String.StringInterpolation
    {
    public mutating func appendInterpolation(_ identifier: Identifier)
        {
        self.appendInterpolation("Parts(\(identifier.description))")
        }
    }
