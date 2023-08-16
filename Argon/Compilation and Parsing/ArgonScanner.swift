//
//  Scanner.swift
//  Argon
//
//  Created by Vincent Coetzee on 27/12/2022.
//

import Foundation
import Path

public class TokenRule
    {
    public var makesToken: Bool
        {
        true
        }
        
    public var matchString: String
        {
        self._matchString!
        }
        
    public var matchLength: Int
        {
        self.matchRange!.length
        }
        
    public var isEndOfLineRule: Bool
        {
        false
        }
        
    public let tag: String
    public let pattern: String
    public let tokenType: Token.Type?
    public let startSet: CharacterSet
    
    public var mustMatchLineSeparators = false
    
    private var _matchString: String?
    private var token: Token?
    private var matchRange: NSRange?
    private let regex: NSRegularExpression
    
    public init(tag: String,pattern: String,tokenType: Token.Type?,startSet: CharacterSet)
        {
        self.startSet = startSet
        self.tag = tag
        self.pattern = pattern
        self.tokenType = tokenType
        self.regex = try! NSRegularExpression(pattern: pattern,options: [])
        }
        
    public func matches(in source: String,at location: Int) -> Bool
        {
        let range = self.regex.rangeOfFirstMatch(in: source, options: [.anchored], range: NSRange(location: location,length: source.count - location))
        if range.location != NSNotFound
            {
            self.matchRange = range
            let start = source.index(source.startIndex, offsetBy: self.matchRange!.location)
            let end = source.index(start, offsetBy: self.matchRange!.length)
            self._matchString = String(source[start..<end])
            return(true)
            }
        return(false)
        }

    }
    
public class WhitespaceRule: TokenRule
    {
    public override var makesToken: Bool
        {
        false
        }
    }
    
