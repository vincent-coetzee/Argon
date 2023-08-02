//
//  RawType.swift
//  Argon
//
//  Created by Vincent Coetzee on 05/07/2023.
//

import Foundation

public enum RawType: Int
    {
    case void
    case string
    case symbol
    case integer8
    case integer16
    case integer32
    case integer64
    case uInteger8
    case uInteger16
    case uInteger32
    case uInteger64
    case float16
    case float32
    case float64
    case boolean
    case character
    case byte
    case date
    case time
    case dateTime
    }

public extension NSCoder
    {
    func encode(_ rawType: RawType,forKey key: String)
        {
        self.encode(rawType.rawValue,forKey: "\(key)_index")
        }
        
    func decodeRawType(forKey key: String) -> RawType
        {
        RawType(rawValue: self.decodeInteger(forKey: "\(key)_index"))!
        }
    }
