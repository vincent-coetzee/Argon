//
//  CustomTextStyleAttributes.swift
//  Argon
//
//  Created by Vincent Coetzee on 10/06/2023.
//

import Foundation

public enum CustomTextStyleAttributes
    {
    public enum Value: String,Codable
        {
        case symbol
        case string
        case separator
        case `operator`
        case keyword
        case integer
        case float
        case identifier
        case error
        case comment
        case character
        case byte
        }
        
    public static var name = "customTextStyle"
    }
