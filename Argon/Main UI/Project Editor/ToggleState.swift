//
//  ToggleState.swift
//  Argon
//
//  Created by Vincent Coetzee on 11/08/2023.
//

import Foundation

public enum ToggleState
    {
    case expanded
    case contracted(CGFloat)
    
    public var amount: CGFloat
        {
        switch(self)
            {
            case .contracted(let amount):
                return(amount)
            default:
                fatalError()
            }
        }
        
    public var isExpanded: Bool
        {
        switch(self)
            {
            case .expanded:
                return(true)
            default:
                return(false)
            }
        }
        
    public func toggledState(_ amount: CGFloat? = nil) -> Self
        {
        switch(self)
            {
            case .expanded:
                assert(amount.isNotNil)
                return(.contracted(amount!))
            case .contracted:
                return(.expanded)
            }
        }
    }
