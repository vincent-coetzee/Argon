//
//  IssueReporter.swift
//  Argon
//
//  Created by Vincent Coetzee on 15/10/2023.
//

import Foundation

public protocol IssueReporter
    {
    func lodgeError(code: IssueCode,message: String?,location: Location)
    func lodgeWarning(code: IssueCode,message: String?,location: Location)
    func appendIssue(_ issue: CompilerIssue)
    }
    
extension IssueReporter
    {
    public func lodgeError(code: IssueCode,message: String? = nil,location: Location)
        {
        self.appendIssue(CompilerError(code: code, message: message,location: location))
        }
        
    public func lodgeWarning(code: IssueCode,message: String? = nil,location: Location)
        {
        self.appendIssue(CompilerWarning(code: code, message: message,location: location))
        }
    }
