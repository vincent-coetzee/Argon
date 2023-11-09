//
//  Macro.swift
//  Argon
//
//  Created by Vincent Coetzee on 31/05/2023.
//

import Foundation

public class MacroParameter:NSObject,NSCoding
    {
    public let name: String
    
    init(name: String)
        {
        self.name = name
        }
        
    public required init(coder: NSCoder)
        {
        self.name = coder.decodeObject(forKey: "name") as! String
        }
        
    public func encode(with coder: NSCoder)
        {
        coder.encode(self.name,forKey: "name")
        }
    }
    
public class Macro: Symbol
    {
    public private(set) var parameters = Array<MacroParameter>()
    public let text: String
    
    init(name: String,parameterNames: Array<String>,text: String)
        {
        self.text = text
        super.init(name: name)
        let namedParameters = parameterNames.map{"`\($0)"}
        var index = text.startIndex
        let endIndex = text.endIndex
        for name in namedParameters
            {
            var range: Range<String.Index>? = nil
            var offsets = Array<String.Index>()
            repeat
                {
                range = text.range(of: name,range: Range(uncheckedBounds: (index,endIndex)))
                if range.isNotNil
                    {
                    offsets.append(range!.lowerBound)
                    index = range!.lowerBound
                    text.formIndex(&index,offsetBy: name.count)
                    }
                }
            while range.isNotNil
            self.parameters.append(MacroParameter(name: String(name.dropFirst())))
            }
        }
        
    required init(coder: NSCoder)
        {
        self.text = coder.decodeObject(forKey: "text") as! String
        super.init(coder: coder)
        }
    }
