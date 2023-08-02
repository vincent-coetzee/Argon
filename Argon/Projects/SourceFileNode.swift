//
//  SourceFile.swift
//  Argon
//
//  Created by Vincent Coetzee on 18/02/2023.
//

import Cocoa
import Path

public class SourceFileNode: SourceNode
    {
    public var hasErrors: Bool
        {
        self.compilerIssues.detect { $0.isError }
        }
        
    public override var filename: String
        {
        return("\(self.name).argon")
        }
        
    public override var isSourceFileNode: Bool
        {
        true
        }
        
    public override var title: String
        {
        self.name + ".argon"
        }
        
    public var source: String
    public var expandedSource: String
    public var compilerIssues = CompilerIssues()
    public var tokens = Tokens()
    public var astNode: SyntaxTreeNode?
    
    public init(name: String,path: Path,source: String = "")
        {
        self.source = source
        self.expandedSource = ""
        super.init(name: name,path: path)
        }
        
    public required init?(coder: NSCoder)
        {
        print("SourceFileNode.init")
        self.source = coder.decodeObject(forKey: "source") as! String
        self.expandedSource = coder.decodeObject(forKey: "expandedSource") as! String
        self.tokens = coder.decodeObject(forKey: "tokens") as! Tokens
        self.compilerIssues = coder.decodeObject(forKey: "compilerIssues") as! CompilerIssues
        super.init(coder: coder)
        }
        
    public override func encode(with coder: NSCoder)
        {
        coder.encode(self.source,forKey: "source")
        coder.encode(self.expandedSource,forKey: "expandedSource")
        coder.encode(self.tokens,forKey: "tokens")
        coder.encode(self.compilerIssues,forKey: "compilerIssues")
        super.encode(with: coder)
        }
        
    public override var projectViewImage: NSImage
        {
        NSImage(named: "IconSourceFile")!
        }
    }
    
public typealias SourceFileNodes = Array<SourceFileNode>
