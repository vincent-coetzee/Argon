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
        mutating get
            {
            guard self.compilerIssues.isNotNil else
                {
                self.compilerIssues = self.sourceFileNodes.reduce(CompilerIssues()) { $0 + $1.compilerIssues }
                return(self.compilerIssues!.count)
                }
            return(self.compilerIssues!.count)
            }
        }
        
    private var rootModule: RootModule
    private var macroExpander: MacroExpander!
    private var sourceFileNodes = SourceFileNodes()
    private var compilerIssues: CompilerIssues?
    private var abstractSyntaxTree: SyntaxTreeNode?
    private var wereIssues = false
    
    public init(rootModule: RootModule = RootModule.newRootModule(),sourceFileNodes: SourceFileNodes)
        {
        self.rootModule = rootModule
        self.sourceFileNodes = sourceFileNodes
        }
        
    public mutating func initializeCompiler( ) // STEP 1
        {
        self.wereIssues = false
        self.compilerIssues = CompilerIssues()
        self.abstractSyntaxTree = nil
        self.macroExpander = MacroExpander()
        }
        
    public func expandMacros() // STEP 2
        {
        self.macroExpander.extractMacros(from: self.sourceFileNodes)
        for node in self.sourceFileNodes
            {
            node.expandedSource = node.source
            node.expandedSource = self.macroExpander.expandMacros(in: node.source)
            }
        }
        
    public func scan() // STEP 3
        {
        for node in self.sourceFileNodes
            {
            node.tokens = ArgonScanner(source: node.expandedSource, sourceKey: node.sourceKey).allTokens()
            }
        }
        
    public mutating func parse() // STEP 4
        {
        let parser = ArgonParser(rootModule: self.rootModule)
        parser.setPhase(.declaration)
        for node in self.sourceFileNodes
            {
            node.compilerIssues = CompilerIssues()
            parser.parse(sourceFileNode: node)
            self.wereIssues = node.compilerIssues.count > 0 || self.wereIssues
            }
        parser.setPhase(.application)
        for node in self.sourceFileNodes
            {
            parser.parse(sourceFileNode: node)
            self.wereIssues = node.compilerIssues.count > 0 || self.wereIssues
            }
        }
        
    public func emitCode() // STEP 5
        {
        }
        
    public func link() // STEP 6
        {
        }
        
    public func run() // STEP 7/A
        {
        }
        
    public func debug() // 7/B
        {
        }
    }

public typealias CompilerIssues = Array<CompilerIssue>
