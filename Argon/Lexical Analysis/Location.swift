//
//  Location.swift
//  Argon
//
//  Created by Vincent Coetzee on 2022/11/22.
//

import Foundation

public struct Location
    {
    public static var zero = Location(sourceKey: 0,line: 0)
        
    public var range: NSRange
        {
        NSRange(location: self.start,length: self.stop - self.start)
        }
        
    public var sourceKey: Int
    public let line: Int
    public let start: Int
    public let stop: Int
    
    init(sourceKey: Int,line: Int)
        {
        self.sourceKey = sourceKey
        self.line = line
        self.start = 0
        self.stop = 0
        }
        
    public init(sourceKey: Int,line: Int,start: Int,stop: Int)
        {
        self.sourceKey = sourceKey
        self.line = line
        self.start = start
        self.stop = stop
        }
    }

public extension NSCoder
    {
    func encode(_ location: Location,forKey key: String)
        {
        self.encode(location.sourceKey,forKey: key + "sourceKey")
        self.encode(location.line,forKey: key + "line")
        self.encode(location.start,forKey: key + "start")
        self.encode(location.stop,forKey: key + "stop")
        }
        
    func decodeLocation(forKey key: String) -> Location
        {
        let sourceKey = self.decodeInteger(forKey: "sourceKey")
        let line = self.decodeInteger(forKey: "line")
        let start = self.decodeInteger(forKey: "start")
        let stop = self.decodeInteger(forKey: "stop")
        return(Location(sourceKey: sourceKey, line: line, start: start, stop: stop))
        }
    }
