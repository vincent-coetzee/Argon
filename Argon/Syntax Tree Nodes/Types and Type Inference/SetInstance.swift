//
//  SetInstance.swift
//  Argon
//
//  Created by Vincent Coetzee on 16/08/2023.
//

import Foundation

public class SetInstance: GenericTypeInstance
    {
    public override var isSystemNode: Bool
        {
        get
            {
            true
            }
        set
            {
            }
        }
        
    public override var encoding: String
        {
        return("W\(self.genericTypes[0].encoding)_")
        }
    }
