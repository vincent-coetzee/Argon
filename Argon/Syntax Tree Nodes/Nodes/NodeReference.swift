//
//  LocationReference.swift
//  Argon
//
//  Created by Vincent Coetzee on 30/07/2023.
//

import Foundation

public enum NodeReference
    {
    case declaration(Location)
    case reference(Location)
    }

public typealias NodeReferences = Array<NodeReference>

extension NSCoder
    {
    public func encode(_ reference: NodeReference,forKey key: String)
        {
        switch(reference)
            {
            case(.declaration(let location)):
                self.encode(0,forKey: key + "index")
                self.encode(location.line,forKey: key + "line")
                self.encode(location.nodeKey,forKey: key + "sourceKey")
                self.encode(location.start,forKey: key + "start")
                self.encode(location.stop,forKey: key + "stop")
            case(.reference(let location)):
                self.encode(1,forKey: key + "index")
                self.encode(location.line,forKey: key + "line")
                self.encode(location.nodeKey,forKey: key + "sourceKey")
                self.encode(location.start,forKey: key + "start")
                self.encode(location.stop,forKey: key + "stop")
            }
        }
        
    public func decodeNodeReference(forKey key: String) -> NodeReference
        {
        let index = self.decodeInteger(forKey: key + "index")
        switch(index)
            {
            case(0):
                let line = self.decodeInteger(forKey: key + "line")
                let nodeKey = self.decodeInteger(forKey: key + "nodeKey")
                let start = self.decodeInteger(forKey: key + "start")
                let stop = self.decodeInteger(forKey: key + "stop")
                return(.declaration(Location(nodeKey: nodeKey, line: line, start: start, stop: stop)))
            case(1):
                let line = self.decodeInteger(forKey: key + "line")
                let nodeKey = self.decodeInteger(forKey: key + "nodeKey")
                let start = self.decodeInteger(forKey: key + "start")
                let stop = self.decodeInteger(forKey: key + "stop")
                return(.reference(Location(nodeKey: nodeKey, line: line, start: start, stop: stop)))
            default:
                fatalError("This should not happen.")
            }
        }
        
    public func encode(_ references: NodeReferences,forKey key: String)
        {
        self.encode(references.count,forKey: key + "count")
        var index = 0
        for reference in references
            {
            self.encode(reference,forKey: key + "\(index)")
            }
        }
        
    public func decodeNodeReferences(forKey key: String) -> NodeReferences
        {
        let count = self.decodeInteger(forKey: key + "count")
        var references = NodeReferences()
        for index in 0..<count
            {
            references.append(self.decodeNodeReference(forKey: key + "\(index)"))
            }
        return(references)
        }
    }
