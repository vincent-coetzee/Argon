//
//  ContainerSymbol.swift
//  CobaltX
//
//  Created by Vincent Coetzee on 2020/02/26.
//  Copyright © 2020 Vincent Coetzee. All rights reserved.
//

import Foundation

public class SymbolContainer:Symbol
    {
    public override var isScope:Bool
        {
        return(true)
        }
        
    internal var symbols:[String:SymbolSet] = [:]

    public override var elementals:Elementals
        {
        if self._elementals != nil
            {
            return(self._elementals!)
            }
        var values = Array<Symbol>()
        for set in self.symbols.values
            {
            values.append(contentsOf:set.symbols)
            }
        let someSymbols = Array<Symbol>(Set<Symbol>(values)).sorted{$0.shortName<$1.shortName}
        var newList = Array<Symbol>()
        for symbol in someSymbols
            {
            if !newList.contains(where:{$0.shortName == symbol.shortName})
                {
                newList.append(symbol)
                }
            }
        self._elementals = newList.map{ElementalSymbol(symbol:$0)}
        return(self._elementals!)
        }
        
    public init(shortName:String)
        {
        super.init(shortName:shortName)
        }

        
    public required init?(coder:NSCoder)
        {
        fatalError("init(coder:) has not been implemented")
        }
        
    internal override func relinkSymbolsUsingIds(symbols:Dictionary<UUID,Symbol>)
        {
        super.relinkSymbolsUsingIds(symbols:symbols)
        for set in self.symbols.values
            {
            for symbol in set.symbols
                {
                symbol.relinkSymbolsUsingIds(symbols:symbols)
                }
            }
        }
        
    internal override func symbolsKeyedById() -> Dictionary<UUID,Symbol>
        {
        var this = Dictionary<UUID,Symbol>()
        for set in self.symbols.values
            {
            for symbol in set.symbols
                {
                let inside = symbol.symbolsKeyedById()
                let closure = {(s1:Symbol,s2:Symbol) in return(s1)}
                this.merge(inside, uniquingKeysWith: closure)
                }
            }
        return(this)
        }

    internal override func addSymbol(_ symbol:Symbol)
        {
        self._elementals = nil
        if symbol.isModuleLevelSymbol && !(self is Module)
            {
            fatalError("This should not be called")
            }
        if let set = self.symbols[symbol.shortName]
            {
            set.append(symbol)
            }
        else
            {
            self.symbols[symbol.shortName] = SymbolSet(symbol)
            }
        symbol.parent = self
        }
        
    internal override func lookup(shortName:String) -> SymbolSet?
        {
        if shortName == self.shortName
            {
            return(SymbolSet(self))
            }
        if let set = self.symbols[shortName]
            {
            return(set)
            }
        return(self.parentScope?.lookup(shortName: shortName))
        }
    }
