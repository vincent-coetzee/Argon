//
//  String+Extensions.swift
//  Argon
//
//  Created by Vincent Coetzee on 30/05/2023.
//

import Foundation

extension String
    {
    public var symbolString: String
        {
        return(String(self.dropFirst(0)))
        }
        
    public var djb2Hash: Int
        {
        var hash = UInt64(5381)
        for character in self
            {
            hash = ((hash << 5) + hash) + UInt64(character.asciiValue!) 
            }
        return(Int(hash))
        }
        
    public var base64Hash: String
        {
        var value = self.polynomialRollingHash
        let data = Data(bytes: &value,count: MemoryLayout<Int>.size)
        return(data.base64EncodedString())
        }
        
    public var polynomialRollingHash:Int
        {
        let p:Int64 = 53   // Use 53 instead of 31 because strings contains uppercase and lowercase characters
        let m:Int64 = Int64(1e9) + 9
        var powerOfP:Int64 = 1
        var hashValue:Int64 = 0
        let aValue = Int64(Character("A").asciiValue!)
        for char in self
            {
            hashValue = (hashValue + (Int64(char.asciiValue!) - aValue + 1) * powerOfP) % m
            powerOfP = (powerOfP * p) % m
            }
        return(Int(hashValue))
        }
        
    public func firstIndex(of character: Character,after: Self.Index) -> Self.Index?
        {
        var index = after
        while index < self.endIndex
            {
            if self[index] == character
                {
                return(index)
                }
            index = self.index(after: index)
            }
        return(nil)
        }
        
    public mutating func append(_ scalar: Unicode.Scalar)
        {
        self.append(String(scalar))
        }
        
    public func firstIndex(of string: String,after: Self.Index) -> Self.Index?
        {
        let length = string.count
        var index = after
        while index < self.endIndex
            {
            if let endIndex = self.index(index,offsetBy: length,limitedBy: self.endIndex),self[index...endIndex] == string
                {
                return(index)
                }
            index = self.index(after: index)
            }
        return(nil)
        }
        
    public func substring(upTo character: Character,after: Self.Index) -> Self?
        {
        var index = after
        while index < self.endIndex && self[index] != character
            {
            index = self.index(after: index)
            }
        if self[index] != character
            {
            return(nil)
            }
        return(String(self[after..<index]))
        }
    }

public typealias Strings = Array<String>
