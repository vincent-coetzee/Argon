//
//  BracketLocator.swift
//  Argon
//
//  Created by Vincent Coetzee on 22/09/2023.
//

import Foundation

//
//
// BracketMatcher is used by the source code editor to display matching brackets ( square, parentheses, brockets and braces ) as
// the cursor traverses them. When processing the tokens BracketMatcher assumes it is receiving tokens in the same order
// as they appear in the source. Bracket locations are stored as bracketKind(startLocation,stopLocation). A BracketMatcher is
// created as the ArgonScanner traverses the source and is passed out to the SourceView which hangs on to the instance of
// BracketMatcher and uses it to locate brackets until a new BracketMatcher is received from the next traversal of the
// source by a fresh ArgonScanner. Internally the BracketMatcher stores the matches in a Dictionary keyed by offset (i.e. the start
// position of a Location ). The Dictionary is keyed on both the start and stop locations so that the match can be found from
// both the start and stop offsets.
//
//

public class BracketMatcher
    {
    public enum BracketKind
        {
        case square
        case brace
        case brocket
        case parenthesis
        }
        
    private enum BracketMatch
        {
        public var start: Location
            {
            switch(self)
                {
                case(.square(let left,_)):
                    return(left)
                case(.brace(let left,_)):
                    return(left)
                case(.brocket(let left,_)):
                    return(left)
                case(.parenthesis(let left,_)):
                    return(left)
                }
            }
            
        public var stop: Location
            {
            switch(self)
                {
                case(.square(_,let right)):
                    return(right)
                case(.brace(_,let right)):
                    return(right)
                case(.brocket(_,let right)):
                    return(right)
                case(.parenthesis(_,let right)):
                    return(right)
                }
            }
            
        public var locations: (Location,Location)
            {
            switch(self)
                {
                case(.square(let left,let right)):
                    return(left,right)
                case(.brace(let left,let right)):
                    return(left,right)
                case(.brocket(let left,let right)):
                    return(left,right)
                case(.parenthesis(let left,let right)):
                     return(left,right)
                }
            }
            
        case square(Location,Location)
        case brace(Location,Location)
        case brocket(Location,Location)
        case parenthesis(Location,Location)
        
        public func isKind(_ kind: BracketKind) -> Bool
            {
            switch(self,kind)
                {
                case(.square,.square):
                    return(true)
                case(.brace,.brace):
                    return(true)
                case(.brocket,.brocket):
                    return(true)
                case(.parenthesis,.parenthesis):
                    return(true)
                default:
                    return(false)
                }
            }
        }
        
    private let parentheses = Stack<Location>()
    private let braces = Stack<Location>()
    private let squares = Stack<Location>()
    private let brockets = Stack<Location>()
    
    private var matches = Dictionary<Int,BracketMatch>()
    
    public func processToken(_ token: Token)
        {
        guard token.isKindOfBracket else
            {
            return
            }
        if token.isLeftParenthesis
            {
            self.parentheses.push(token.location)
            return
            }
        if token.isLeftBrace
            {
            self.braces.push(token.location)
            return
            }
        if token.isLeftBracket
            {
            self.squares.push(token.location)
            return
            }
        if token.isLeftBrocket
            {
            self.brockets.push(token.location)
            return
            }
        if token.isRightParenthesis
            {
            if let lastLocation = self.parentheses.popOrNil()
                {
                let match = BracketMatch.parenthesis(lastLocation,token.location)
                self.matches[lastLocation.start] = match
                self.matches[token.location.start] = match
                }
            return
            }
        if token.isRightBracket
            {
            if let lastLocation = self.squares.popOrNil()
                {
                let match = BracketMatch.square(lastLocation,token.location)
                self.matches[lastLocation.start] = match
                self.matches[token.location.start] = match
                }
            return
            }
        if token.isRightBrace
            {
            if let lastLocation = self.braces.popOrNil()
                {
                let match = BracketMatch.brace(lastLocation,token.location)
                self.matches[lastLocation.start] = match
                self.matches[token.location.start] = match
                }
            return
            }
        if token.isRightBrocket
            {
            if let lastLocation = self.brockets.popOrNil()
                {
                let match = BracketMatch.brocket(lastLocation,token.location)
                self.matches[lastLocation.start] = match
                self.matches[token.location.start] = match
                }
            }
        }
        
    public func locateMatch(for kind: BracketKind,at offset: Int) -> (Location,Location)?
        {
        if let match = self.matches[offset],match.isKind(kind)
            {
            return(match.locations)
            }
        return(nil)
        }
    }
