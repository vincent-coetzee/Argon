//
//  Compiler.swift
//  Argon
//
//  Created by Vincent Coetzee on 07/04/2023.
//

import Foundation

//
//
// TODO: FIX MACROS
//
//
public struct ArgonCompiler
    {
    internal var rootModule: RootModule
    private var macroExpander: MacroExpander!
    private var sourceFileNodes: SourceFileNodes
    private var sourceRecords = Strings()
    private var compilerIssues = CompilerIssues()
    
    public var compilerIssueCount: Int
        {
        self.compilerIssues.count
        }

    public static func build(nodes: SourceFileNodes) -> ArgonCompiler
        {
        var compiler = Self.init(nodes: nodes)
        compiler.initialize()
        compiler.parse()
        compiler.checkSemantics()
        compiler.checkTypes()
        compiler.emitCode()
        return(compiler)
        }
    
    public init(nodes: SourceFileNodes)
        {
        self.sourceRecords = nodes.map{$0.source}
        self.sourceFileNodes = nodes
        RootModule.reset()
        self.rootModule = RootModule.shared
        }
        
    //
    // STEP 1 in the compilation process
    //
    public mutating func initialize()
        {
//        self.macroExpander = MacroExpander()
//        for record in self.sourceRecords
//            {
//            macroExpander.extractMacros(from: record)
//            }
//        var newSource = Strings()
//        for record in self.sourceRecords
//            {
//            newSource.append(self.macroExpander.expandMacros(in: record))
//            }
//        self.sourceRecords = newSource
        }
    //
    // STEP 2 in the compilation process
    //
    public mutating func parse() // STEP 2
        {
        let parser = ArgonParser()
        let scanner = ArgonScanner(source: "")
        var index = 0
        for record in self.sourceRecords
            {
            parser.resetParser()
            scanner.resetScanner(source: record)
            let node = self.sourceFileNodes[index]
            node.compilerIssues = CompilerIssues()
            parser.nodeKey = node.nodeKey
            if let issues = parser.parse(tokens: scanner.allTokens())
                {
                node.compilerIssues = issues
                self.compilerIssues.append(contentsOf: issues)
                }
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

