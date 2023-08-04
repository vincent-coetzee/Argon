//
//  OperatorToken.swift
//  Argon
//
//  Created by Vincent Coetzee on 31/12/2022.
//

import Foundation

public class OperatorToken: Token
    {
    public override var isExpressionRelatedToken: Bool
        {
        true
        }
        
    public override var styleElement: StyleElement
        {
        .colorOperator
        }
        
    public override var isOperator: Bool
        {
        true
        }
        
    public var isUnaryOperator: Bool
        {
        return(false)
        }
        
    public override var `operator`: Operator
        {
        Operator(tokenType: self.tokenType, precedence: self.precedence)
        }
        
    public override var tokenType: TokenType
        {
        switch(self.matchString)
            {
            case("?"):
                return(.ternary)
            case(")"):
                return(.rightParenthesis)
            case("("):
                return(.leftParenthesis)
            case("]"):
                return(.rightBracket)
            case("["):
                return(.leftBracket)
            case("}"):
                return(.rightBrace)
            case("{"):
                return(.leftBrace)
            case(","):
                return(.comma)
            case("->"):
                return(.rightArrow)
            case("!"):
                return(.booleanNot)
            case("~"):
                return(.logicalNot)
            case("-"):
                return(.minus)
            case("++"):
                return(.increment)
            case("--"):
                return(.decrement)
            case("+"):
                return(.plus)
            case("*"):
                return(.times)
            case("/"):
                return(.divide)
            case("**"):
                return(.power)
            case("%"):
                return(.percent)
            case(">"):
                return(.greaterThan)
            case("<"):
                return(.lessThan)
            case(">="):
                return(.greaterThanEquals)
            case("<="):
                return(.lessThanEquals)
            case("=="):
                return(.logicalEquals)
            case("<<"):
                return(.shiftLeft)
            case(">>"):
                return(.shiftRight)
            case("+="):
                return(.plusAssign)
            case("-="):
                return(.minusAssign)
            case("*="):
                return(.timesAssign)
            case("/="):
                return(.divideAssign)
            case("<<="):
                return(.shiftLeftAssign)
            case(">>="):
                return(.shiftRightAssign)
            case("&&"):
                return(.booleanAnd)
            case("||"):
                return(.booleanOr)
            case("&&="):
                return(.booleanAndAssign)
            case("||="):
                return(.booleanOr)
            case("&="):
                return(.logicalAndAssign)
            case("|="):
                return(.logicalOrAssign)
            case("^="):
                return(.logicalXorAssign)
            case("~="):
                return(.logicalNotAssign)
            case("&"):
                return(.booleanAnd)
            case("|"):
                return(.booleanOr)
            case("^"):
                return(.logicalXor)
            case("^="):
                return(.logicalXorAssign)
            case("::"):
                return(.scope)
            case(":"):
                return(.colon)
            case("="):
                return(.assign)
            case("=="):
                return(.equals)
            default:
                fatalError("Operator for \(self.matchString) is not defined.")
            }
        }
        
    public override var isMinus: Bool
        {
        self.matchString == "-"
        }
        
    public override var isLeftBrocket: Bool
        {
        self.matchString == "<"
        }
        
    public override var isRightBrocket: Bool
        {
        self.matchString == ">"
        }
        
    public override var isLeftParenthesis: Bool
        {
        self.matchString == "("
        }
        
    public override var isRightBracket: Bool
        {
        self.matchString == "]"
        }
        
    public override var isLeftBracket: Bool
        {
        self.matchString == "["
        }
        
    public override var isRangeOperator: Bool
        {
        self.matchString == ".."
        }
        
    public override var isRightParenthesis: Bool
        {
        self.matchString == ")"
        }
        
    public override var tokenName: String
        {
        "OperatorToken"
        }
        
    public override var isAssign: Bool
        {
        self.matchString == "="
        }
        
    public override var isEquals: Bool
        {
        self.matchString == "=="
        }
        
    public override var isScope: Bool
        {
        self.matchString == "::"
        }
        
    public override var isLeftBrace: Bool
        {
        return(self.matchString == "{")
        }
        
    public override var isRightBrace: Bool
        {
        return(self.matchString == "}")
        }
    }
