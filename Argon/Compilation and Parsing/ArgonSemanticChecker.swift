//
//  ArgonSemanticChecker.swift
//  Argon
//
//  Created by Vincent Coetzee on 14/08/2023.
//

import Foundation

public class ArgonSemanticChecker: Visitor
    {
    internal var compilerIssues = CompilerIssues()
    internal var hasMainMethod = false
    
    public var processingFlag: ProcessingFlags
        {
        .kSemanticsChecked
        }
        
    public func lodgeError(code: IssueCode,location: Location,message: String? = nil)
        {
        let error = CompilerError(code: code, message: message,location: location)
        self.compilerIssues.append(error)
        }
        
    public func lodgeWarning(code: IssueCode,location: Location,message: String? = nil)
        {
        let error = CompilerWarning(code: code, message: message,location: location)
        self.compilerIssues.append(error)
        }
        
    public func enter(rootModule: RootModule)
        {
        print("Entering rootModule \(rootModule.name)")
        }
    
    public func exit(rootModule: RootModule)
        {
        print("Exiting rootModule \(rootModule.name)")
        }
        
    public func enter(module: Module)
        {
        print("Entering module \(module.name)")
        }
    
    public func exit(module: Module)
        {
        print("Exiting module \(module.name)")
        }
        
    public func enter(method: MethodType)
        {
        
        }
        
    public func exit(method: MethodType)
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
        
    public func enter(forStatement: ForStatement)
        {
        
        }
    
    public func exit(forStatement: ForStatement)
        {
        
        }
        
    public func enter(loopStatement: LoopStatement)
        {
        
        }
    
    public func exit(loopStatement: LoopStatement)
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
        
    public func checkPrimaryModules(_ modules: Modules)
        {
        let uniqueModules = Array(Set<Module>(modules))
        let mainMethodCount = uniqueModules.reduce(0) { $0 + ($1.hasMainMethod ? 1 : 0) }
        if mainMethodCount > 1
            {
            self.lodgeError(code: .multipleMainMethodsFound,location: Location(nodeKey: -1, line: -1, start: 0, stop: 0))
            }
        self.hasMainMethod = mainMethodCount == 1
        }
    
    }
