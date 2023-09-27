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
    private var lastIdentifierToken = Token(location: .zero)
    private var tokenIndex = 0
    public private(set) var token: Token
    private var scopeStack = Stack<Scope>()
    public private(set) var currentScope: Scope
    public private(set) var rootModule: RootModule
    private var initialModule: Module!
    public var nodeKey = 0
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
        self.register(tokenType: .literalAtom,parser: LiteralParser())
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
        
    public func setModule(forNode node: SourceFileNode)
        {
        node.module = self.initialModule
        }
        
    public func resetParser()
        {
        self.issues = CompilerIssues()
        self.tokenIndex = 0
        self.lastIdentifierToken = Token(location: .zero)
        self.scopeStack = Stack<Scope>()
        self.currentScope = self.rootModule
        self.token = EndToken(location: .zero)
        }
        
    public func allCompilerIssues() -> CompilerIssues
        {
        self.issues
        }
        
    public func compilerIssues(forNodeKey nodeKey: Int) -> CompilerIssues
        {
        self.issues.filter{$0.location.nodeKey == nodeKey}
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
        sourceFileNode.compilerIssues = CompilerIssues()
        self.scopeStack = Stack<Scope>()
        self.currentScope = self.rootModule
        self.tokens = sourceFileNode.tokens.filter{!$0.isCommentToken}
        self.tokenIndex = 0
        self.token = self.tokens[self.tokenIndex]
        self.parseInitialModule()
        sourceFileNode.compilerIssues = self.tokens.reduce(CompilerIssues()) { $0 + $1.issues }
        sourceFileNode.module = self.initialModule
        }
        
    public func nextToken(atOffset offset: Int) -> Token
        {
        var actualOffset = offset
        if self.tokenIndex + offset >= self.tokens.count
            {
            actualOffset = self.tokens.count - self.tokenIndex
            }
        if self.token.isIdentifier
            {
            self.lastIdentifierToken = self.token
            }
        return(self.tokens[actualOffset + self.tokenIndex])
        }
        
    public func isNextTokenValid(atOffset offset: Int) -> Bool
        {
        self.tokenIndex + offset >= 0 && self.tokenIndex + offset < self.tokens.count
        }
        
    @discardableResult
    public func nextToken() -> Token
        {
        if self.tokenIndex + 1 < self.tokens.count
            {
            if self.token.isIdentifier
                {
                self.lastIdentifierToken = self.token
                }
            self.tokenIndex += 1
            self.token = self.tokens[self.tokenIndex]
            return(self.token)
            }
        return(self.token)
        }
        
    public func lookupSymbol(atName: String) -> Symbol?
        {
        self.currentScope.lookupSymbol(atName: atName)
        }
        
    public func lookupSymbol(atIdentifier someIdentifier: Identifier) -> Symbol?
        {
        self.currentScope.lookupSymbol(atIdentifier: someIdentifier)
        }
        
    @discardableResult
    public func expect(tokenType: TokenType,error: IssueCode) -> Token?
        {
        let location = self.token.location
        if self.token.tokenType == tokenType
            {
            let temp = self.token
            self.nextToken()
            return(temp)
            }
        self.lodgeError(code: error,location: location)
        return(nil)
        }
        
    public func parseIdentifier(errorCode: IssueCode = .identifierExpected,message: String = "Identifier expected.") -> Identifier
        {
        let location = self.token.location
        guard self.token.isIdentifier else
            {
            self.lodgeError(code: errorCode,message: message,location: location)
            return(Identifier(string: Argon.nextIndex(named: "Symbol")))
            }
        let identifier = self.token.identifier
        self.nextToken()
        return(identifier)
        }
    
    public func pushCurrentScope(_ node: Symbol)
        {
        self.scopeStack.push(self.currentScope)
        self.currentScope = node as Scope
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
            self.lodgeError(code: .initialModuleDeclarationNotFound,location: location)
            return
            }
        self.nextToken()
        guard self.token.isIdentifier else
            {
            self.lodgeError(code: .identifierExpected,location: location)
            return
            }
        let name = self.token.identifier.lastPart
        if let someModule = RootModule.shared.lookupSymbol(atName: name) as? Module
            {
            initialModule = someModule
            }
        else
            {
            initialModule = Module(name: name)
            self.currentScope.addSymbol(initialModule)
            }
        self.nextToken()
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
        
    internal func parseSemicolon()
        {
        let location = self.token.location
        if self.token.isSemicolon
            {
            self.nextToken()
            }
        else
            {
            self.lodgeError(code: .semicolonExpected, location: location)
            }
        }
        
    public func parseType() -> ArgonType
        {
        let location = self.token.location
        self.token.setStyleElement(.colorType)
        let identifier = self.parseIdentifier(errorCode: .identifierExpected)
        let typeName = identifier.lastPart
        var type: ArgonType = ArgonType(name: typeName)
        var typeValues = ArgonTypes()
        if self.token.isLeftBrocket
            {
            repeat
                {
                self.parseComma()
                typeValues.append(self.parseType())
                }
            while self.token.isComma && !self.token.isEnd
            if self.token.isRightBrocket
                {
                self.nextToken()
                }
            }
        if let node = self.currentScope.lookupType(atIdentifier: identifier)
            {
            do
                {
                type = try node.constructType(from: typeValues)
                }
            catch let issue as CompilerError
                {
                self.lodgeError(issue,location: location)
                }
            catch
                {
                fatalError("Completely unexpected error in ArgonParser.parseType.")
                }
            }
        else
            {
            self.lodgeError(code: .typeUndefined,message: "Type '\(identifier.description)' is undefined.",location: location)
            }
        return(TypeRegistry.registerType(type))
        }
        
