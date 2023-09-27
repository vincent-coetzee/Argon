//
//  TypeParameter.swift
//  Argon
//
//  Created by Vincent Coetzee on 26/09/2023.
//

import Foundation

//
//
// A TypeParameter is an ArgonType that is used when declaring a generic type in Argon. The
// class, tuple or enumeration being declared creates a TypeParameter for each of the "hollow"
// placeholder values in the class, tuple or enumeration declaration. In class declarations
// TypeParameters appear between brockets ( < and > )to the left of the scope ( :: ) operator
// in the class/tuple/enumeration declaration. For example
//
//
// CLASS NewClass<X,Y,Z> :: OlderClass1<A,B>, OldClass2<C,D>
//      {
//      SLOT someSlot :: X
//      SLOT secondSlot :: A
//      SLOT thirdSlot :: D
//      }
//
// In this example X,Y,Z are TypeParameters and will be "grounded" when NewClass is used
// either directly as a type or as the superclass of another class. A and B, as well as C and D
// are all ordinary or concrete types. When a generic class like NewClass is instanciated or used
// it is necessary for the TypeParameters to be instanciated in which case they are given a
// concrete type in their typeValue ( i.e. symbolType ) instance variable.
//
//
//
public class TypeParameter: ArgonType
    {
    public var valueName: String
        {
        self.scope!.name + "+" + self.name + "+VALUE"
        }
        
    public override var symbolType: ArgonType
        {
        get
            {
            self.scope!.lookupSymbol(atName: self.valueName) as! ArgonType
            }
        set
            {
            }
        }
        
    public weak var scope: Scope?
    
    public required init(coder: NSCoder)
        {
        self.scope = coder.decodeObject(forKey: "scope") as? Symbol
        super.init(coder: coder)
        }
        
    public init(name: String,scope: Scope)
        {
        self.scope = scope
        super.init(name: name)
        }
        
    public override func encode(with coder: NSCoder)
        {
        coder.encode(self.scope as! Symbol,forKey: "scope")
        super.encode(with: coder)
        }
        
    public override func clone() -> Self
        {
        TypeParameter(name: self.name,scope: self.scope!) as! Self
        }
    }

public typealias TypeParameters = Array<TypeParameter>
