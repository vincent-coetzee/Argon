//
//  InvocationType.swift
//  Argon
//
//  Created by Vincent Coetzee on 16/07/2023.
//

import Foundation

public class InvocationType: StructuredType
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
