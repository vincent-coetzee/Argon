//
//  ErrorToken.swift
//  Argon
//
//  Created by Vincent Coetzee on 01/01/2023.
//

import Foundation

public class ErrorToken: Token
    {
    public override var styleElement: StyleElement
        {
        .colorIssue
        }
        
    public override var tokenType: TokenType
        {
        .error
        }
        
    public override var tokenName: String
        {
        "ErrorToken"
        }
        
    public let issue: CompilerIssue
    
    init(location: Location,code: IssueCode,message: String)
        {
        self.issue = CompilerIssue(code: code, message: message)
        super.init(location: location,string: "")
        }
        
    public required init(location: Location,string: String)
        {
        self.issue = CompilerIssue(code: .none, message: "")
        super.init(location: location,string: string)
        }
        
    public required init(coder: NSCoder)
        {
        self.issue = coder.decodeObject(forKey: "issue") as! CompilerIssue
        super.init(coder: coder)
        }
        
    public override func encode(with coder: NSCoder)
        {
        coder.encode(self.issue,forKey: "issue")
        super.encode(with: coder)
        }
    }
