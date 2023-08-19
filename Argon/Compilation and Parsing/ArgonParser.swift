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
        self.register(tokenType: .literalDate,parser: LiteralParser())
        self.register(tokenType: .literalTime,parser: LiteralParser())
        self.register(tokenType: .literalDateTime,parser: LiteralParser())
        self.register(tokenType: .leftParenthesis,parser: GroupParser())
        self.register(tokenType: .leftParenthesis,parser: MethodInvocationParser())
        self.register(tokenType: .MAKE,parser: MakeParser())
        self.register(tokenType: .leftBracket,parser: ArrayReferenceParser())
        self.register(tokenType: .leftBrace,parser: ClosureParser(precedence: Precedence.prefix))
        self.register(tokenType: .rightArrow,parser: MemberAccessParser())
        
        self.postfix(tokenType: .increment,precedence: Precedence.postfix)
        self.postfix(tokenType: .decrement,precedence: Precedence.postfix)
        
        self.infixLeft(tokenType: .plus,precedence: Precedence.addition)
        self.infixLeft(tokenType: .minus,precedence: Precedence.addition)
        self.infixLeft(tokenType: .shiftLeft,precedence: Precedence.addition)
        self.infixLeft(tokenType: .shiftRight,precedence: Precedence.addition)
        self.infixLeft(tokenType: .times,precedence: Precedence.multiplication)
        self.infixLeft(tokenType: .divide,precedence: Precedence.multiplication)
        self.infixLeft(tokenType: .modulus,precedence: Precedence.multiplication)
        self.infixLeft(tokenType: .plusAssign,precedence: Precedence.assignment)
        self.infixLeft(tokenType: .minusAssign,precedence: Precedence.assignment)
        self.infixLeft(tokenType: .timesAssign,precedence: Precedence.assignment)
        self.infixLeft(tokenType: .modulusAssign,precedence: Precedence.assignment)
        self.infixLeft(tokenType: .divideAssign,precedence: Precedence.assignment)                           
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
        self.tokens = sourceFileNode.tokens.filter{!$0.isCommentToken}
        self.tokenIndex = 0
        self.token = self.tokens[self.tokenIndex]
        self.parseInitialModule()
        sourceFileNode.compilerIssues = self.tokens.reduce(CompilerIssues()) { $0 + $1.issues }
        sourceFileNode.astNode = self.topModule
        }
        
    private func nextToken(offset: Int) -> Token
        {
        var actualOffset = offset
        if self.tokenIndex + offset >= self.tokens.count
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
        
    public func lookupNode(atName: String) -> SyntaxTreeNode?
        {
        self.scopeStack.lookupSymbol(atName: atName)
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
        let initialModule = Module(name: self.token.identifier.lastPart)
        self.nextToken()
        self.currentScope.addNode(initialModule)
        self.pushCurrentScope(initialModule)
        self.parseBraces
            {
            while !self.token.isRightBrace && !self.token.isEnd
                {
                self.parseModuleEntries()
                }
            }
        self.popCurrentScope()
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
        var type: TypeNode = TypeNode(name: "")
        if typeName == "Array"
            {
            return(self.parseArrayType(location: location))
            }
        else
            {
            if self.token.isLeftBrocket
                {
                return(self.parseGenericTypeInstance(typeName: typeName,location: location))
                }
            }
        if let node = self.currentScope.lookupNode(atIdentifier: identifier) as? TypeNode
            {
            type = node
            }
        else
            {
            self.lodgeIssue(code: .undefinedType,message: "Type '\(identifier.description)' is undefined.",location: location)
            }
        return(type)
        }
        
    private func parseGenericTypeInstance(typeName: String,location: Location) -> TypeNode
        {
        var typeValues = TypeNodes()
        self.nextToken()
        repeat
            {
            self.parseComma()
            typeValues.append(self.parseType())
            }
        while self.token.isComma && !self.token.isRightBrocket && !self.token.isEnd
        if self.token.isRightBrocket
            {
            self.nextToken()
            }
        if let type = (self.currentScope.lookupNode(atName: typeName) as? TypeNode)?.baseType
            {
            if type.isGenericType
                {
                if type.genericTypes.count != typeValues.count
                    {
                    self.lodgeIssue(code: .invalidGenericArguments,message: "Type '\(typeName)' expects \(type.genericTypes.count) types but \(typeValues.count) were found.",location:location)
                    }
                if type.instanceType.isNotNil
                    {
                    return(type.instanceType!.init(originalType: type,types: typeValues))
                    }
                return(GenericTypeInstance(originalType: type,types: typeValues))
                }
            else
                {
                self.lodgeIssue(code: .usingGenericTypesOnNonGenericType,message: "The type '\(typeName)' does not have generic parameters so it can't be instantiated.",location: location)
                }
            return(type)
            }
        else
            {
            self.lodgeIssue(code: .undefinedType,message: "The type '\(typeName)' is not defined.",location: location)
            return(TypeNode(name: typeName))
            }
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
        arrayTypeInstance.addGenericType(elementType)
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
                let subType = SubType(name: Argon.nextIndex(named: "subType"), baseType: ArgonModule.shared.integerType, lowerBound: .integer(lowerBound), upperBound: .integer(upperBound))
                return(Argon.ArrayIndex.subType(subType))
                }
            else
                {
                return(Argon.ArrayIndex.integer)
                }
            }
        else if let enumeration = self.currentScope.lookupNode(atIdentifier: identifier) as? Enumeration
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
                    let subType = SubType(name: Argon.nextIndex(named: "enumerationSubType"), baseType: enumeration, lowerBound: .enumerationCase(lowerCase), upperBound: .enumerationCase(upperCase))
                    return(Argon.ArrayIndex.subType(subType))
                    }
                else
                    {
                    self.lodgeIssue(code: .invalidLowerBound,message: "Invalid lower bound for enumeration index '\(enumeration.name)'.",location: newLocation)
                    }
                let lowerCase = EnumerationCase(name: "#LOWER",associatedTypes: [],instanceValue: .none)
                let upperCase = EnumerationCase(name: "#UPPER",associatedTypes: [],instanceValue: .none)
                let subType = SubType(name: Argon.nextIndex(named: "enumerationSubType"), baseType: enumeration, lowerBound: .enumerationCase(lowerCase), upperBound: .enumerationCase(upperCase))
                return(Argon.ArrayIndex.subType(subType))
                }
            }
        else
            {
            if let type = self.currentScope.lookupNode(atIdentifier: identifier) as? TypeNode,type.inherits(from: ArgonModule.shared.enumerationBaseType)
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
        
    public func parseBrockets(closure: ParseClosure)
        {
        guard self.token.isLeftBrocket else
            {
            self.lodgeIssue(code: .leftBrocketExpected,location: self.token.location)
            return
            }
        self.nextToken()
        closure()
        guard self.token.isRightBrocket else
            {
            self.lodgeIssue(code: .rightBrocketExpected,location: self.token.location)
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
        
    private func parseModuleEntries()
        {
        switch(self.token.tokenType)
            {
            case(.STATIC):
                StaticStatement.parse(using: self)
            case(.METHOD):
                Method.parse(using: self)
            case(.FUNCTION):
                Function.parse(using: self)
            case(.CLASS):
                Class.parse(using: self)
            case(.ENUMERATION):
                Enumeration.parse(using: self)
            case(.LET):
                LetStatement.parse(using: self)
            case(.CONSTANT):
                Constant.parse(using: self)
            case(.TYPE):
                AliasedType.parse(using: self)
            case(.identifier):
                AssignmentExpression.parse(using: self)
            default:
                fatalError()
            }
        }
        
    private func parseBlockEntry()
        {
        switch(self.token.tokenType)
            {
            case(.STATIC):
                StaticStatement.parse(using: self)
            case(.METHOD):
                Method.parse(using: self)
            case(.FUNCTION):
                Function.parse(using: self)
            case(.CLASS):
                Class.parse(using: self)
            case(.ENUMERATION):
                Enumeration.parse(using: self)
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
            case(.SIGNAL):
                SignalStatement.parse(using: self)
            case(.HANDLE):
                HandleStatement.parse(using: self)
            case(.FORK):
                ForkStatement.parse(using: self)
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

    public func parseExpression() -> Expression
        {
        self.parseExpression(precedence: 0)
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
                let lastToken = self.token
                self.nextToken()
                let infixParser = self.infixParsers[lastToken.tokenType]
                left = infixParser!.parse(parser: self, left: left, token: lastToken)
                }
            }
        return(left)
        }

    public func parseArgument() -> Argument
        {
        let location = self.token.location
        var value = Expression()
        var argumentName: String!
        if self.token.isIdentifier
            {
            argumentName = self.token.identifier.lastPart
            self.nextToken()
            }
        else
            {
            self.lodgeIssue(code: .argumentNameExpected,location: location)
            }
        if !self.token.isScope
            {
            self.lodgeIssue(code: .scopeOperatorExpected,location: location)
            }
        else
            {
            self.nextToken()
            }
        value = self.parseExpression()
        return(Argument(name: argumentName, value: value))
        }
        
    public func parseParameter() -> Parameter
        {
        let location = self.token.location
        var value = Expression()
        var externalName:String?
        var internalName = ""
        var parameterDefinedByPosition = false
        if self.token.isMinus
            {
            // we only have an internal name
            self.nextToken()
            internalName = self.parseIdentifier(errorCode: .identifierExpected).lastPart
            parameterDefinedByPosition = true
            }
        else if self.nextToken(offset: 2).isScope
            {
            // we have an external name AND an internal name
            externalName = self.parseIdentifier(errorCode: .identifierExpected).lastPart
            internalName = self.parseIdentifier(errorCode: .identifierExpected).lastPart
            }
        else
            {
            // we just have a single name that is external and internal
            internalName = self.parseIdentifier(errorCode: .identifierExpected).lastPart
            externalName = internalName
            }
        // now we should have a scope operator followed by a type
        if self.token.isScope
            {
            self.nextToken()
            }
        else
            {
            self.lodgeIssue(code: .scopeOperatorExpected,location: location)
            }
        let type = self.parseType()
        return(Parameter(definedByPosition: parameterDefinedByPosition,externalName: externalName!,internalName: internalName, type: type))
        }
        
    private func precedence(of token: Token) -> Int
        {
        if let parser = self.infixParsers[token.tokenType]
            {
            return(parser.precedence)
            }
        return(0)
        }
        
    public func parseParameters() -> Parameters
        {
        var parameters = Parameters()
        self.parseParentheses
            {
            while !self.token.isRightParenthesis && !self.token.isEnd
                {
                parameters.append(self.parseParameter())
                self.parseComma()
                }
            }
        return(parameters)
        }
    }
