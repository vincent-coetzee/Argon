//
//  Character+Extensions.swift
//  Argon
//
//  Created by Vincent Coetzee on 07/09/2023.
//

import Foundation

extension Unicode.Scalar
    {
    public var isEOF: Bool
        {
        self.value == 0
        }
        
    public var isNotEOF: Bool
        {
        self.value != 0
        }
        
    public var isNewLine: Bool
        {
        self == "\n"
        }
        
    public var isNotNewLine: Bool
        {
        self != "\n"
        }
    }
