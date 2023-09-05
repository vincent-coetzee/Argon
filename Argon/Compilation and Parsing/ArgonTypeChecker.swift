//
//  ArgonTypeChecker.swift
//  Argon
//
//  Created by Vincent Coetzee on 04/09/2023.
//

import Foundation

public class ArgonTypeChecker: Visitor
    {
    public var processingFlag: ProcessingFlags
        {
        .kTypeChecked
        }
        
    public func enter(module: Module)
        {
        print("Entering module \(module.name)")
        }
    
    public func exit(module: Module)
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
    
    public func visit(type: TypeNode)
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
    
    public func visit(tupleType: TupleType)
        {
        
        }
    
    public func visit(genericTypeInstance: GenericTypeInstance)
        {
        
        }
    
    public func visit(arrayTypeInstance: ArrayTypeInstance)
        {
        
        }
    
    public func visit(dictionaryInstance: DictionaryInstance)
        {
        
        }
    
    public func visit(listInstance: ListInstance)
        {
        
        }
    
    public func visit(setInstance: SetInstance)
        {
        
        }
    
    public func visit(bitSetInstance: BitSetInstance)
        {
        
        }
    
    public func visit(argument: Argument)
        {
        
        }
    
    public func visit(parameter: Parameter)
        {
        
        }
    
    public func visit(expression: Expression)
        {
        
        }
    
    public func enter(arrayAccessExpression: ArrayAccessExpression)
        {
        
        }
    
    public func exit(arrayAccessExpression: ArrayAccessExpression)
        {
        
        }
    
    public func enter(assignmentExpression: AssignmentExpression)
        {
        
        }
    
    public func exit(assignmentExpression: AssignmentExpression)
        {
        
        }
    
    public func enter(binaryExpression: BinaryExpression)
        {
        
        }
    
    public func exit(binaryExpression: BinaryExpression)
        {
        
        }
    
    public func enter(closureExpression: ClosureExpression)
        {
        
        }
    
    public func exit(closureExpression: ClosureExpression)
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
    
    public func enter(memberAccessExpression: MemberAccessExpression)
        {
        
        }
    
    public func exit(memberAccessExpression: MemberAccessExpression)
        {
        
        }
    
    public func visit(methodInvocationExpression: MethodInvocationExpression)
        {
        
        }
    
    public func enter(postfixExpression: PostfixExpression)
        {
        
        }
    
    public func exit(postfixExpression: PostfixExpression)
        {
        
        }
    
    public func enter(prefixExpression: PrefixExpression)
        {
        
        }
    
    public func exit(prefixExpression: PrefixExpression)
        {
        
        }
    
    public func enter(ternaryExpression: TernaryExpression)
        {
        
        }
    
    public func exit(ternaryExpression: TernaryExpression)
        {
        
        }
    
    public func enter(block: Block)
        {
        
        }
    
    public func exit(block: Block)
        {
        
        }
    
    public func enter(statement: Statement)
        {
        
        }
    
    public func exit(statement: Statement)
        {
        
        }
    
    public func enter(assignmentStatement: AssignmentStatement)
        {
        
        }
    
    public func exit(assignmentStatement: AssignmentStatement)
        {
        
        }
    
    public func enter(forkStatement: ForkStatement)
        {
        
        }
    
    public func exit(forkStatement: ForkStatement)
        {
        
        }
    
    public func enter(handleStatement: HandleStatement)
        {
        
        }
    
    public func exit(handleStatement: HandleStatement)
        {
        
        }
    
    public func enter(ifStatement: IfStatement)
        {
        
        }
    
    public func exit(ifStatement: IfStatement)
        {
        
        }
    
    public func enter(letStatement: LetStatement)
        {
        
        }
    
    public func exit(letStatement: LetStatement)
        {
        
        }
    
    public func enter(repeatStatement: RepeatStatement)
        {
        
        }
    
    public func exit(repeatStatement: RepeatStatement)
        {
        
        }
    
    public func enter(returnStatement: ReturnStatement)
        {
        
        }
    
    public func exit(returnStatement: ReturnStatement)
        {
        
        }
    
    public func enter(selectStatement: SelectStatement)
        {
        
        }
    
    public func exit(selectStatement: SelectStatement)
        {
        
        }
    
    public func enter(selectBlock: SelectBlock)
        {
        
        }
    
    public func exit(selectBlock: SelectBlock)
        {
        
        }
    
    public func enter(signalStatement: SignalStatement)
        {
        
        }
    
    public func exit(signalStatement: SignalStatement)
        {
        
        }
    
    public func enter(timesStatement: TimesStatement)
        {
        
        }
    
    public func exit(timesStatement: TimesStatement)
        {
        
        }
    
    public func enter(whileStatement: WhileStatement)
        {
        
        }
    
    public func exit(whileStatement: WhileStatement)
        {
        
        }
    
    public func enter(staticStatement: StaticStatement)
        {
        
        }
    
    public func exit(staticStatement: StaticStatement)
        {
        
        }
    }
