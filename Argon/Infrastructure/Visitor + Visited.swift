//
//  ASTVisitor.swift
//  Argon
//
//  Created by Vincent Coetzee on 14/08/2023.
//

import Foundation

public protocol Visitor
    {
    func visit(module: Module)
    func visit(class: Class)
    func visit(enumeration: Enumeration)
    func visit(enumerationCase: EnumerationCase)
    func visit(aliasedType: AliasedType)
    func visit(type: TypeNode)
    func visit(function: Function)
    func visit(constant: Constant)
    func visit(variable: Variable)
    func visit(slot: Slot)
    func visit(tupleType: TupleType)
    func visit(genericTypeInstance: GenericTypeInstance)
    func visit(arrayTypeInstance: ArrayTypeInstance)
    
    func visit(argument: Argument)
    func visit(expression: Expression)
    func visit(arrayAccessExpression: ArrayAccessExpression)
    func visit(assignmentExpression: AssignmentExpression)
    func visit(binaryExpression: BinaryExpression)
    func visit(closureExpression: ClosureExpression)
    func visit(functionInvocationExpression: FunctionInvocationExpression)
    func visit(identifierExpression: IdentifierExpression)
    func visit(literalExpression: LiteralExpression)
    func visit(makeInvocationExpression: MakeInvocationExpression)
    func visit(memberAccessExpression: MemberAccessExpression)
    func visit(methodInvocationExpression: MethodInvocationExpression)
    func visit(postfixExpression: PostfixExpression)
    func visit(prefixExpression: PrefixExpression)
    func visit(ternaryExpression: TernaryExpression)
    
    func visit(block: Block)
    func visit(statement: Statement)
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
    func visit(selectBlock: SelectBlock)
    }

public protocol Visited
    {
    func accept(visitor: Visitor)
    }
