//
//  EncodedPiece.swift
//  Argon
//
//  Created by Vincent Coetzee on 12/09/2023.
//

import Foundation

public struct NameMangler
    {
//    private static func encoding(`for` key: String) -> String?
//        {
//        self.encodingTable[key]
//        }
//        
//    private static let encodingTable: Dictionary<String,String> =
//        {
//        var table = Dictionary<String,String>()
//        //
//        // T_ marks the first type parameter to a method/function
//        // T0 marks the second type parameter to a method/function
//        // T1 marks the third etc
//        //
//        table["METHOD"] = "~"
//        table["FUNCTION"] = "|"
//        table["GLOBAL"] = ";"
//        table["GENERIC"] = ":"
//        table["RAW"] = "__z"
//        table["ENCODED"] = "__Z"
//        table["Argon"] = "A"
//        table["Root"] = "B"
//        table["Array"] = "C"
//        table["BitSet"] = "D"
//        table["Buffer"] = "E"
//        table["Byte"] = "F"
//        table["Boolean"] = "G"
//        table["Character"] = "H"
//        table["Class"] = "I"
//        table["Collection"] = "J"
//        table["Date"] = "K"
//        table["DateTime"] = "L"
//        table["Dictionary"] = "M"
//        table["Enumeration"] = "N"
//        table["EnumerationBase"] = "O"
//        table["EnumerationCase"] = "P"
//        table["File"] = "Q"
//        table["FixedPointNumber"] = "R"
//        table["Float"] = "S"
//        table["Float16"] = "T"
//        table["Float32"] = "U"
//        table["Float64"] = "V"
//        table["Function"] = "W"
//        table["Integer"] = "X"
//        table["Integer8"] = "Y"
//        table["Integer16"] = "s"
//        table["Integer32"] = "b"
//        table["Integer64"] = "c"
//        table["List"] = "d"
//        table["Method"] = "e"
//        table["Month"] = "f"
//        table["Object"] = "g"
//        table["Pointer"] = "h"
//        table["Set"] = "i"
//        table["Stream"] = "j"
//        table["String"] = "k"
//        table["Symbol"] = "l"
//        table["Time"]  = "m"
//        table["UInteger"] = "n"
//        table["UInteger8"] = "o"
//        table["UInteger16"] = "p"
//        table["UInteger32"] = "q"
//        table["UInteger64"] = "r"
//        table["Void"] = "s"
//        table["IndexDiscreteTtype"] = "t"
//        table["IndexInteger"] = "u"
//        table["IndexEnumeration"] = "v"
//        table["IndexSubType"] = "w"
//        return(table)
//        }()
//        
//    private var buffer = String()
//    
//    public mutating func mangle(name: String)
//        {
//        if let encoding = Self.encoding(for: name)
//            {
//            self.append(encoding)
//            return
//            }
//        if self.buffer.last.isNil ? false : self.buffer.last!.isWholeNumber
//            {
//            self.append(".")
//            }
//        self.append(name.count)
//        self.append(name)
//        }
//        
//    public mutating func mangle(type node: TypeNode)
//        {
//        if node.isArrayType
//            {
//            let encoding = Self.encoding(for: "Array")
//            self.append("_")
//            self.mangle(name: "Array")
//            }
//        if node.isGenericType
//            {
//            self.append("_")
//            self.mangle(name: node.name)
//            self.append(node.genericTypes.count)
//            for aType in node.genericTypes
//                {
//                self.mangle(type: aType)
//                }
//            }
//        else
//            {
//            self.mangle(name: node.name)
//            }
//        }
//        
////    public mutating func mangle(encoding: String,after: Manglable)
////        {
////        self.append(encoding)
////        }
//        
//    public mutating func mangle(method: MethodType)
//        {
//        self.append(Self.encoding(for: "ENCODED"))
//        self.append(Self.encoding(for: "METHOD"))
//        self.append(method.parameters.count + 1)
//        for parameters in method.parameters
//            {
//            self.append(parameter.name
//            }
//        }
//        
//    func mangle(function: FunctionType)
//    func mangle(global: Variable)
//    
//    private mutating func append(_ integer: Int)
//        {
//        self.buffer.append("\(integer)")
//        }
//        
//    private mutating func append(_ string: String)
//        {
//        self.buffer.append(string)
//        }
    }
