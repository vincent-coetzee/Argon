//
//  ArgonTypeAssigner.swift
//  Argon
//
//  Created by Vincent Coetzee on 15/10/2023.
//

import Foundation

public class ArgonTypeAssigner: Visitor, IssueReporter
    {
    internal var compilerIssues = CompilerIssues()
    internal var visitedSymbols = Set<Identifier>()
    internal var substitutionSet = TypeSubstitutionSet()
        
    public func wasNotVisited(_ symbol: Symbol) -> Bool
        {
        !self.visitedSymbols.contains(symbol.identifier)
        }
        
    public func markAsVisited(_ symbol: Symbol)
        {
        self.visitedSymbols.insert(symbol.identifier)
        }
        
    public var processingFlag: ProcessingFlags
        {
        .typesChecked
        }
        
    public func assignTypes(to rootModule: RootModule)
        {
        rootModule.accept(visitor: self)
        }
        
    public func enter(rootModule: RootModule)
        {
        guard self.wasNotVisited(rootModule) else
            {
            return
            }
        self.markAsVisited(rootModule)
        self.substitutionSet.addConstraint(issueReporter: self,lhs: rootModule.symbolType,.equal,rhs: ModuleType(name: "Root"),origin: .symbol(rootModule))
        }
    
    public func appendIssue(_ issue: CompilerIssue)
        {
        self.compilerIssues.append(issue)
        }
        
    public func exit(rootModule: RootModule)
        {
        }
        
    public func enter(method: MethodType)
        {
        }
        
    public func exit(method: MethodType)
        {
        }
    
    public func enter(module: ModuleType)
        {
        }
    
    public func exit(module: ModuleType)
        {
        
        }
    
    public func enter(class: ClassType)
        {
        
        }
    
    public func exit(class: ClassType)
        {
        
        }
    
    public func enter(enumeration: EnumerationType)
        {
        
        }
    
    public func exit(enumeration: EnumerationType)
        {
        
        }
    
    public func visit(enumerationCase: EnumerationCase)
        {
        
        }
    
    public func visit(aliasedType: AliasedType)
        {
        
        }
    
    public func visit(type: ArgonType)
        {
        
        }
    
    public func enter(function: FunctionType)
        {
        
        }
    
    public func exit(function: FunctionType)
        {
            
        }
    
    public func visit(constant: Constant)
        {
        
        }
    
    public func visit(variable: Variable)
        {
        
        }
    
    public func visit(slot: Slot)
        {
        
        }
        
    public func visit(block: Block)
        {
        }
        
    public func visit(selectBlock: SelectBlock)
        {
        }
    
    public func visit(tupleExpression: TupleExpression)
        {
        
        }

    public func visit(arrayAccessExpression: ArrayAccessExpression)
        {
        
        }
    
    public func visit(assignmentExpression: AssignmentExpression)
        {
        
        }
    
    public func visit(binaryExpression: BinaryExpression)
        {
        
        }
    
    public func visit(closureExpression: ClosureExpression)
        {
        
        }
    
    public func visit(functionInvocationExpression: FunctionInvocationExpression)
        {
        
        }
    
    public func visit(identifierExpression: IdentifierExpression)
        {
        
        }
    
    public func visit(literalExpression: LiteralExpression)
        {
        
        }
    
    public func visit(makeExpression: MakeExpression)
        {
        
        }
    
    public func visit(memberAccessExpression: MemberAccessExpression)
        {
        
        }
    
    public func visit(methodInvocationExpression: MethodInvocationExpression)
        {
        
        }
    
    public func visit(postfixExpression: PostfixExpression)
        {
        
        }
    
    public func visit(prefixExpression: PrefixExpression)
        {
        
        }
    
    public func visit(ternaryExpression: TernaryExpression)
        {
        
        }
    
    public func visit(forStatement: ForStatement)
        {
        
        }
        
    public func visit(loopStatement: LoopStatement)
        {
        
        }
        
    public func visit(letStatement: LetStatement)
        {
        
        }
        
    public func visit(assignmentStatement: AssignmentStatement)
        {
        
        }
    
    public func visit(forkStatement: ForkStatement)
        {
        
        }

    public func visit(handleStatement: HandleStatement)
        {
        
        }
    
    public func visit(ifStatement: IfStatement)
        {
        
        }
    
    public func visit(repeatStatement: RepeatStatement)
        {
        
        }
    
    public func visit(returnStatement: ReturnStatement)
        {
        
        }
    
    public func visit(selectStatement: SelectStatement)
        {
        
        }
    
    public func visit(signalStatement: SignalStatement)
        {
        
        }
    
    public func visit(timesStatement: TimesStatement)
        {
        
        }
    
    public func visit(whileStatement: WhileStatement)
        {
        
        }
    
    public func visit(staticStatement: StaticStatement)
        {
        
        }
        
    public func lodgeWarning(code: IssueCode, location: Location, message: String?)
        {
        }
    
    public func lodgeError(code: IssueCode, location: Location, message: String?)
        {
        }
    
    public func setNodeKey(_ key: Int?)
        {
        }
    }