//    private func parseTypeParameters(typeName: String,location: Location) -> ArgonType
//        {
//        var typeValues = ArgonTypes()
//        self.nextToken()
//        repeat
//            {
//            self.parseComma()
//            typeValues.append(self.parseType())
//            }
//        while self.token.isComma && !self.token.isRightBrocket && !self.token.isEnd
//        if self.token.isRightBrocket
//            {
//            self.nextToken()
//            }
//        if let type = (self.currentScope.lookupSymbol(atName: typeName) as? ArgonType)?.baseType
//            {
//            if type.isGenericType
//                {
//                if type.genericTypes.count != typeValues.count
//                    {
//                    self.lodgeError(code: .invalidGenericArguments,message: "Class '\(typeName)' expects \(type.genericTypes.count) types but \(typeValues.count) were found.",location:location)
//                    }
//                return(GenericInstanceType(parentType: type,types: typeValues))
//                }
//            else
//                {
//                self.lodgeError(code: .usingGenericClassesOnNonGenericClass,message: "The class '\(typeName)' does not have generic parameters so it can't be instantiated.",location: location)
//                }
//            return(type)
//            }
//        else
//            {
//            self.lodgeError(code: .undefinedClass,message: "The class '\(typeName)' is not defined.",location: location)
//            return(ArgonType(name: typeName))
//            }
//        }
        
    private func parseDiscreteTypeIndex(location: Location) -> ArgonType
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
                let subType = SubType(name: Argon.nextIndex(named: "subType"), parentType: ArgonModule.shared.integerType, lowerBound: .integer(lowerBound), upperBound: .integer(upperBound))
                return(subType)
                }
            else
                {
                return(ArgonModule.shared.integerType)
                }
            }
        else if let enumeration = self.currentScope.lookupSymbol(atIdentifier: identifier) as? EnumerationType
            {
            let newLocation = self.token.location
            if self.token.isLeftBracket
                {
                var lowerBound: Argon.Atom = Argon.Atom("#LOWER")
                var upperBound: Argon.Atom = Argon.Atom("#UPPER")
                self.parseBrackets
                    {
                    lowerBound = self.parseAtomValue(code: .atomExpected)
                    if self.token.isRangeOperator
                        {
                        self.nextToken()
                        }
                    else
                        {
                        self.lodgeError(code: .rangeOperatorExpected,location: location)
                        }
                    upperBound = self.parseAtomValue(code: .atomExpected)
                    }
                if let lowerCase = enumeration.case(atAtom: lowerBound),let upperCase = enumeration.case(atAtom: upperBound)
                    {
                    let subType = SubType(name: Argon.nextIndex(named: "enumerationSubType"), parentType: enumeration, lowerBound: .enumerationCase(lowerCase), upperBound: .enumerationCase(upperCase))
                    return(subType)
                    }
                else
                    {
                    self.lodgeError(code: .invalidLowerBound,message: "Invalid lower bound for enumeration index '\(enumeration.name)'.",location: newLocation)
                    }
                let lowerCase = EnumerationCase(name: "#LOWER",enumeration: enumeration,associatedTypes: [],instanceValue: .none)
                let upperCase = EnumerationCase(name: "#UPPER",enumeration: enumeration,associatedTypes: [],instanceValue: .none)
                let subType = SubType(name: Argon.nextIndex(named: "enumerationSubType"), parentType: enumeration, lowerBound: .enumerationCase(lowerCase), upperBound: .enumerationCase(upperCase))
                return(subType)
                }
            return(enumeration)
            }
        else
            {
            if let type = self.currentScope.lookupSymbol(atIdentifier: identifier) as? ArgonType,type.inherits(from: ArgonModule.shared.discreteType)
                {
                return(type)
                }
            else
                {
                self.lodgeError(code: .discreteClassExpected,location: location)
                }
            }
        return(ArgonModule.shared.errorType)
        }
        
    private func parseIntegerValue(code: IssueCode) -> Argon.Integer
        {
        let location = self.token.location
        if self.token.isIntegerValue
            {
            let integer = self.token.integerValue
            self.nextToken()
            return(integer)
            }
        self.lodgeError(code: code,location: location)
        return(Argon.Integer(Argon.nextIndex))
        }
        
    private func parseAtomValue(code: IssueCode) -> Argon.Atom
        {
        let location = self.token.location
        if self.token.isAtomValue
            {
            let symbol = self.token.atomValue
            self.nextToken()
            return(symbol)
            }
        self.lodgeError(code: code,location: location)
        return(Argon.Atom(Argon.nextIndex(named: "#ATOM")))
        }
        
    private func parseRange(location: Location) -> Argon.Range
        {
        let lowerBound = self.token.integerValue
        self.parseComma()
        var upperBound:Argon.Integer = 0
        if self.token.isInteger
            {
            self.lodgeError(code: .integerExpected,location: location)
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
            self.lodgeError(code: .leftBraceExpected,location: self.token.location)
            return
            }
        self.nextToken()
        closure()
        guard self.token.isRightBrace else
            {
            self.lodgeError(code: .rightBraceExpected,location: self.token.location)
            return
            }
        self.nextToken()
        }
        
    public func parseBrockets(closure: ParseClosure)
        {
        guard self.token.isLeftBrocket else
            {
            self.lodgeError(code: .leftBrocketExpected,location: self.token.location)
            return
            }
        self.nextToken()
        closure()
        guard self.token.isRightBrocket else
            {
            self.lodgeError(code: .rightBrocketExpected,location: self.token.location)
            return
            }
        self.nextToken()
        }
        
    public func parseBrackets(closure: ParseClosure)
        {
        guard self.token.isLeftBracket else
            {
            self.lodgeError(code: .leftBracketExpected,location: self.token.location)
            return
            }
        self.nextToken()
        closure()
        guard self.token.isRightBracket else
            {
            self.lodgeError(code: .rightBracketExpected,location: self.token.location)
            return
            }
        self.nextToken()
        }
        
    public func parseParentheses(closure: ParseClosure)
        {
        guard self.token.isLeftParenthesis else
            {
            self.lodgeError(code: .leftParenthesisExpected,location: self.token.location)
            return
            }
        self.nextToken()
        closure()
        guard self.token.isRightParenthesis else
            {
            self.lodgeError(code: .rightParenthesisExpected,location: self.token.location)
            return
            }
        self.nextToken()
        }
        
    public func parseBlock() -> Block
        {
        fatalError()
        }
        
    public func addSymbol(_ node: Symbol)
        {
        self.currentScope.addSymbol(node)
        }
        
    private func parseModuleEntries()
        {
        switch(self.token.tokenType)
            {
            case(.STATIC):
                StaticStatement.parse(using: self)
            case(.METHOD):
                MethodType.parse(using: self)
            case(.FUNCTION):
                FunctionType.parse(using: self)
            case(.CLASS):
                ClassType.parse(using: self)
            case(.ENUMERATION):
                EnumerationType.parse(using: self)
            case(.LET):
                LetStatement.parse(using: self)
            case(.CONSTANT):
                Constant.parse(using: self)
            case(.TYPE):
                AliasedType.parse(using: self)
            case(.identifier):
                AssignmentExpression.parse(using: self)
            default:
                self.lodgeError(code: .statementExpected,message: "A statement was expected but '\(self.token.matchString)' was found.",location: self.token.location)
                self.nextToken()
            }
        }
        
    private func parseBlockEntry()
        {
        switch(self.token.tokenType)
            {
            case(.identifier):
                AssignmentExpression.parse(using: self)
            case(.STATIC):
                StaticStatement.parse(using: self)
            case(.METHOD):
                MethodType.parse(using: self)
            case(.FUNCTION):
                FunctionType.parse(using: self)
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
            case(.SIGNAL):
                SignalStatement.parse(using: self)
            case(.HANDLE):
                HandleStatement.parse(using: self)
            case(.FORK):
                ForkStatement.parse(using: self)
            case(.FOR):
                ForStatement.parse(using: self)
            case(.LOOP):
                LoopStatement.parse(using: self)
            default:
                self.lodgeError(code: .statementExpected,location: self.token.location)
                self.nextToken()
            }
        }
        
    private func parseImportDeclaration()
        {
//        self.nextToken()
//        guard let lastToken = self.expect(tokenType: .identifier, error: .identifierExpected) else
//            {
//            return
//            }
////        let importedModuleName = lastToken.identifier.lastPart
//        guard self.expect(tokenType: .leftParenthesis,error: .leftParenthesisExpected).isNotNil else
//            {
//            return
//            }
//        guard let middleToken = self.expect(tokenType: .path,error: .pathExpected) else
//            {
//            return
//            }
////        let importPath = middleToken.pathValue
//        guard self.expect(tokenType: .rightParenthesis,error: .rightParenthesisExpected).isNil else
//            {
//            return
//            }
        }
        
    public func lodgeError(code: IssueCode,message: String? = nil,location: Location)
        {
        var newLocation = location
        newLocation.nodeKey = self.nodeKey
        self.issues.append(CompilerError(code: code, message: message,location: newLocation))
        }
        
    public func lodgeError(_ error: CompilerError,location: Location)
        {
        var newLocation = location
        newLocation.nodeKey = self.nodeKey
        self.issues.append(CompilerError(code: error.code, message: error.message,location: newLocation))
        }
        
    public func lodgeWarning(code: IssueCode,message: String? = nil,location: Location)
        {
        var newLocation = location
        newLocation.nodeKey = self.nodeKey
        self.issues.append(CompilerWarning(code: code, message: message,location: newLocation))
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
            self.lodgeError(code: .invalidExpression,message: "The value '\(self.token.matchString)' could not be parsed.",location: location)
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
        var argumentName: String = ""
        if self.nextToken(atOffset: 1).isScope
            {
            if self.token.isIdentifier
                {
                argumentName = self.token.identifier.lastPart
                self.nextToken()
                self.nextToken()
                }
            else
                {
                self.lodgeError(code: .argumentNameExpected,location: location)
                }
            }
        let value = self.parseExpression()
        return(Argument(name: argumentName, value: value))
        }
        
    public func parseParameter() -> Parameter
        {
        let location = self.token.location
//        var value = Expression()
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
        else if self.nextToken(atOffset: 2).isScope
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
            self.lodgeError(code: .scopeOperatorExpected,location: location)
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