public class ArgonScanner
    {
    public var source: String
        {
        get
            {
            self._source
            }
        set
            {
            self._source = newValue
            self.rescan()
            }
        }
    
    private var _source:String = ""
    private let sourceKey: Int
    private var location: Int
    private var rules: Array<TokenRule> = []
    private var lineRecords = Array<LineRecord>()
    private var line: Int = 1
    private var currentCharacter = UnicodeScalar(0)!
    private let startWhitespaceSet = CharacterSet(charactersIn: "\n\r\t ")
    private let startOperatorSet = CharacterSet(charactersIn: "!@%^&*()_+=-~{}[]|\\:;.<>?")
    private let startIdentifierSet = CharacterSet.letters
    private let continueIdentifierSet = CharacterSet.alphanumerics.union(CharacterSet(charactersIn: "!?-_"))
    private let continueOperatorSet = CharacterSet(charactersIn: "!@%^&*()_+=-[]{}:;\\|/<>.")
    private let startNumberSet = CharacterSet.decimalDigits
    private let symbolSet = CharacterSet.alphanumerics
    private var currentIndex: String.Index
    private var tokenStart: Int = 0
    private var tokenStop: Int = 0
    private var sourceCount: Int
    private var tokens: Tokens?
    
    init(source: String,sourceKey: Int)
        {
        self.sourceKey = sourceKey
        self.sourceCount = source.count
        self.tokenStart = 0
        self.currentIndex = source.startIndex
        self.location = 0
        self._source = source
        self.initRules()
        self.scanLines()
        self.scan()
        }
        
    public func scan()
        {
        self.tokens = self.allTokens()
        }
        
    public func rescan()
        {
        self.tokens = nil
        self.sourceCount = self._source.count
        self.tokenStart = 0
        self.currentIndex = self._source.startIndex
        self.location = 0
        self.scanLines()
        self.scan()
        }
        
    private func scanLines()
        {
        var line = 1
        var count = 0
        var start = 0
        for character in self._source
            {
            if character == "\n"
                {
                let record = LineRecord(file: Path("/")!,line: line, lineStart: start, lineEnd: count)
                self.lineRecords.append(record)
                line += 1
                start = count + 1
                }
            count += 1
            }
        }
        
    private func initRules()
        {
        self.rules.append(TokenRule(tag: "separator",pattern: ",", tokenType: SeparatorToken.self,startSet: CharacterSet(charactersIn: ",")))
//        self.rules.append(TokenRule(tag: "path",pattern: "\\A(/)?[a-zA-Z0-9]+[/a-zA-Z0-9_\\-]*", tokenType: PathToken.self,startSet: .letters.union(CharacterSet(charactersIn: "/"))))
        self.rules.append(TokenRule(tag: "identifier",pattern: "\\A(\\$)?[a-zA-Z\\\\]+[a-zA-Z0-9_\\!\\?\\\\]*", tokenType: IdentifierToken.self,startSet: .letters.union(CharacterSet(charactersIn: "\\$"))))
//        self.rules.append(TokenRule(tag: "identifier",pattern: "\\A[a-zA-Z//]+[a-zA-Z0-9_\\-!\\?/]*", tokenType: IdentifierToken.self,startSet: .letters.union(CharacterSet(charactersIn: "/"))))
//        self.rules.append(TokenRule(tag: "character",pattern: "\\A§.", tokenType: CharacterToken.self,startSet: CharacterSet(charactersIn: "§")))
//        self.rules.append(TokenRule(tag: "byte",pattern: "\\A_[0-9]{1,3}", tokenType: ByteToken.self,startSet: CharacterSet(charactersIn: "_")))
        self.rules.append(TokenRule(tag: "symbol",pattern: "\\A#[a-zA-Z]+[a-zA-Z0-9_\\-!\\?]*", tokenType: SymbolToken.self,startSet: CharacterSet(charactersIn: "#")))
        self.rules.append(TokenRule(tag: "date",pattern: "\\A@\\([0-9]{1,2}/[0-1][0-9]/[0-9]{4}\\)", tokenType: DateToken.self,startSet: CharacterSet(charactersIn: "@")))
        self.rules.append(TokenRule(tag: "time",pattern: "\\A@\\([0-9]{1,2}\\:[0-9]{1,2}\\:[0-9]{1,2}(:[0-9]{1,4})?\\)", tokenType: TimeToken.self,startSet: CharacterSet(charactersIn: "@")))
        self.rules.append(TokenRule(tag: "dateTime",pattern: "\\A@\\([0-9]{1,2}/[0-1][0-9]/[0-9]{4}[:blank:][0-9]{1,2}\\:[0-9]{1,2}\\:[0-9]{1,2}(:[0-9]{1,4})?\\)", tokenType: DateTimeToken.self,startSet: CharacterSet(charactersIn: "@")))
        self.rules.append(WhitespaceRule(tag: "whitespace", pattern: "\\A(\\s|\n|\r|\t)+", tokenType: nil,startSet: CharacterSet(charactersIn: "\t\r\n ")))
        self.rules.append(TokenRule(tag: "comment1", pattern: "\\A\\/\\*(.|\n)*?\\*\\/", tokenType: CommentToken.self,startSet: CharacterSet(charactersIn: "/")))
        self.rules.append(TokenRule(tag: "comment2",pattern: "\\A\\/\\/(.)*?\n", tokenType: CommentToken.self,startSet: CharacterSet(charactersIn: "/")))
        self.rules.append(TokenRule(tag: "operator",pattern: "\\A([!\\$%\\^&\\*\\+\\-\\/~\\<\\>\\|\\[\\]\\{\\}\\(\\)\\.=\\:;]+)|(\\-\\>)?", tokenType: OperatorToken.self,startSet: CharacterSet(charactersIn: "!$%^&*()_+=-}{[]\\|?></~:;")))
//        self.rules.append(TokenRule(tag: "symbol",pattern: "\\A#[a-zA-Z]+[a-zA-Z0-9]*", tokenType: SymbolToken.self,startSet: CharacterSet(charactersIn: "#")))
        self.rules.append(TokenRule(tag: "integer",pattern: "\\A[0-9]+(?!\\.)", tokenType: IntegerToken.self,startSet: CharacterSet(charactersIn: "0123456789")))
        self.rules.append(TokenRule(tag: "float",pattern: "\\A[0-9]+(\\.[0-9]*)?[F]?", tokenType: FloatToken.self,startSet: CharacterSet(charactersIn: "0123456789")))
        self.rules.append(TokenRule(tag: "string",pattern: "\\A\\\"[^\\\"]*\\\"", tokenType: StringToken.self,startSet: CharacterSet(charactersIn: "\\\"")))
        self.rules.append(TokenRule(tag: "comma",pattern: "\\A,", tokenType: OperatorToken.self,startSet: CharacterSet(charactersIn: ",")))
        }
        
    public func allTokens() -> Tokens
        {
        if let someTokens = self.tokens
            {
            return(someTokens)
            }
        var tokens = Tokens()
        var wasMatched = false
        while self.location < self._source.count
            {
//            let start = self.source.index(self.source.startIndex, offsetBy: self.location)
//            let end = self.source.index(start, offsetBy: min(40,self.source.count - location))
//            print("LOCATION: \(self.location)")
//            print("SOURCE: \(String(self.source[start..<end]))")
            for rule in self.rules
                {
//                print("TRYING TO MATCH \(rule.tag) = \(rule.pattern)")
                let index = self._source.index(self._source.startIndex,offsetBy: self.location)
                let character = self._source.unicodeScalars[index]
                if rule.startSet.contains(character) && rule.matches(in: self._source,at: self.location)
                    {
                    wasMatched = true
//                    print("DID MATCH \(rule.tag)")
                    let matchLength = rule.matchLength
//                    print("MATCH WAS AT \(self.location),\(matchLength)")
//                    print("MATCH STRING WAS \(rule.tag)(\(rule.matchString))")
                    if rule.makesToken
                        {
                        let theLine = self.line(forLocation: self.location)
                        self.line = theLine
//                        print("LINE IS \(theLine)")
                        var token:Token
                        if rule.tag == "identifier" && KeywordToken.isKeyword(rule.matchString)
                            {
                            token = KeywordToken(location: Location(sourceKey: self.sourceKey,line: theLine, start: self.location, stop: self.location + matchLength),string: rule.matchString)
                            }
                        else
                            {
                            token = rule.tokenType!.init(location: Location(sourceKey: self.sourceKey,line: theLine, start: self.location, stop: self.location + matchLength),string: rule.matchString)
                            }
//                        let start1 = self.source.index(self.source.startIndex, offsetBy: self.location)
//                        let end1 = self.source.index(start, offsetBy: matchLength)
//                        let text = self.source[start1..<end1]
//                        print("TEXT FROM TOKEN = $\(text)$")
                        tokens.append(token)
                        }
                    self.location += matchLength
                    break
                    }
                }
            if !wasMatched
                {
                let errorToken = ErrorToken(location: Location(sourceKey: self.sourceKey,line: self.line, start: self.location, stop: self.location + 1), code: .invalidCharacterSequence, message: "Invalid character sequence")
                tokens.append(errorToken)
                self.location += 1
                }
            wasMatched = false
            }
        tokens.append(EndToken(location: Location(sourceKey: self.sourceKey,line: 0),string: ""))
        return(tokens)
        }
        
    private func line(forLocation location: Int) -> Int
        {
        for record in self.lineRecords
            {
            if location >= record.lineStart && location <= record.lineEnd
                {
                return(record.line)
                }
            }
        return(0)
        }
    
    private func isAtEnd() -> Bool
        {
        self.location + 1 >= self.sourceCount
        }
        
    private func isAtEndOfLine() -> Bool
        {
        self.currentCharacter == "\n"
        }
        
    private func scanWhitespace()
        {
        if self.currentCharacter == "\n"
            {
            self.line += 1
            }
        self.nextCharacter()
        if self.startWhitespaceSet.contains(self.currentCharacter)
            {
            self.scanWhitespace()
            }
        }
        
    private func peekCharacter(at: Int) -> Unicode.Scalar
        {
        let newIndex = self._source.index(self.currentIndex,offsetBy: at)
        if newIndex >= self._source.endIndex
            {
            return(Unicode.Scalar(0)!)
            }
        return(self._source.unicodeScalars[newIndex])
        }
        
    private func nextCharacter()
        {
        if self._source.index(self.currentIndex, offsetBy: 1) >= self._source.endIndex
            {
            self.currentCharacter = Unicode.Scalar(0)!
            return
            }
        self.currentIndex = self._source.index(self.currentIndex, offsetBy: 1)
        self.currentCharacter = self._source.unicodeScalars[self.currentIndex]
        self.tokenStop += 1
        self.location += 1
        }
        
    private func scanIdentifier() -> Token
        {
        var string = ""
        repeat
            {
            string += String(self.currentCharacter)
            self.nextCharacter()
            }
        while self.continueIdentifierSet.contains(self.currentCharacter) && !self.isAtEndOfLine() && !self.isAtEnd()
        return(IdentifierToken(location: Location(sourceKey: self.sourceKey,line: self.line, start: self.tokenStart, stop: self.tokenStop), string: string))
        }
        
    private func scanOperator() -> Token
        {
        var string = ""
        repeat
            {
            string += String(self.currentCharacter)
            self.nextCharacter()
            }
        while self.continueOperatorSet.contains(self.currentCharacter) && !self.isAtEndOfLine() && !self.isAtEnd()
        return(OperatorToken(location: Location(sourceKey: self.sourceKey,line: self.line, start: self.tokenStart, stop: self.tokenStop), string: string))
        }
        
    private func scanComment() -> Token
        {
        var string = String(self.currentCharacter)
        self.nextCharacter()
        if self.currentCharacter == "/"
            {
            while !self.isAtEndOfLine() && !self.isAtEnd()
                {
                string += String(self.currentCharacter)
                self.nextCharacter()
                }
            return(CommentToken(location: Location(sourceKey: self.sourceKey,line: self.line, start: self.tokenStart, stop: self.tokenStop), string: string))
            }
        else if self.currentCharacter == "*"
            {
            while !self.isAtEnd() && !(self.currentCharacter == "*" && self.peekCharacter(at: 1) == "/")
                {
                string += String(self.currentCharacter)
                self.nextCharacter()
                }
            return(CommentToken(location: Location(sourceKey: self.sourceKey,line: self.line, start: self.tokenStart, stop: self.tokenStop), string: string))
            }
//        self.reporter.addIssue("Invalid character sequence '\(string)'.", at: Location(line: self.line, start: self.tokenStart, stop: self.tokenStop), isWarning: false)
        return(CommentToken(location: Location(sourceKey: self.sourceKey,line: self.line, start: self.tokenStart, stop: self.tokenStop), string: string))
        }
        
    private func scanString() -> Token
        {
        self.nextCharacter()
        var string = ""
        self.nextCharacter()
        while self.currentCharacter != "\"" && !self.isAtEnd() && !self.isAtEndOfLine()
            {
            string += String(self.currentCharacter)
            self.nextCharacter()
            }
        return(StringToken(location: Location(sourceKey: self.sourceKey,line: self.line, start: self.tokenStart, stop: self.tokenStart), string: string))
        }
        
    private func scanSymbol() -> Token
        {
        var string = "#"
        self.nextCharacter()
        while self.symbolSet.contains(self.currentCharacter) && !self.isAtEnd() && !self.isAtEndOfLine()
            {
            string += String(self.currentCharacter)
            self.nextCharacter()
            }
        return(SymbolToken(location: Location(sourceKey: self.sourceKey,line: self.line, start: self.tokenStart, stop: self.tokenStart), string: string))
        }
    
    private func scanNumber() -> Token
        {
        var string = ""
        repeat
            {
            string += String(self.currentCharacter)
            self.nextCharacter()
            }
        while CharacterSet.decimalDigits.contains(self.currentCharacter) && !self.isAtEnd() && !self.isAtEndOfLine()
        if self.currentCharacter == "f"
            {
            self.nextCharacter()
            return(FloatToken(location: Location(sourceKey: self.sourceKey,line: self.line, start: self.tokenStart, stop: self.tokenStop), string: string))
            }
        if self.currentCharacter == "."
            {
            self.nextCharacter()
            while CharacterSet.decimalDigits.contains(self.currentCharacter)
                {
                string += String(self.currentCharacter)
                self.nextCharacter()
                }
            if self.currentCharacter == "f"
                {
                self.nextCharacter()
                }
            return(FloatToken(location: Location(sourceKey: self.sourceKey,line: self.line, start: self.tokenStart, stop: self.tokenStop), string: string))
            }
        return(IntegerToken(location: Location(sourceKey: self.sourceKey,line: self.line, start: self.tokenStart, stop: self.tokenStop), string: string))
        }
        
    public func scanToken() -> Token
        {
        self.tokenStart = self.location
        self.tokenStop = self.tokenStart
        if self.startWhitespaceSet.contains(self.currentCharacter)
            {
            self.scanWhitespace()
            return(self.scanToken())
            }
        else if self.startIdentifierSet.contains(self.currentCharacter)
            {
            return(self.scanIdentifier())
            }
        else if self.startOperatorSet.contains(self.currentCharacter)
            {
            return(self.scanOperator())
            }
        else if self.currentCharacter == "/"
            {
            return(self.scanComment())
            }
        else if self.currentCharacter == "\""
            {
            return(self.scanString())
            }
        else if self.startNumberSet.contains(self.currentCharacter)
            {
            return(self.scanNumber())
            }
        else if self.currentCharacter == ","
            {
            self.nextCharacter()
            return(OperatorToken(location: Location(sourceKey: self.sourceKey,line: self.line, start: self.tokenStart, stop: self.tokenStart), string: "."))
            }
        else if self.currentCharacter == "#"
            {
            return(self.scanSymbol())
            }
        else if self.isAtEnd()
            {
            return(EndToken(location: Location(sourceKey: self.sourceKey,line: self.line),string: ""))
            }
        else
            {
            print("INVALID CHARACTER SEQUENCE \(self.currentCharacter)")
//            self.reporter.addIssue("Invalid character sequence '\(self.currentCharacter)'.", at: Location(line: self.line, start: self.tokenStart, stop: self.tokenStop), isWarning: false)
            self.nextCharacter()
            return(self.scanToken())
            }
        }
        
//    public func allTokens() -> Tokens
//        {
//        self.reporter = reporter
//        var token: Token = Token(location: Location(line: 0), string: "")
//        var tokens = Tokens()
//        self.nextCharacter()
//        repeat
//            {
//            token = self.scanToken()
//            tokens.append(token)
//            }
//        while !token.isEndToken
//        return(tokens)
//        }
    }
