//
//  SymbolTable.swift
//  Argon
//
//  Created by Vincent Coetzee on 11/01/2023.
//

import Foundation

public protocol Scope: AnyObject
    {
    var name: String { get }
    func addSymbol(_ symbol: Symbol)
    func lookupSymbol(atName: String) -> Symbol?
    func lookupSymbol(atIdentifier: Identifier) -> Symbol?
    func lookupMethod(atName: String) -> MultimethodType?
    func lookupMethod(atIdentifier: Identifier) -> MultimethodType?
    func lookupType(atName: String) -> ArgonType?
    func lookupType(atIdentifier: Identifier) -> ArgonType?
    }
    
public typealias SymbolDictionary = Dictionary<String,Symbol>
