//
//  ASTVisitor.swift
//  Argon
//
//  Created by Vincent Coetzee on 14/08/2023.
//

import Foundation

public protocol Visitor
    {
    var processingFlag: ProcessingFlags { get }
    
    func wasNotVisited(_ symbol: Symbol) -> Bool
    func markAsVisited(_ symbol: Symbol)
    func enter(rootModule: RootModule)
    func exit(rootModule: RootModule)
    func enter(module: ModuleType)
    func exit(module: ModuleType)
    func enter(class: ClassType)
    func exit(class: ClassType)
    func enter(enumeration: EnumerationType)
    func exit(enumeration: EnumerationType)
    func visit(enumerationCase: EnumerationCase)
    func visit(aliasedType: AliasedType)
    func visit(type: ArgonType)
    func enter(function: FunctionType)
    func exit(function: FunctionType)
    func enter(method: MethodType)
    func exit(method: MethodType)
    func visit(constant: Constant)
    func visit(variable: Variable)
    func visit(slot: Slot)
    
    func visit(arrayAccessExpression: ArrayAccessExpression)
    func visit(assignmentExpression: AssignmentExpression)
    func visit(binaryExpression: BinaryExpression)
    func visit(closureExpression: ClosureExpression)
    func visit(functionInvocationExpression: FunctionInvocationExpression)
    func visit(identifierExpression: IdentifierExpression)
    func visit(literalExpression: LiteralExpression)
    func visit(makeExpression: MakeExpression)
    func visit(memberAccessExpression: MemberAccessExpression)
    func visit(methodInvocationExpression: MethodInvocationExpression)
    func visit(postfixExpression: PostfixExpression)
    func visit(prefixExpression: PrefixExpression)
    func visit(ternaryExpression: TernaryExpression)
    func visit(tupleExpression: TupleExpression)
    
    func visit(block: Block)
    func visit(selectBlock: SelectBlock)
    func visit(assignmentStatement: AssignmentStatement)
    func visit(forkStatement: ForkStatement)
    func visit(handleStatement: HandleStatement)
    func visit(ifStatement: IfStatement)
    func visit(letStatement: LetStatement)
    func visit(repeatStatement: RepeatStatement)
    func visit(returnStatement: ReturnStatement)
    func visit(selectStatement: SelectStatement)
    func visit(signalStatement: SignalStatement)
    func visit(timesStatement: TimesStatement)
    func visit(whileStatement: WhileStatement)
    func visit(staticStatement: StaticStatement)
    func visit(forStatement: ForStatement)
    func visit(loopStatement: LoopStatement)
    
    func lodgeWarning(code: IssueCode,location: Location,message: String?)
    func lodgeError(code: IssueCode,location: Location,message: String?)
    }

public protocol Visitable
    {
    func accept(visitor: Visitor)
    }
