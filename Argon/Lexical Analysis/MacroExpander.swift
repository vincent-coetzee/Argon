//
//  MacroExpander.swift
//  Argon
//
//  Created by Vincent Coetzee on 30/05/2023.
//

import Foundation

public class MacroExpander
    {
    private var macros = Dictionary<String,Macro>()
    
    public func expandMacros(in someSource: String) -> String
        {
        var source = someSource
        var range = source.range(of: "$")
        while range.isNotNil
            {
            if var midIndex = source.firstIndex(of: "(",after: range!.upperBound)
                {
                let name = String(source[range!.upperBound...source.index(before: midIndex)])
                if var endIndex = source.firstIndex(of: ")",after: midIndex)
                    {
                    midIndex = source.index(after: midIndex)
                    endIndex = source.index(before: endIndex)
                    let string = source[midIndex...endIndex]
                    let values = string.split(whereSeparator: {$0==","})
                    if let macro = self.macros[name],values.count == macro.parameters.count
                        {
                        var text = macro.text as NSString
                        var index = 0
                        for value in values
                            {
                            let key = "`\(macro.parameters[index].name)"
                            text = text.replacingOccurrences(of: key, with: String(value)) as NSString
                            index = index + 1
                            }
                        var updatedString = source as NSString
                        updatedString = updatedString.replacingOccurrences(of: "$\(name)\(string)",with: text as String) as NSString
                        source = updatedString as String
                        }
                    }
                }
            range = source.range(of: "$")
            }
        return(source)
        }
                
    public func extractMacros(from someSource: String)
        {
        var source = someSource
        var range = source.range(of: "MACRO")
        while range.isNotNil
            {
            let starterIndex = range!.lowerBound
            var finalIndex = starterIndex
            var endIndex = source.index(after: range!.upperBound)
            while source[endIndex].isWhitespace && endIndex < source.endIndex
                {
                endIndex = source.index(after: endIndex)
                }
            if source.firstIndex(of: "(",after: endIndex).isNotNil,let name = source.substring(upTo: "(",after: endIndex)
                {
                if var parenthesisIndex = source.firstIndex(of: "(",after: endIndex),var rightIndex = source.firstIndex(of: ")",after: parenthesisIndex)
                    {
                    let string = source[parenthesisIndex...rightIndex]
                    if string[parenthesisIndex] == "("
                        {
                        parenthesisIndex = source.index(after: parenthesisIndex)
                        }
                    if source[rightIndex] == ")"
                        {
                        rightIndex = source.index(before: rightIndex)
                        }
                    let arguments = source[parenthesisIndex...rightIndex].split(whereSeparator: {$0 == ","}).map{String($0)}
                    if var firstIndex = source.firstIndex(of: "$",after: rightIndex)
                        {
                        if source[firstIndex] == "$"
                            {
                            firstIndex = source.index(after: firstIndex)
                            }
                        if var lastIndex = source.firstIndex(of: "$",after: firstIndex)
                            {
                            finalIndex = lastIndex
                            if source[lastIndex] == "$"
                                {
                                lastIndex = source.index(before: lastIndex)
                                finalIndex = source.index(after: finalIndex)
                                }
                            let text = String(source[firstIndex...lastIndex])
                            self.macros[String(name)] = Macro(name: String(name), parameterNames: arguments, text: text)
                            }
                        }
                    }
                }
            source.removeSubrange(Range(uncheckedBounds: (lower: starterIndex,upper: finalIndex)))
            range = source.range(of: "MACRO")
            }
        }
    }


