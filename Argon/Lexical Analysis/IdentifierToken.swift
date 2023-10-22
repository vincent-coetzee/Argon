//
//  Identifier.swift
//  Argon
//
//  Created by Vincent Coetzee on 2022/11/22.
//

import Foundation

public class IdentifierToken: Token
    {
    public static let systemTypeNames = ["Integer","UInteger","Integer64","UInteger64","Integer32","UInteger32","Integer16","UInteger16","Integer8","'UInteger8","Byte","Character","Boolean","Array","Set","List","BitVector","Dictionary","String","Atom"]
    
    public override var isExpressionRelatedToken: Bool
        {
        true
        }
        
    public override var isOperand: Bool
        {
        true
        }
        
    private let _identifier: Identifier
    
    public override var styleElement: StyleElement
        {
        if self._styleElement.isNotNil
            {
            return(self._styleElement!)
            }
        if ArgonModule.shared.isSystemClass(named: self.matchString)
            {
            return(.colorSystemClass)
            }
        if ArgonModule.shared.isSystemEnumeration(named: self.matchString)
            {
            return(.colorSystemEnumeration)
            }
        if ArgonModule.shared.isSystemAliasedType(named: self.matchString)
            {
            return(.colorSystemAliasedType)
            }
        return(.colorIdentifier)
        }
        
    public override func setStyleElement(_ element: StyleElement)
        {
        self._styleElement = element
        }
        
    public override var tokenType: TokenType
        {
        return(.identifier)
        }
        
    public override var tokenName: String
        {
        "IdentifierToken"
        }
        
    required init(location: Location,string: String)
        {
        self._identifier = Identifier(string: string)
        super.init(location: location,string: string)
        }
        
    required init(coder: NSCoder)
        {
        self._identifier = Identifier(coder: coder)
        super.init(coder: coder)
        }
        
    public override var isIdentifier: Bool
        {
        return(true)
        }
        
    public override var identifier: Identifier
        {
        return(self._identifier)
        }
        
    public override func encode(with coder: NSCoder)
        {
        self._identifier.encode(with: coder)
        super.encode(with: coder)
        }
    }


    

    

    

    

    

    

    

    

