//
//  LocationReference.swift
//  Argon
//
//  Created by Vincent Coetzee on 30/07/2023.
//

import Foundation

//
//
// A NodeReference stores where a SyntaxTreeNode is either declared
// or referenced by some piece of code. A node should only have one
// declaration reference but can have multiple reference references.
// These locations are used when generating lookups in the source
// code editors and when debugging executeable code - I have not
// yet code the code generation ( i.e. LLVM ) portions of the code
// yet so I assumed there is some way that LLVM and ELF will allow
// me to encode these values into the generated object code, but time
// witl tell.
//
//
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
            index += 1
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
