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
        compiler.emitCode()
        return(compiler)
        }
        
    private var rootModule: RootModule
    private var macroExpander: MacroExpander!
    private var sourceFileNodes: SourceFileNodes
    private var compilerIssues = CompilerIssues()
    private var abstractSyntaxTree: SyntaxTreeNode?
    private var wereIssues = false
    private var issueCount = 0
    
    public init(nodes: SourceFileNodes)
        {
        self.sourceFileNodes = nodes
        self.rootModule = RootModule.newRootModule()
        self.rootModule.flush()
        }
        
    public mutating func initialize() // STEP 1
        {
        self.wereIssues = false
        self.abstractSyntaxTree = nil
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
        let parser = ArgonParser(rootModule: self.rootModule)
        self.issueCount = 0
        for node in self.sourceFileNodes
            {
            node.compilerIssues = CompilerIssues()
            parser.nodeKey = node.nodeKey
            parser.parse(sourceFileNode: node)
            node.compilerIssues = parser.compilerIssues(forNodeKey: node.nodeKey)
            if node.compilerIssues.count != parser.allCompilerIssues().count
                {
                print("halt")
                }
            self.wereIssues = node.compilerIssues.count > 0 || self.wereIssues
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
        
    public func checkSemantics()
        {
        let checker = ArgonSemanticChecker()
        for node in self.sourceFileNodes
            {
            node.module.accept(visitor: checker)
            }
        }
    }

public typealias CompilerIssues = Array<CompilerIssue>
