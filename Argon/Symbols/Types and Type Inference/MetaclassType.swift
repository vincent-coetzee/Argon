//
//  Metaclass.swift
//  Argon
//
//  Created by Vincent Coetzee on 07/08/2023.
//

import Foundation

public class MetaclassType: ClassType
    {
    private let forClass: ClassType
    
    public override var hash: Int
        {
        var hasher = Hasher()
        hasher.combine("METACLASS")
        hasher.combine(self.identifier)
        return(hasher.finalize())
        }
        
    public init(forClass: ClassType)
        {
        self.forClass = forClass
        super.init(name: forClass.name + " class")
        }
        
    public required init(coder: NSCoder)
        {
        self.forClass = coder.decodeObject(forKey: "forClass") as! ClassType
        super.init(coder: coder)
        }
        
    public required init(name: String,genericTypes: ArgonTypes)
        {
        fatalError("This should not be called on Metaclass")
        }
        
    public override func encode(with coder: NSCoder)
        {
        coder.encode(self.forClass,forKey: "forClass")
        super.encode(with: coder)
        }
    }

