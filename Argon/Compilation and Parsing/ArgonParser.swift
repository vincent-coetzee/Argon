//
//  ArgonParser.swift
//  Argon
//
//  Created by Vincent Coetzee on 07/01/2023.
//

import Foundation
import LLVMC

public typealias ParseClosure = () -> Void
    
public class ArgonParser
    {
    private var tokens: Tokens = Tokens()
    private var tokenIndex = 0
    public private(set) var token: Token
    private var scopeStack = Stack<Scope>()
    public private(set) var currentScope: Scope
    private var rootModule: RootModule
    private var operandStack = Stack<ValueBox>()
    private var operatorStack = Stack<TokenType>()
    private var topModule: Module?
    private var symbolIndex = 1
    private var prefixParsers = Dictionary<TokenType,PrefixParser>()
    private var infixParsers = Dictionary<TokenType,InfixParser>()
    private var issues = CompilerIssues()
    
    init(rootModule: RootModule)
        {
        self.rootModule = rootModule
        self.currentScope = self.rootModule
        self.token = EndToken(location: .zero)
        self.initParsers()
        }
        
    private func initParsers()
        {
        self.register(tokenType: .identifier,parser: IdentifierParser())
        self.register(tokenType: .assign,parser: AssignmentParser())
        self.register(tokenType: .ternary,parser: TernaryParser())
        self.register(tokenType: .literalInteger,parser: LiteralParser())
        self.register(tokenType: .literalFloat,parser: LiteralParser())
        self.register(tokenType: .literalString,parser: LiteralParser())
        self.register(tokenType: .literalSymbol,parser: LiteralParser())
        self.register(tokenType: .literalBoolean,parser: LiteralParser())
        self.register(tokenType: .literalCharacter,parser: LiteralParser())
        self.register(tokenType: .leftParenthesis,parser: GroupParser())
        self.register(tokenType: .leftParenthesis,parser: MethodInvocationParser())
        self.register(tokenType: .leftBracket,parser: ArrayReferenceParser())
        self.postfix(tokenType: .increment,precedence: Precedence.postfix)
        self.postfix(tokenType: .decrement,precedence: Precedence.postfix)
        self.infixLeft(tokenType: .plus,precedence: Precedence.addition)
        self.infixLeft(tokenType: .minus,precedence: Precedence.addition)
        self.infixLeft(tokenType: .shiftLeft,precedence: Precedence.addition)
        self.infixLeft(tokenType: .shiftRight,precedence: Precedence.addition)
        self.infixLeft(tokenType: .times,precedence: Precedence.multiplication)
        self.infixLeft(tokenType: .divide,precedence: Precedence.multiplication)
        self.infixLeft(tokenType: .rightArrow,precedence: Precedence.memberAccess)
        self.infixLeft(tokenType: .plusAssign,precedence: Precedence.operatorAssign)
        self.infixLeft(tokenType: .minusAssign,precedence: Precedence.operatorAssign)
        self.infixLeft(tokenType: .timesAssign,precedence: Precedence.operatorAssign)
        self.infixLeft(tokenType: .divideAssign,precedence: Precedence.operatorAssign)
        self.infixLeft(tokenType: .notAssign,precedence: Precedence.operatorAssign)
        self.infixLeft(tokenType: .booleanOrAssign,precedence: Precedence.operatorAssign)
        self.infixLeft(tokenType: .booleanAndAssign,precedence: Precedence.operatorAssign)
        self.infixLeft(tokenType: .booleanNotAssign,precedence: Precedence.operatorAssign)
        self.infixLeft(tokenType: .logicalOrAssign,precedence: Precedence.operatorAssign)
        self.infixLeft(tokenType: .logicalAndAssign,precedence: Precedence.operatorAssign)
        self.infixLeft(tokenType: .logicalXorAssign,precedence: Precedence.operatorAssign)
        self.infixLeft(tokenType: .logicalNotAssign,precedence: Precedence.operatorAssign)
        self.infixLeft(tokenType: .shiftLeftAssign,precedence: Precedence.operatorAssign)
        self.infixLeft(tokenType: .shiftRightAssign,precedence: Precedence.operatorAssign)
        self.infixLeft(tokenType: .lessThan,precedence: Precedence.relational)
        self.infixLeft(tokenType: .lessThanEquals,precedence: Precedence.relational)
        self.infixLeft(tokenType: .equals,precedence: Precedence.relational)
        self.infixLeft(tokenType: .greaterThan,precedence: Precedence.relational)
        self.infixLeft(tokenType: .greaterThanEquals,precedence: Precedence.relational)
        self.infixRight(tokenType: .power,precedence: Precedence.power)
        self.infixLeft(tokenType: .booleanAnd,precedence: Precedence.boolean)
        self.infixLeft(tokenType: .booleanOr,precedence: Precedence.boolean)
        self.infixLeft(tokenType: .logicalAnd,precedence: Precedence.logical)
        self.infixLeft(tokenType: .logicalOr,precedence: Precedence.logical)
        self.infixLeft(tokenType: .logicalXor,precedence: Precedence.logical)
        self.prefix(tokenType: .booleanNot,precedence: Precedence.prefix)
        self.prefix(tokenType: .logicalNot,precedence: Precedence.prefix)
        self.prefix(tokenType: .plus,precedence: Precedence.prefix)
        self.prefix(tokenType: .minus,precedence: Precedence.prefix)
        self.register(tokenType: .leftBrace,parser: ClosureParser(precedence: Precedence.prefix))
        }
        
    private func register(tokenType: TokenType,parser: InfixParser)
        {
        self.infixParsers[tokenType] = parser
        }
        
    private func register(tokenType: TokenType,parser: PrefixParser)
        {
        self.prefixParsers[tokenType] = parser
        }
        
    private func prefix(tokenType: TokenType,precedence: Int)
        {
        self.register(tokenType: tokenType,parser: PrefixOperatorParser(precedence: precedence))
        }
        
    private func postfix(tokenType: TokenType,precedence: Int)
        {
        self.register(tokenType: tokenType,parser: PostfixOperatorParser(precedence: precedence))
        }
        
        
    private func infixLeft(tokenType: TokenType,precedence: Int)
        {
        self.register(tokenType: tokenType,parser: BinaryOperatorParser(precedence: precedence, isRightAssociative: false))
        }
        
    private func infixRight(tokenType: TokenType,precedence: Int)
        {
        self.register(tokenType: tokenType,parser: BinaryOperatorParser(precedence: precedence, isRightAssociative: true))
        }
        
    public func parse(sourceFileNode: SourceFileNode)
        {
        sourceFileNode.astNode = nil
        sourceFileNode.compilerIssues = CompilerIssues()
        self.scopeStack = Stack<Scope>()
        self.currentScope = self.rootModule
        self.tokens = sourceFileNode.tokens
        self.tokenIndex = 0
        self.token = self.tokens[self.tokenIndex]
        self.tokenIndex += 1
        self.parseInitialModule()
        sourceFileNode.compilerIssues = self.tokens.reduce(CompilerIssues()) { $0 + $1.issues }
        sourceFileNode.astNode = self.topModule
        }
        
    private func nextToken(offset: Int) -> Token
        {
        var actualOffset = offset
        if self.tokenIndex + offset < self.tokens.count
            {
            actualOffset = self.tokens.count - self.tokenIndex
            }
        return(self.tokens[actualOffset + self.tokenIndex])
        }
        
    @discardableResult
    public func nextToken() -> Token
        {
        if self.tokenIndex + 1 < self.tokens.count
            {
            self.tokenIndex += 1
            self.token = self.tokens[self.tokenIndex]
            return(self.token)
            }
        return(self.token)
        }
        
    @discardableResult
    public func expect(tokenType: TokenType,error: ErrorCode) -> Token?
        {
        let location = self.token.location
        if self.token.tokenType == tokenType
            {
            let temp = self.token
            self.nextToken()
            return(temp)
            }
        self.lodgeIssue(code: error,location: location)
        return(nil)
        }
        
    public func parseIdentifier(errorCode: ErrorCode = .identifierExpected,message: String = "Identifier expected.") -> Identifier
        {
        let location = self.token.location
        guard self.token.isIdentifier else
            {
            self.lodgeIssue(code: errorCode,message: message,location: location)
            let index = self.symbolIndex
            self.symbolIndex += 1
            return(Identifier(string: "Symbol\(index)"))
            }
        let identifier = self.token.identifier
        self.nextToken()
        return(identifier)
        }
        
    public func addNode(_ node: SyntaxTreeNode,atIdentifier: Identifier)
        {
        self.currentScope.addNode(node,atIdentifier: atIdentifier)
        }
        
    public func lookupNode(atIdentifier: Identifier) -> SyntaxTreeNode?
        {
        self.scopeStack.lookupSymbol(atIdentifier: atIdentifier)
        }
        
    public func pushCurrentScope(_ node: SyntaxTreeNode)
        {
        self.scopeStack.push(self.currentScope)
        self.currentScope = node as! Scope
        }
        
    @discardableResult
    public func popCurrentScope() -> Scope?
        {
        self.currentScope = self.scopeStack.pop()
        return(self.currentScope)
        }
        
    private func parseInitialModule()
        {
        let location = self.token.location
        guard self.token.isModule else
            {
            self.lodgeIssue(code: .initialModuleDeclarationNotFound,location: location)
            return
            }
        self.nextToken()
        guard self.token.isIdentifier else
            {
            self.lodgeIssue(code: .identifierExpected,location: location)
            return
            }
        let initialModule = Module(identifier: self.token.identifier)
        self.pushCurrentScope(initialModule)
        self.parseBraces
            {
            while !self.token.isRightBrace && !self.token.isEnd
                {
                self.parseBlockEntry(into: self.currentScope)
                }
            }
        }
        
    internal func parseComma()
        {
        if self.token.isComma
            {
            self.nextToken()
            }
        }
        
    public func parseType() -> TypeNode
        {
        let location = self.token.location
        let identifier = self.parseIdentifier(errorCode: .identifierExpected)
        let typeName = identifier.lastPart
        var typeVariables = TypeNodes()
        if typeName == "Array"
            {
            return(self.parseArrayType(location: location))
            }
        if self.token.isLeftBrocket
            {
            self.nextToken()
            repeat
                {
                self.parseComma()
                typeVariables.append(self.parseType())
                }
            while self.token.isComma && !self.token.isRightBrocket
            if self.token.isRightBrocket
                {
                self.nextToken()
                }
            }
        var type: TypeNode = TypeNode(name: "")
        if let node = self.currentScope.lookupNode(atIdentifier: identifier) as? TypeNode
            {
            type = node
            }
        else
            {
            type = ForwardReference(name: typeName)
            self.currentScope.addNode(type)
            self.lodgeIssue(code: .undefinedType,message: "'\(identifier.description)' is undefined.",location: location)
            }
        return(type)
        }
        
    public func parseArrayType(location: Location) -> TypeNode
        {
        if !self.token.isLeftBrocket
            {
            self.lodgeIssue(code: .leftBrocketExpected,location: location)
            }
        else
            {
            self.nextToken()
            }
        let elementType = self.parseType()
        if !self.token.isComma
            {
            self.lodgeIssue(code: .commaExpected,location: location)
            }
        else
            {
            self.nextToken()
            }
        var index: Argon.ArrayIndex = .none
        if self.token.isIdentifier
            {
            index = self.parseDiscreteTypeIndex(location: location)
            }
        if !self.token.isRightBracket
            {
            self.lodgeIssue(code: .rightBracketExpected,location: location)
            }
        let arrayTypeInstance = ArrayTypeInstance(originalType: ArgonModule.arrayType,indexType: index)
        arrayTypeInstance.generics.append(elementType)
        return(arrayTypeInstance)
        }
        
    private func parseDiscreteTypeIndex(location: Location) -> Argon.ArrayIndex
        {
        let identifier = self.token.identifier
        self.nextToken()
        if identifier.lastPart == "Integer"
            {
            if self.token.isLeftBracket
                {
                var lowerBound: Argon.Integer = 0
                var upperBound: Argon.Integer = 0
                self.parseBrackets
                    {
                    lowerBound = self.parseIntegerValue(code: .integerValueExpected)
                    if self.token.isRangeOperator
                        {
                        self.nextToken()
                        }
                    upperBound = self.parseIntegerValue(code: .integerValueExpected)
                    }
                return(Argon.ArrayIndex.integerRange(lowerBound: lowerBound,upperBound: upperBound))
                }
            else
                {
                return(Argon.ArrayIndex.integer)
                }
            }
        else if let enumeration = self.currentScope.lookupNode(atIdentifier: identifier) as? EnumerationType
            {
            let newLocation = self.token.location
            if self.token.isLeftBracket
                {
                var lowerBound: Argon.Symbol = Argon.Symbol("")
                var upperBound: Argon.Symbol = Argon.Symbol("")
                self.parseBrackets
                    {
                    lowerBound = self.parseSymbolValue(code: .symbolExpected)
                    if self.token.isRangeOperator
                        {
                        self.nextToken()
                        }
                    else
                        {
                        self.lodgeIssue(code: .rangeOperatorExpected,location: location)
                        }
                    upperBound = self.parseSymbolValue(code: .symbolExpected)
                    }
                if let lowerCase = enumeration.case(atSymbol: lowerBound),let upperCase = enumeration.case(atSymbol: upperBound)
                    {
                    return(Argon.ArrayIndex.enumerationRange(enumeration,lowerBound: lowerCase,upperBound: upperCase))
                    }
                else
                    {
                    self.lodgeIssue(code: .invalidLowerBound,message: "Invalid lower bound for enumeration index '\(enumeration.name)'.",location: newLocation)
                    }
                return(Argon.ArrayIndex.enumerationRange(enumeration,lowerBound: EnumerationCase(name: "#LOWER",type: ArgonModule.shared.integerType),upperBound: EnumerationCase(name: "#UPPER",type: ArgonModule.shared.integerType)))
                }
            }
        else
            {
            if let type = self.currentScope.lookupNode(atIdentifier: identifier) as? TypeNode,type.isDiscreteType
                {
                return(Argon.ArrayIndex.discreteType(type))
                }
            else
                {
                self.lodgeIssue(code: .discreteTypeExpected,location: location)
                }
            }
        return(Argon.ArrayIndex.none)
        }
        
    private func parseIntegerValue(code: ErrorCode) -> Argon.Integer
        {
        let location = self.token.location
        if self.token.isIntegerValue
            {
            let integer = self.token.integerValue
            self.nextToken()
            return(integer)
            }
        self.lodgeIssue(code: code,location: location)
        return(Argon.Integer(Argon.nextIndex))
        }
        
    private func parseSymbolValue(code: ErrorCode) -> Argon.Symbol
        {
        let location = self.token.location
        if self.token.isSymbolValue
            {
            let symbol = self.token.symbolValue
            self.nextToken()
            return(symbol)
            }
        self.lodgeIssue(code: code,location: location)
        return(Argon.Symbol(Argon.nextIndex(named: "#SYM")))
        }
        
    private func parseRange(location: Location) -> Argon.Range
        {
        let lowerBound = self.token.integerValue
        self.parseComma()
        var upperBound:Argon.Integer = 0
        if self.token.isInteger
            {
            self.lodgeIssue(code: .integerExpected,location: location)
            }
        else
            {
            upperBound = self.token.integerValue
            self.nextToken()
            }
        return(Argon.Range(lowerBound: lowerBound,upperBound: upperBound))
        }
        
    public func parseBraces(closure: ParseClosure)
        {
        guard self.token.isLeftBrace else
            {
            self.lodgeIssue(code: .leftBraceExpected,location: self.token.location)
            return
            }
        self.nextToken()
        closure()
        guard self.token.isRightBrace else
            {
            self.lodgeIssue(code: .rightBraceExpected,location: self.token.location)
            return
            }
        self.nextToken()
        }
        
    public func parseBrackets(closure: ParseClosure)
        {
        guard self.token.isLeftBracket else
            {
            self.lodgeIssue(code: .leftBracketExpected,location: self.token.location)
            return
            }
        self.nextToken()
        closure()
        guard self.token.isRightBracket else
            {
            self.lodgeIssue(code: .rightBracketExpected,location: self.token.location)
            return
            }
        self.nextToken()
        }
        
    public func parseParentheses(closure: ParseClosure)
        {
        guard self.token.isLeftParenthesis else
            {
            self.lodgeIssue(code: .leftParenthesisExpected,location: self.token.location)
            return
            }
        self.nextToken()
        closure()
        guard self.token.isRightParenthesis else
            {
            self.lodgeIssue(code: .rightParenthesisExpected,location: self.token.location)
            return
            }
        self.nextToken()
        }
        
    public func parseBlock() -> Block
        {
        fatalError()
        }
        
    public func addNode(_ node: SyntaxTreeNode)
        {
        self.currentScope.addNode(node)
        }
        
    private func parseBlockEntry(into scope: Scope)
        {
        switch(self.token.tokenType)
            {
            case(.METHOD):
                Method.parse(using: self)
            case(.FUNCTION):
                Function.parse(using: self)
            case(.CLASS):
                ClassType.parse(using: self)
            case(.ENUMERATION):
                EnumerationType.parse(using: self)
            case(.LET):
                LetStatement.parse(using: self)
            case(.SELECT):
                SelectStatement.parse(using: self)
            case(.TIMES):
                TimesStatement.parse(using: self)
            case(.REPEAT):
                RepeatStatement.parse(using: self)
            case(.WHILE):
                WhileStatement.parse(using: self)
            case(.IF):
                IfStatement.parse(using: self)
            case(.CONSTANT):
                Constant.parse(using: self)
            default:
                fatalError()
            }
        }
        
    private func parseImportDeclaration()
        {
        self.nextToken()
        guard let lastToken = self.expect(tokenType: .identifier, error: .identifierExpected) else
            {
            return
            }
        let importedModuleName = lastToken.identifier.lastPart
        guard self.expect(tokenType: .leftParenthesis,error: .leftParenthesisExpected).isNotNil else
            {
            return
            }
        guard let middleToken = self.expect(tokenType: .path,error: .pathExpected) else
            {
            return
            }
        let importPath = middleToken.pathValue
        guard self.expect(tokenType: .rightParenthesis,error: .rightParenthesisExpected).isNil else
            {
            return
            }
        }
        
    public func lodgeIssue(code: ErrorCode,message: String? = nil,location: Location)
        {
        self.issues.append(CompilerIssue(code: code, message: message,location: location))
        }

    public func parseExpression(precedence: Int) -> Expression
        {
        let location = self.token.location
        let parser = self.prefixParsers[self.token.tokenType]
        var left = Expression()
        if parser.isNil
            {
            self.lodgeIssue(code: .invalidExpression,location: location)
            }
        else
            {
            left = parser!.parse(parser: self,token: self.token)
            while precedence < self.precedence(of: self.token) && token.isExpressionRelatedToken
                {
                self.nextToken()
                let infixParser = self.infixParsers[self.token.tokenType]
                left = infixParser!.parse(parser: self, left: left, token: self.token)
                }
            }
        return(left)
        }

    public func parseArgument() -> Argument
        {
        let location = self.token.location
        var value = Expression()
        var externalName:String?
        var internalName = ""
        if self.token.isMinus
            {
            // we only have an internal name
            self.nextToken()
            if !self.token.isIdentifier
                {
                self.lodgeIssue(code: .identifierExpected,location: location)
                internalName = Argon.nextIndex(named: "IN")
                }
            else
                {
                if self.token.identifier.isCompoundIdentifier
                    {
                    self.lodgeIssue(code: .singleIdentifierExpected,location: location)
                    }
                internalName = self.token.identifier.lastPart
                }
            }
        else if self.nextToken(offset: 1).isScope
            {
            // we have an external name AND an internal name
            if !self.token.isIdentifier
                {
                self.lodgeIssue(code: .identifierExpected,location: location)
                externalName = Argon.nextIndex(named: "EN")
                }
            else
                {
                if self.token.identifier.isCompoundIdentifier
                    {
                    self.lodgeIssue(code: .singleIdentifierExpected,location: location)
                    externalName = Argon.nextIndex(named: "EN")
                    }
                else
                    {
                    externalName = self.token.identifier.lastPart
                    self.nextToken()
                    }
                }
            }
        else
            {
            // we just have a single name that is external and internal
            if !self.token.isIdentifier
                {
                self.lodgeIssue(code: .identifierExpected,location: location)
                externalName = Argon.nextIndex(named: "EN")
                internalName = externalName!
                }
            else
                {
                if self.token.identifier.isCompoundIdentifier
                    {
                    self.lodgeIssue(code: .singleIdentifierExpected,location: location)
                    externalName = Argon.nextIndex(named: "EN")
                    }
                else
                    {
                    externalName = self.token.identifier.lastPart
                    self.nextToken()
                    }
                internalName = externalName!
                }
            }
        // now we should have a scope operator followed by a type
        if !self.token.isScope
            {
            self.lodgeIssue(code: .scopeOperatorExpected,location: location)
            }
        else
            {
            self.nextToken()
            }
        value = self.parseExpression(precedence: 0)
        return(Argument(externalName: externalName!,internalName: internalName, value: value))
        }
        
    private func precedence(of token: Token) -> Int
        {
        if let parser = self.infixParsers[token.tokenType]
            {
            return(parser.precedence)
            }
        return(0)
        }
    }
