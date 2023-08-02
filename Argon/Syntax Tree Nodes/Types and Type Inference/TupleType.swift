//
//  TupleType.swift
//  Argon
//
//  Created by Vincent Coetzee on 05/07/2023.
//

import Foundation

public class TupleType: StructuredType
    {
    public override var elementTypes: TypeNodes
        {
        get
            {
            self._elementTypes
            }
        set
            {
            self._elementTypes = newValue
            }
        }
        
    private var _elementTypes: TypeNodes = TypeNodes()
    }
