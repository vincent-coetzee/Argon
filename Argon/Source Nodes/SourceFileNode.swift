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
        
    public override var compilerIssues: CompilerIssues
        {
        get
            {
            self._compilerIssues
            }
        set
            {
            self._compilerIssues = newValue
            }
        }
        
    public private(set) var source: String
    public var expandedSource: String
    private var _compilerIssues = CompilerIssues()
    public var tokens = Tokens()
    public var module: Module!
    
    public init(name: String,path: Path,source: String = "")
        {
        self.source = source
        self.expandedSource = ""
        super.init(name: name,path: path)
        }
        
    public required init?(coder: NSCoder)
        {
        self.source = coder.decodeObject(forKey: "source") as! String
        self.expandedSource = coder.decodeObject(forKey: "expandedSource") as! String
        self.tokens = coder.decodeObject(forKey: "tokens") as! Tokens
        self._compilerIssues = coder.decodeObject(forKey: "compilerIssues") as! CompilerIssues
        self.module = coder.decodeObject(forKey: "module") as? Module
        super.init(coder: coder)
        self.expandedSource = self.source
        }
        
    public override func encode(with coder: NSCoder)
        {
        coder.encode(self.source,forKey: "source")
        coder.encode(self.expandedSource,forKey: "expandedSource")
        coder.encode(self.tokens,forKey: "tokens")
        coder.encode(self._compilerIssues,forKey: "compilerIssues")
        coder.encode(self.module,forKey: "module")
        super.encode(with: coder)
        }
        
    public override var projectViewImage: NSImage
        {
        NSImage(named: "IconSourceFile")!
        }
        
    public override func setSource(_ string: String)
        {
        self.source = string
        }
        
    public override func setTokens(_ tokens: Tokens)
        {
        self.tokens = tokens
        }
        
    public func append(compilerIssues issues: CompilerIssues)
        {
        self.compilerIssues.append(contentsOf: issues)
        }
    }
    
public typealias SourceFileNodes = Array<SourceFileNode>