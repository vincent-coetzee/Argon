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
    internal var visitedSymbols = Set<Identifier>()
    
    public var processingFlag: ProcessingFlags
        {
        .semanticsChecked
        }
        
    public func wasNotVisited(_ symbol: Symbol) -> Bool
        {
        !self.visitedSymbols.contains(symbol.identifier)
        }
        
    public func markAsVisited(_ symbol: Symbol)
        {
        self.visitedSymbols.insert(symbol.identifier)
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
        }
    
    public func exit(rootModule: RootModule)
        {
        }
        
    public func enter(module: ModuleType)
        {
        print("Entering module \(module.name)")
        }
    
    public func exit(module: ModuleType)
        {
        module.validateMethodUniqueness(semanticChecker: self)
        }
        
    public func enter(method: MethodType)
        {
        
        }
        
    public func exit(method: MethodType)
        {
        }
    
    public func enter(class someClass: ClassType)
        {
        guard self.wasNotVisited(someClass) else
            {
            return
            }
        self.markAsVisited(someClass)
        let parentSlots = someClass.superclassSlots()
        for slot in someClass.slots
            {
            for parentSlot in parentSlots
                {
                if parentSlot.name == slot.name
                    {
                    self.lodgeError(code: .duplicateSlot, location: slot.location,message: "Class '\(someClass.name)' defines slot with name '\(slot.name)' which is already defined in '\(someClass.name)''s superclasses.")
                    }
                }
            }
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
        
    public func visit(block: Block)
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
        
    public func visit(tupleExpression: TupleExpression)
        {
        
        }
    
    public func visit(expression: Expression)
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
        guard self.wasNotVisited(makeExpression) else
            {
            return
            }
        self.markAsVisited(makeExpression)
        if makeExpression.typeNode.isErrorType
            {
            self.lodgeError(code: .makeExpectsTypeToMake,location: makeExpression.location!,message: "MAKE expects a type to make but found '\(makeExpression.typeNode.name)'.")
            return
            }
        guard makeExpression.typeNode.isMakeable else
            {
            self.lodgeError(code: .makeableTypeExpected,location: makeExpression.location!,message: "The type '\(makeExpression.typeNode.name)' is not makeable.")
            return
            }
        }
    
    public func visit(memberAccessExpression: MemberAccessExpression)
        {
        guard self.wasNotVisited(memberAccessExpression) else
            {
            return
            }
        self.markAsVisited(memberAccessExpression)
        
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

    public func visit(assignmentStatement: AssignmentStatement)
        {
        
        }

    public func visit(forkStatement: ForkStatement)
        {
        
        }
        
    public func visit(forStatement: ForStatement)
        {
        
        }
        
    public func visit(loopStatement: LoopStatement)
        {
        
        }
    
    public func visit(handleStatement: HandleStatement)
        {
        
        }
    
    public func visit(ifStatement: IfStatement)
        {
        
        }

    public func visit(letStatement: LetStatement)
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
    
    public func visit(selectBlock: SelectBlock)
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
        
    public func checkPrimaryModules(_ modules: ModuleTypes)
        {
        let uniqueModules = Array(Set<ModuleType>(modules))
        let mainMethodCount = uniqueModules.reduce(0) { $0 + ($1.hasMainMethod ? 1 : 0) }
        if mainMethodCount > 1
            {
            self.lodgeError(code: .multipleMainMethodsFound,location: Location(nodeKey: -1, line: -1, start: 0, stop: 0))
            }
        self.hasMainMethod = mainMethodCount == 1
        }
    }
