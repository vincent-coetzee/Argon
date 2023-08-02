//
//  Collection+Exensions.swift
//  Argon
//
//  Created by Vincent Coetzee on 08/07/2023.
//

import Foundation

extension Collection
    {
    public func detect(_ closure: (Element) -> Bool) -> Bool
        {
        for element in self
            {
            if closure(element)
                {
                return(true)
                }
            }
        return(false)
        }
    }
