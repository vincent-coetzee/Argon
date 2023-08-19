//
//  ASTVisitor.swift
//  Argon
//
//  Created by Vincent Coetzee on 14/08/2023.
//

import Foundation

public protocol Visitor
    {
    func enter(module: Module)
    func exit(module: Module)
    func enter(class: Class)
    func exit(class: Class)
    func enter(enumeration: Enumeration)
    func exit(enumeration: Enumeration)
    func visit(enumerationCase: EnumerationCase)
    func visit(aliasedType: AliasedType)
    func visit(type: TypeNode)
    func enter(function: Function)
    func exit(function: Function)
    func visit(constant: Constant)
    func visit(variable: Variable)
    func visit(slot: Slot)
    func visit(tupleType: TupleType)
    func visit(genericTypeInstance: GenericTypeInstance)
    func visit(arrayTypeInstance: ArrayTypeInstance)
    func visit(dictionaryInstance: DictionaryInstance)
    func visit(listInstance: ListInstance)
    func visit(setInstance: SetInstance)
    func visit(bitSetInstance: BitSetInstance)
    
    func visit(argument: Argument)
    func visit(parameter: Parameter)
    func visit(expression: Expression)
    func enter(arrayAccessExpression: ArrayAccessExpression)
    func exit(arrayAccessExpression: ArrayAccessExpression)
    func enter(assignmentExpression: AssignmentExpression)
    func exit(assignmentExpression: AssignmentExpression)
    func enter(binaryExpression: BinaryExpression)
    func exit(binaryExpression: BinaryExpression)
    func enter(closureExpression: ClosureExpression)
    func exit(closureExpression: ClosureExpression)
    func visit(functionInvocationExpression: FunctionInvocationExpression)
    func visit(identifierExpression: IdentifierExpression)
    func visit(literalExpression: LiteralExpression)
    func visit(makeExpression: MakeExpression)
    func enter(memberAccessExpression: MemberAccessExpression)
    func exit(memberAccessExpression: MemberAccessExpression)
    func visit(methodInvocationExpression: MethodInvocationExpression)
    func enter(postfixExpression: PostfixExpression)
    func exit(postfixExpression: PostfixExpression)
    func enter(prefixExpression: PrefixExpression)
    func exit(prefixExpression: PrefixExpression)
    func enter(ternaryExpression: TernaryExpression)
    func exit(ternaryExpression: TernaryExpression)
    
    func enter(block: Block)
    func exit(block: Block)
    func enter(statement: Statement)
    func exit(statement: Statement)
    func enter(assignmentStatement: AssignmentStatement)
    func exit(assignmentStatement: AssignmentStatement)
    func enter(forkStatement: ForkStatement)
    func exit(forkStatement: ForkStatement)
    func enter(handleStatement: HandleStatement)
    func exit(handleStatement: HandleStatement)
    func enter(ifStatement: IfStatement)
    func exit(ifStatement: IfStatement)
    func enter(letStatement: LetStatement)
    func exit(letStatement: LetStatement)
    func enter(repeatStatement: RepeatStatement)
    func exit(repeatStatement: RepeatStatement)
    func enter(returnStatement: ReturnStatement)
    func exit(returnStatement: ReturnStatement)
    func enter(selectStatement: SelectStatement)
    func exit(selectStatement: SelectStatement)
    func enter(selectBlock: SelectBlock)
    func exit(selectBlock: SelectBlock)
    func enter(signalStatement: SignalStatement)
    func exit(signalStatement: SignalStatement)
    func enter(timesStatement: TimesStatement)
    func exit(timesStatement: TimesStatement)
    func enter(whileStatement: WhileStatement)
    func exit(whileStatement: WhileStatement)
    func enter(staticStatement: StaticStatement)
    func exit(staticStatement: StaticStatement)
    }

public protocol Visitable
    {
    func accept(visitor: Visitor)
    }
