//
//  Location.swift
//  Argon
//
//  Created by Vincent Coetzee on 2022/11/22.
//

import Foundation

public struct Location
    {
    public static var zero = Location(nodeKey: 0,line: 0)
        
    public var range: NSRange
        {
        NSRange(location: self.start,length: self.stop - self.start)
        }
        
    public var nodeKey: Int
    public let line: Int
    public let start: Int
    public let stop: Int
    
    init(nodeKey: Int,line: Int)
        {
        self.nodeKey = nodeKey
        self.line = line
        self.start = 0
        self.stop = 0
        }
        
    public init(nodeKey: Int,line: Int,start: Int,stop: Int)
        {
        self.nodeKey = nodeKey
        self.line = line
        self.start = start
        self.stop = stop
        }
    }

public extension NSCoder
    {
    func encode(_ location: Location,forKey key: String)
        {
        self.encode(location.nodeKey,forKey: key + "nodeKey")
        self.encode(location.line,forKey: key + "line")
        self.encode(location.start,forKey: key + "start")
        self.encode(location.stop,forKey: key + "stop")
        }
        
    func decodeLocation(forKey key: String) -> Location
        {
        let nodeKey = self.decodeInteger(forKey: key + "nodeKey")
        let line = self.decodeInteger(forKey: key + "line")
        let start = self.decodeInteger(forKey: key + "start")
        let stop = self.decodeInteger(forKey: key + "stop")
        return(Location(nodeKey: nodeKey, line: line, start: start, stop: stop))
        }
    }
