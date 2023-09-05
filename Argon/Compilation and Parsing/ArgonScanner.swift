//
//  ArgonTokenStream.swift
//  Argon
//
//  Created by Vincent Coetzee on 25/08/2023.
//

import Foundation

public class ArgonScanner
    {
    public var atEnd: Bool
        {
        self.offset >= self.sourceCharacterCount
        }

    private let source:String
    private var offset = 0
    private var startOffset = 0
    private var sourceCharacterCount: Int
    private var sourceIndex: String.Index
    private var sourceLine: Int = 1
    private let operatorCharacters = CharacterSet(charactersIn: "!$%^&*-+=:;\\\\|<>?/.,~@")
    private let brackets = CharacterSet(charactersIn: "()[]{}")
    private let identifierStartCharacters = CharacterSet.letters.union(CharacterSet(charactersIn: "\\"))
    private let identifierCharacters = CharacterSet.letters.union(CharacterSet.decimalDigits).union(CharacterSet(charactersIn: "_!?\\"))
    private let symbolCharacters = CharacterSet.letters.union(.decimalDigits).union(CharacterSet(charactersIn: "-_"))
    private let pathCharacters = CharacterSet.letters.union(.decimalDigits).union(CharacterSet(charactersIn: "-_/~"))
    public var currentCharacter = Unicode.Scalar(0)!

    public init(source: String)
        {
        self.source = source
        self.sourceIndex = self.source.startIndex
        self.sourceCharacterCount = self.source.count
        self.nextCharacter()
        }

    public func sourcePrefix(length: Int) -> String
        {
        let beginIndex = self.source.index(before: self.sourceIndex)
        let endIndex = self.source.index(beginIndex,offsetBy: length)
        return(String(self.source[beginIndex..<endIndex]))
        }

    @discardableResult
    public func nextDirtyCharacter() -> Unicode.Scalar
        {
        if self.offset >= self.sourceCharacterCount
            {
            return(self.currentCharacter)
            }
        self.currentCharacter = self.source.unicodeScalars[self.sourceIndex]
        self.offset += 1
        self.sourceIndex = self.source.index(after: self.sourceIndex)
        if self.currentCharacter == "\n"
            {
            self.sourceLine += 1
            }
        return(self.currentCharacter)
        }
        
    @discardableResult
    public func nextCharacter() -> Unicode.Scalar
        {
        if self.offset >= self.sourceCharacterCount
            {
            return(self.currentCharacter)
            }
        self.currentCharacter = self.source.unicodeScalars[self.sourceIndex]
        self.offset += 1
        self.sourceIndex = self.source.index(after: self.sourceIndex)
        if self.currentCharacter == "\n"
            {
            self.sourceLine += 1
            return(self.nextCharacter())
            }
        return(self.currentCharacter)
        }

    public func scanUntilEndOfLine() -> String
        {
        self.nextDirtyCharacter()
        var string = String()
        while self.currentCharacter != "\n" && !self.atEnd
            {
            string += String(self.currentCharacter)
            self.nextDirtyCharacter()
            }
        if self.currentCharacter == "\n"
            {
            self.nextCharacter()
            }
        return(string)
        }
        
    public func scanUntilEndOfMultilineComment() -> String
        {
        self.nextDirtyCharacter()
        self.nextDirtyCharacter()
        var string = String("/*")
        while self.sourcePrefix(length: 2) != "*/" && !self.atEnd
            {
            string += String(self.currentCharacter)
            self.nextDirtyCharacter()
            }
        string.append("*/")
        return(string)
        }
        
    public func allTokens() -> Tokens
        {
        var tokens = Tokens()
        while !self.atEnd
            {
            tokens.append(self.scanToken())
            }
        return(tokens)
        }
        
    private func scanToken() -> Token
        {
        if self.atEnd
            {
            return(EndToken(location: Location(nodeKey: 0, line: self.sourceLine, start: self.startOffset, stop: self.offset),string: ""))
            }
        self.startOffset = offset - 1
        if CharacterSet.whitespaces.contains(self.currentCharacter)
            {
            self.scanWhitespace()
            return(self.scanToken())
            }
        let prefix = self.sourcePrefix(length: 2)
        if prefix == "/*" || prefix == "//"
            {
            return(self.scanComment())
            }
        else if prefix == "@("
            {
            return(self.scanDateOrTime())
            }
        else if self.brackets.contains(self.currentCharacter)
            {
            return(self.scanBracket())
            }
        else if CharacterSet.decimalDigits.contains(self.currentCharacter)
            {
            return(self.scanNumber())
            }
        else if self.currentCharacter == Unicode.Scalar("\"")
            {
            return(self.scanString())
            }
        else if self.currentCharacter == Unicode.Scalar("#")
            {
            return(self.scanSymbol())
            }
        else if self.operatorCharacters.contains(self.currentCharacter)
            {
            return(self.scanOperator())
            }
        else if self.identifierStartCharacters.contains(self.currentCharacter)
            {
            return(self.scanIdentifier())
            }
        else if self.currentCharacter == "/"
            {
            return(self.scanPath())
            }
        let character = self.currentCharacter
        self.nextCharacter()
        return(ErrorToken(location: Location(nodeKey: 0, line: self.sourceLine, start: self.startOffset, stop: self.offset),string: "Unknown character '\(character)'"))
        }
        
    private func scanDateOrTime() -> Token
        {
        self.nextCharacter()
        self.nextCharacter()
        var string = String()
        while self.currentCharacter != ")" && !self.atEnd
            {
            string.append(self.currentCharacter)
            self.nextCharacter()
            }
        if self.currentCharacter == ")"
            {
            self.nextCharacter()
            }
        return(CalendricalToken(location: Location(nodeKey: 0, line: self.sourceLine, start: self.startOffset, stop: self.offset),string: string))
        }
        
    private func scanBracket() -> Token
        {
        let character = self.currentCharacter
        self.nextCharacter()
        return(OperatorToken(location: Location(nodeKey: 0, line: self.sourceLine, start: self.startOffset, stop: self.offset), string: String(character)))
        }
        
    private func scanPath() -> Token
        {
        var string = String(self.currentCharacter)
        self.nextCharacter()
        while self.pathCharacters.contains(self.currentCharacter) && !self.atEnd
            {
            string.append(self.currentCharacter)
            self.nextCharacter()
            }
        return(PathToken(location: Location(nodeKey: 0, line: self.sourceLine, start: self.startOffset, stop: self.offset),string: string))
        }
        
    private func scanIdentifier() -> Token
        {
        var identifier = String()
        while self.identifierCharacters.contains(self.currentCharacter) && !self.atEnd
            {
            identifier.append(String(self.currentCharacter))
            self.nextCharacter()
            }
        let location = Location(nodeKey: 0, line: self.sourceLine, start: self.startOffset, stop: self.offset)
        if KeywordToken.isKeyword(identifier)
            {
            return(KeywordToken(location: location,string: identifier))
            }
        return(IdentifierToken(location: location, string: identifier))
        }
        
    private func scanOperator() -> Token
        {
        var string = String()
        while self.operatorCharacters.contains(self.currentCharacter) && !self.atEnd
            {
            string.append(self.currentCharacter)
            self.nextCharacter()
            }
        return(OperatorToken(location: Location(nodeKey: 0, line: self.sourceLine, start: self.startOffset, stop: self.offset),string: string))
        }
        
    private func scanSymbol() -> Token
        {
        self.nextCharacter()
        var string = "#"
        while self.symbolCharacters.contains(self.currentCharacter) && !self.atEnd
            {
            string.append(self.currentCharacter)
            self.nextCharacter()
            }
        return(SymbolToken(location: Location(nodeKey: 0, line: self.sourceLine, start: self.startOffset, stop: self.offset),string: string))
        }
        
    private func scanString() -> Token
        {
        self.nextCharacter()
        var string = ""
        while self.currentCharacter != Unicode.Scalar("\"") && !self.atEnd
            {
            string.append(self.currentCharacter)
            self.nextCharacter()
            }
        if self.currentCharacter == Unicode.Scalar("\"")
            {
            self.nextCharacter()
            }
        return(StringToken(location: Location(nodeKey: 0, line: self.sourceLine, start: self.startOffset, stop: self.offset),string: string))
        }
        
    private func scanNumber() -> Token
        {
        if self.currentCharacter == Unicode.Scalar("0")
            {
            self.nextCharacter()
            if self.currentCharacter == Unicode.Scalar("B")
                {
                self.nextCharacter()
                return(self.scanBinaryNumber())
                }
            else if self.currentCharacter == Unicode.Scalar("T")
                {
                self.nextCharacter()
                return(self.scanTernaryNumber())
                }
            else if self.currentCharacter == Unicode.Scalar("O")
                {
                self.nextCharacter()
                return(self.scanOctalNumber())
                }
            else if self.currentCharacter == Unicode.Scalar("X")
                {
                self.nextCharacter()
                return(self.scanHexadecimalNumber())
                }
            }
        return(self.scanDecimalNumber())
        }

    private func scanBinaryNumber() -> Token
        {
        fatalError()
        }
        
    private func scanTernaryNumber() -> Token
        {
        fatalError()
        }
        
    private func scanOctalNumber() -> Token
        {
        fatalError()
        }
        
    private func scanHexadecimalNumber() -> Token
        {
        fatalError()
        }
        
    private func scanDecimalNumber() -> Token
        {
        var string = String()
        while CharacterSet.decimalDigits.contains(self.currentCharacter) && !self.atEnd
            {
            string.append(String(self.currentCharacter))
            self.nextCharacter()
            }
        if self.sourcePrefix(length: 2) == ".."
            {
            return(IntegerToken(location: Location(nodeKey: 0, line: self.sourceLine, start: self.startOffset, stop: self.offset),string: string))
            }
        if self.currentCharacter == Unicode.Scalar(".")
            {
            string.append(".")
            self.nextCharacter()
            while CharacterSet.decimalDigits.contains(self.currentCharacter) && !self.atEnd
                {
                string.append(String(self.currentCharacter))
                self.nextCharacter()
                }
            return(FloatToken(location: Location(nodeKey: 0, line: self.sourceLine, start: self.startOffset, stop: self.offset),string: string))
            }
        return(IntegerToken(location: Location(nodeKey: 0, line: self.sourceLine, start: self.startOffset, stop: self.offset),string: string))
        }
        
    private func scanComment() -> Token
        {
        let prefix = self.sourcePrefix(length: 2)
        if prefix == String("/*")
            {
            return(self.scanMultilineComment())
            }
        return(self.scanSinglelineComment())
        }
        
    private func scanMultilineComment() -> Token
        {
        let string = self.scanUntilEndOfMultilineComment()
        return(CommentToken(location: Location(nodeKey: 0, line: self.sourceLine, start: self.startOffset, stop: self.offset),string: string))
        }
        
    private func scanSinglelineComment() -> Token
        {
        let string = self.scanUntilEndOfLine()
        return(CommentToken(location: Location(nodeKey: 0, line: self.sourceLine, start: self.startOffset, stop: self.offset),string: string))
        }
        
    private func scanWhitespace()
        {
        while CharacterSet.whitespaces.contains(self.currentCharacter) && !self.atEnd
            {
            self.nextCharacter()
            }
        }
    }
