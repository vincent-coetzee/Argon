//
//  ArgonTokenStream.swift
//  Argon
//
//  Created by Vincent Coetzee on 25/08/2023.
//

import Foundation

//public enum LexicalPattern
//    {
//    case startsWith(String)
//    case characterSet(CharacterSet)
//
//    public func matches(string: String) -> Bool
//        {
//        switch(self)
//            {
//            case .startsWith(let localString):
//                return(string == localString)
//            case .characterSet(let characters):
//                for scalar in string.unicodeScalars
//                    {
//                    if !characters.contains(scalar)
//                        {
//                        return(false)
//                        }
//                    }
//                return(true)
//            }
//        }
//    }
//
//public struct LexicalRule
//    {
//    public let pattern: LexicalPattern
//    public let function: () -> Token
//    }
//
//public protocol SubScanner
//    {
//    func matches(scanner: ArgonScanner) -> Bool
//    func scan(using scanner: ArgonScanner,location: Int) -> Token
//    }
//
//public struct IdentifierScanner: SubScanner
//    {
//    private static let characters = CharacterSet.letters.union(CharacterSet.decimalDigits).union(CharacterSet(charactersIn: "-_?!"))
//
//    public func matches(scanner: ArgonScanner) -> Bool
//        {
//        return(CharacterSet.letters.contains(scanner.nextCharacter(incrementIndex: false)))
//        }
//
//    public func scan(using scanner: ArgonScanner,location: Int) -> Token
//        {
//        var offset = location
//        let start = location
//        var string = String()
//        var character = scanner.currentCharacter
//        while Self.characters.contains(character) && !scanner.atEnd
//            {
//            string += String(character)
//            offset += 1
//            scanner.nextCharacter()
//            character = scanner.currentCharacter
//            }
//        let location = Location(nodeKey: 0, line: scanner.lineNumber, start: start, stop: offset)
//        guard KeywordToken.isKeyword(string) else
//            {
//            return(IdentifierToken(location: location, string: string))
//            }
//        return(KeywordToken(location: location,string: string))
//        }
//    }
//
//public struct OperatorScanner: SubScanner
//    {
//    private static let characters = CharacterSet(charactersIn: "!$%^&*()-+=:;{}[]\\\\|<>?/.,~@")
//
//    public func matches(scanner: ArgonScanner) -> Bool
//        {
//        return(Self.characters.contains(scanner.nextCharacter(incrementIndex: false)))
//        }
//
//    public func scan(using scanner: ArgonScanner,location: Int) -> Token
//        {
//        var offset = location
//        let start = location
//        var string = String()
//        var character = scanner.nextCharacter(incrementIndex: true)
//        repeat
//            {
//            string += String(character)
//            offset += 1
//            character = scanner.nextCharacter(incrementIndex: true)
//            }
//        while Self.characters.contains(character) && !scanner.atEnd
//        let location = Location(nodeKey: 0, line: scanner.lineNumber, start: start, stop: offset)
//        return(OperatorToken(location: location,string: string))
//        }
//    }
//
//public struct WhitespaceScanner: SubScanner
//    {
//    private static let characters = CharacterSet.whitespacesAndNewlines
//
//    public func matches(scanner: ArgonScanner) -> Bool
//        {
//        return(Self.characters.contains(scanner.nextCharacter(incrementIndex: false)))
//        }
//
//    public func scan(using scanner: ArgonScanner,location: Int) -> Token
//        {
//        var offset = location
//        let start = location
//        var string = String()
//        var character = scanner.nextCharacter(incrementIndex: false)
//        while Self.characters.contains(character) && !scanner.atEnd
//            {
//            scanner.nextCharacter(incrementIndex: true)
//            string += String(character)
//            offset += 1
//            character = scanner.nextCharacter(incrementIndex: false)
//            }
//        let location = Location(nodeKey: 0, line: scanner.lineNumber, start: start, stop: offset)
//        return(WhitespaceToken(location: location,string: string))
//        }
//    }
//
//public struct StringScanner: SubScanner
//    {
//    public func matches(scanner: ArgonScanner) -> Bool
//        {
//        return(String(scanner.nextCharacter(incrementIndex: false)) == "\"")
//        }
//
//    public func scan(using scanner: ArgonScanner,location: Int) -> Token
//        {
//        var offset = location
//        let start = location
//        var string = String()
//        var character = scanner.nextCharacter(incrementIndex: true)
//        character = scanner.nextCharacter(incrementIndex: true)
//        repeat
//            {
//            string += String(character)
//            offset += 1
//            character = scanner.nextCharacter(incrementIndex: true)
//            }
//        while String(character) != "\"" && !scanner.atEnd
//        let location = Location(nodeKey: 0, line: scanner.lineNumber, start: start, stop: offset)
//        return(StringToken(location: location,string: string))
//        }
//    }
//
//public struct SymbolScanner: SubScanner
//    {
//    private static let characters = CharacterSet.letters.union(CharacterSet.decimalDigits).union(CharacterSet(charactersIn: "-_"))
//
//    public func matches(scanner: ArgonScanner) -> Bool
//        {
//        return(String(scanner.nextCharacter(incrementIndex: false)) == "#")
//        }
//
//    public func scan(using scanner: ArgonScanner,location: Int) -> Token
//        {
//        var offset = location
//        let start = location
//        var string = String()
//        var character = scanner.nextCharacter(incrementIndex: true)
//        character = scanner.nextCharacter(incrementIndex: true)
//        repeat
//            {
//            string += String(character)
//            offset += 1
//            character = scanner.nextCharacter(incrementIndex: true)
//            }
//        while Self.characters.contains(character) && !scanner.atEnd
//        let location = Location(nodeKey: 0, line: scanner.lineNumber, start: start, stop: offset)
//        return(SymbolToken(location: location,string: string))
//        }
//    }
//
//public struct CommentScanner: SubScanner
//    {
//    public func matches(scanner: ArgonScanner) -> Bool
//        {
//        let prefix = scanner.sourceStringPrefix(ofLength: 2)
//        return(prefix == "/*" || prefix == "//")
//        }
//
//    public func scan(using scanner: ArgonScanner,location: Int) -> Token
//        {
//        let prefix = scanner.sourceStringPrefix(ofLength: 2)
//        if prefix == "/*"
//            {
//            return(self.scanMultilineComment(scanner: scanner,location: location))
//            }
//        else
//            {
//            return(self.scanSinglelineComment(scanner: scanner,location: location))
//            }
//        }
//
//    private func scanMultilineComment(scanner: ArgonScanner,location: Int) -> Token
//        {
//        let start = location
//        var offset = 0
//        var character = scanner.nextCharacter(incrementIndex: true)
//        var string = String()
//        repeat
//            {
//            string += String(character)
//            offset += 1
//            character = scanner.nextCharacter(incrementIndex: true)
//            }
//        while scanner.nextCharacter(at: 0) != "*" && scanner.nextCharacter(at: 1) != "/" && !scanner.atEnd
//        string += "*/"
//        let location = Location(nodeKey: 0, line: scanner.lineNumber, start: start, stop: start + offset)
//        return(CommentToken(location: location, string: string))
//        }
//
//    private func scanSinglelineComment(scanner: ArgonScanner,location: Int) -> Token
//        {
//        let start = location
//        let string = scanner.scanUntilEndOfLine()
//        let stop = location + string.count
//        let location = Location(nodeKey: 0, line: scanner.lineNumber, start: start, stop: stop)
//        return(CommentToken(location: location, string: string))
//        }
//    }
//
//public struct NumberScanner: SubScanner
//    {
//    public func matches(scanner: ArgonScanner) -> Bool
//        {
//        return(CharacterSet.decimalDigits.contains(scanner.nextCharacter(incrementIndex: false)))
//        }
//
//    public func scan(using scanner: ArgonScanner,location: Int) -> Token
//        {
//        let prefix = scanner.sourceStringPrefix(ofLength: 2)
//        if prefix == "0B"
//            {
//            return(self.scanBinaryNumber(scanner: scanner,location: location))
//            }
//        else if prefix == "0T"
//            {
//            return(self.scanTernaryNumber(scanner: scanner,location: location))
//            }
//        else if prefix == "0O"
//            {
//            return(self.scanOctalNumber(scanner: scanner,location: location))
//            }
//        else if prefix == "0X"
//            {
//            return(self.scanHexadecimalNumber(scanner: scanner,location: location))
//            }
//        else
//            {
//            return(self.scanNumber(scanner: scanner,location: location))
//            }
//        }
//
//    public func scanBinaryNumber(scanner: ArgonScanner,location: Int) -> Token
//        {
//        fatalError()
//        }
//
//    public func scanTernaryNumber(scanner: ArgonScanner,location: Int) -> Token
//        {
//        fatalError()
//        }
//
//    public func scanHexadecimalNumber(scanner: ArgonScanner,location: Int) -> Token
//        {
//        fatalError()
//        }
//
//    public func scanOctalNumber(scanner: ArgonScanner,location: Int) -> Token
//        {
//        fatalError()
//        }
//
//    public func scanNumber(scanner: ArgonScanner,location: Int) -> Token
//        {
//        var offset = location
//        let start = location
//        var string = String()
//        var character = scanner.nextCharacter(incrementIndex: true)
//        repeat
//            {
//            string += String(character)
//            offset += 1
//            character = scanner.nextCharacter(incrementIndex: true)
//            }
//        while CharacterSet.decimalDigits.contains(character) && !scanner.atEnd
//        if character == "."
//            {
//            return(self.scanFloatingPointNumber(string: string,scanner: scanner,location: location))
//            }
//        let location = Location(nodeKey: 0, line: scanner.lineNumber, start: start, stop: offset)
//        return(IntegerToken(location: location, string: string))
//        }
//
//    public func scanFloatingPointNumber(string incoming: String,scanner: ArgonScanner,location: Int) -> Token
//        {
//        var string = incoming
//        var offset = 1
//        string += "."
//        var character = scanner.nextCharacter(incrementIndex: true)
//        while CharacterSet.decimalDigits.contains(character) && !scanner.atEnd
//            {
//            string += String(character)
//            offset += 1
//            character = scanner.nextCharacter(incrementIndex: true)
//            }
//        let stop = location + string.count + offset
//        let location = Location(nodeKey: 0, line: scanner.lineNumber, start: location, stop: stop)
//        return(FloatToken(location: location, string: string))
//        }
//    }
//
//public class ArgonScanner
//    {
//    public var atEnd: Bool
//        {
//        self.offset >= self.sourceCharacterCount
//        }
//
//    public var lineNumber: Int
//        {
//        self.sourceLine
//        }
//
//    private var subScanners = Array<SubScanner>()
//    private let source:String
//    private var offset = 0
//    private var sourceCharacterCount: Int
//    private var sourceIndex: String.Index
//    private var sourceLine: Int = 1
//    public var currentCharacter = Unicode.Scalar(0)!
//    private var rules = Array<LexicalRule>()
//
//    public init(source: String)
//        {
//        self.source = source
//        self.sourceIndex = self.source.startIndex
//        self.sourceCharacterCount = self.source.count
//        self.subScanners.append(CommentScanner())
//        self.subScanners.append(WhitespaceScanner())
//        self.subScanners.append(StringScanner())
//        self.subScanners.append(NumberScanner())
//        self.subScanners.append(IdentifierScanner())
//        self.subScanners.append(OperatorScanner())
//        self.subScanners.append(SymbolScanner())
//        self.rules.append(LexicalRule(pattern: ., function: <#T##() -> Token#>
//        }
//
//    public func sourceStringPrefix(ofLength length: Int) -> String
//        {
//        let endIndex = self.source.index(self.sourceIndex,offsetBy: length)
//        return(String(self.source[self.sourceIndex...endIndex]))
//        }
//
//    public func nextCharacter(at integerOffset: Int) -> UnicodeScalar
//        {
//        let newIndex = self.source.index(self.sourceIndex,offsetBy: integerOffset)
//        let character = self.source.unicodeScalars[newIndex]
//        return(character)
//        }
//
//    @discardableResult
//    public func nextCharacter() -> Unicode.Scalar
//        {
//        self.currentCharacter = self.source.unicodeScalars[self.sourceIndex]
//        self.offset += 1
//        self.sourceIndex = self.source.index(after: self.sourceIndex)
//        if self.currentCharacter == "\n"
//            {
//            self.sourceLine += 1
//            }
//        return(self.currentCharacter)
//        }
//
//    public func scanUntilEndOfLine() -> String
//        {
//        self.nextCharacter()
//        var string = String()
//        while self.currentCharacter != "\n" && !self.atEnd
//            {
//            string += String(self.currentCharacter)
//            self.nextCharacter()
//            }
//        return(string)
//        }
//
//    private func scanToken() -> Token
//        {
//        let start = self.offset
//        for rule in self.rules
//            {
//            if rule.pattern.matches(string: String(self.currentCharacter))
//                {
//                return(rule.function())
//                }
//            }
//        let location = Location(nodeKey: 0, line: self.lineNumber, start: start, stop: self.offset)
//        return(ErrorToken(location: location, string: "Unexpected character '\(self.currentCharacter)'."))
//        }
//
//    private func scanComment() -> Token
//        {
//        let prefix = self.sourceStringPrefix(ofLength: 2)
//        if prefix == "/*"
//            {
//            return(self.scanMultilineComment())
//            }
//        else
//            {
//            return(self.scanSinglelineComment())
//            }
//        }
//
//    private func scanMultilineComment() -> Token
//        {
//        let start = self.offset
//        var localOffset = 0
//        var string = String()
//        repeat
//            {
//            string += String(self.currentCharacter)
//            localOffset += 1
//            self.nextCharacter()
//            }
//        while self.nextCharacter(at: 0) != "*" && self.nextCharacter(at: 1) != "/" && !self.atEnd
//        string += "*/"
//        let location = Location(nodeKey: 0, line: self.lineNumber, start: start, stop: start + localOffset)
//        return(CommentToken(location: location, string: string))
//        }
//
//    private func scanSinglelineComment() -> Token
//        {
//        let start = self.offset
//        let string = self.scanUntilEndOfLine()
//        let stop = start + string.count
//        let location = Location(nodeKey: 0, line: self.lineNumber, start: start, stop: stop)
//        return(CommentToken(location: location, string: string))
//        }
//        }
//
//
//
//    @discardableResult
//    public func nextCharacter(incrementIndex: Bool) -> UnicodeScalar
//        {
//        let character = self.source.unicodeScalars[self.sourceIndex]
//        if incrementIndex
//            {
//            self.offset += 1
//            self.sourceIndex = self.source.index(after: self.sourceIndex)
//            if character == "\n"
//                {
//                self.sourceLine += 1
//                }
//            }
//        return(character)
//        }
//
//    private func scanToken() -> Token
//        {
//        if self.offset >= self.sourceCharacterCount
//            {
//            return(EndToken(location: .zero,string: ""))
//            }
//        for subScanner in self.subScanners
//            {
//            if subScanner.matches(scanner: self)
//                {
//                let token = subScanner.scan(using: self, location: self.offset)
//                return(token)
//                }
//            }
//        fatalError("Unknown token type.")
//        }
//
//    public func allTokens() -> Tokens
//        {
//        var tokens = Tokens()
//        var token: Token!
//        repeat
//            {
//            token = self.scanToken()
//            tokens.append(token)
//            }
//        while !token.isEnd
//        return(tokens)
//        }
//    }


