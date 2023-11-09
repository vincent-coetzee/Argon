//
//  ImportedModuleType.swift
//  Argon
//
//  Created by Vincent Coetzee on 09/10/2023.
//

import Foundation

public class ImportedModuleType: ModuleType
    {
    internal var isResolved: Bool = false
    internal var modulePath: Identifier?
    
    public var isImportPathValid: Bool
        {
        guard self.modulePath.isNotNil else
            {
            let possiblePaths = Argon.possiblePathsForImportedModule(named: self.name)
            for path in possiblePaths
                {
                if self.isValid(path: path)
                    {
                    self.isResolved = true
                    self.modulePath = path
                    return(true)
                    }
                }
            return(false)
            }
        guard self.isValid(path: self.modulePath!) else
            {
            return(false)
            }
        self.isResolved = true
        return(true)
        }
        
    private func isValid(path: Identifier) -> Bool
        {
        var isDirectory:ObjCBool = false
        guard FileManager.default.fileExists(atPath: path.description, isDirectory: &isDirectory),isDirectory.boolValue else
            {
            return(true)
            }
        return(false)
        }
        
    public override class func parse(using parser: ArgonParser)
        {
        let location = parser.token.location
        parser.nextToken()
        guard let lastToken = parser.expect(tokenType: .identifier, error: .identifierExpected,location: location) else
            {
            return
            }
        let importedModule = ImportedModuleType(name: lastToken.identifier.lastPart)
        if parser.token.isLeftParenthesis
            {
            parser.parseParentheses
                {
                importedModule.modulePath = parser.parseIdentifier(errorCode: .modulePathExpected,message: "The path to module '\(importedModule.name)' was expected.")
                }
            }
        parser.currentScope.addSymbol(importedModule)
        if !importedModule.isImportPathValid
            {
            parser.lodgeError(code: .possiblePathForImportedModuleNotFound,message: "A possible path for imported module '\(importedModule.name)' can not be found.",location: location)
            }
        }
    }
