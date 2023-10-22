//
//  Compiler.swift
//  Argon
//
//  Created by Vincent Coetzee on 07/04/2023.
//

import Foundation

public struct ArgonCompiler
    {
    public var compilerIssueCount: Int
        {
        self.compilerIssues.count
        }
        
    public static func parse(nodes: SourceFileNodes)
        {
        var compiler = Self.init(nodes: nodes)
        compiler.initialize()
        compiler.scan()
        compiler.parse()
        }
        
    public static func build(nodes: SourceFileNodes) -> ArgonCompiler
        {
        var compiler = Self.init(nodes: nodes)
        compiler.initialize()
        compiler.scan()
        compiler.parse()
        compiler.checkSemantics()
        compiler.checkTypes()
        compiler.emitCode()
        return(compiler)
        }
        
    internal var rootModule: RootModule
    private var macroExpander: MacroExpander!
    private var sourceFileNodes: SourceFileNodes
    private var compilerIssues = CompilerIssues()
//    private var abstractSyntaxTree: SyntaxTreeNode?
//    private var wereIssues = false
    
    public init(nodes: SourceFileNodes)
        {
        self.sourceFileNodes = nodes
        RootModule.reset()
        self.rootModule = RootModule.shared
        }
        
    public mutating func initialize() // STEP 1
        {
//        self.wereIssues = false
//        self.abstractSyntaxTree = nil
        self.macroExpander = MacroExpander()
        self.macroExpander.processMacros(in: self.sourceFileNodes)
        }
        
    public func scan() // STEP 2
        {
        for node in self.sourceFileNodes
            {
            node.tokens = ArgonScanner(source: node.expandedSource).allTokens()
            }
        }
        
    public mutating func parse() // STEP 3
        {
        let parser = ArgonParser()
        for node in self.sourceFileNodes
            {
            parser.resetParser()
            node.compilerIssues = CompilerIssues()
            parser.nodeKey = node.nodeKey
            parser.parse(sourceFileNode: node)
            node.compilerIssues = parser.compilerIssues(forNodeKey: node.nodeKey)
            parser.setModule(forNode: node)
            if node.compilerIssues.count != parser.allCompilerIssues().count
                {
                print("halt")
                }
//            self.wereIssues = node.compilerIssues.count > 0 || self.wereIssues
            self.compilerIssues.append(contentsOf: node.compilerIssues)
            }
        }
        
    public func emitCode() // STEP 4
        {
        }
        
    public func link() // STEP 5
        {
        }
        
    public func run() // STEP 6/A
        {
        }
        
    public func debug() // STEP 6/B
        {
        }
        
    public mutating func checkSemantics()
        {
        let checker = ArgonSemanticChecker()
        let modules = self.rootModule.subModules
        checker.checkPrimaryModules(modules)
        self.rootModule.accept(visitor: checker)
        self.compilerIssues.append(contentsOf: checker.compilerIssues)
        }
        
    public mutating func checkTypes()
        {
        let checker = ArgonTypeChecker()
        checker.assignTypes(to: self.rootModule)
        checker.defineTypeConstraints(for: self.rootModule)
        checker.unifyConstraints()
        checker.assignInferredTypes(to: self.rootModule)
        self.compilerIssues.append(contentsOf: checker.compilerIssues)
        }
    }