public class ArgonScanner
    {
//    private static let operatorList =
//        {
//        var operators: Array<String> =
//            [
//            "[",
//            "]",
//            "{",
//            "}",
//            "(",
//            ")",
//            "!",
//            "@",
//            "%",
//            "^",
//            "&&=",
//            "||=",
//            "&&",
//            "**",
//            "==",
//            ">=",
//            "<=",
//            "-=",
//            "+=",
//            "/=",
//            "*=",
//            "||",
//            "<<",
//            ">>",
//            "&=",
//            ">>=",
//            "<<=",
//            "|=",
//            "&=",
//            "/=",
//            "~=",
//            "^=",
//            "->",
//            "::",
//            "+",
//            "-",
//            "*",
//            "/",
//            "%",
//            "&",
//            "^",
//            ":",
//            ";",
//            "<",
//            ">",
//            
//            
//        operators.append(
//        }()
//        
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
    private let operatorCharacters = CharacterSet(charactersIn: "!$%^&*()-+=:;{}[]\\\\|<>?/.,~@")
    private let identifierStartCharacters = CharacterSet.letters.union(CharacterSet(charactersIn: "\\"))
    private let identifierCharacters = CharacterSet.letters.union(CharacterSet.decimalDigits).union(CharacterSet(charactersIn: "-_!?\\"))
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
