//------------------------------------------------------------------------------
/// @brief SnuPL/0 parser
/// @author Bernhard Egger <bernhard@csap.snu.ac.kr>
/// @section changelog Change Log
/// 2012/09/14 Bernhard Egger created
/// 2013/03/07 Bernhard Egger adapted to SnuPL/0
/// 2016/03/09 Bernhard Egger adapted to SnuPL/!
/// 2016/04/08 Bernhard Egger assignment 2: parser for SnuPL/-1
///
/// @section license_section License
/// Copyright (c) 2012-2016, Bernhard Egger
/// All rights reserved.
///
/// Redistribution and use in source and binary forms,  with or without modifi-
/// cation, are permitted provided that the following conditions are met:
///
/// - Redistributions of source code must retain the above copyright notice,
///   this list of conditions and the following disclaimer.
/// - Redistributions in binary form must reproduce the above copyright notice,
///   this list of conditions and the following disclaimer in the documentation
///   and/or other materials provided with the distribution.
///
/// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
/// AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING,  BUT NOT LIMITED TO,  THE
/// IMPLIED WARRANTIES OF MERCHANTABILITY  AND FITNESS FOR A PARTICULAR PURPOSE
/// ARE DISCLAIMED.  IN NO EVENT SHALL THE COPYRIGHT HOLDER  OR CONTRIBUTORS BE
/// LIABLE FOR ANY DIRECT,  INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSE-
/// QUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF  SUBSTITUTE
/// GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
/// HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN  CONTRACT, STRICT
/// LIABILITY, OR TORT  (INCLUDING NEGLIGENCE OR OTHERWISE)  ARISING IN ANY WAY
/// OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH
/// DAMAGE.
//------------------------------------------------------------------------------

#ifndef __SnuPL_PARSER_H__
#define __SnuPL_PARSER_H__

#include "scanner.h"
#include "symtab.h"
#include "ast.h"


//------------------------------------------------------------------------------
/// @brief parser
///
/// parses a module
///
class CParser {
  public:
    /// @brief constructor
    ///
    /// @param scanner  CScanner from which the input stream is read
    CParser(CScanner *scanner);

    /// @brief parse a module
    /// @retval CAstNode program node
    CAstNode* Parse(void);

    /// @name error handling
    ///@{

    /// @brief indicates whether there was an error while parsing the source
    /// @retval true if the parser detected an error
    /// @retval false otherwise
    bool HasError(void) const { return _abort; };

    /// @brief returns the token that caused the error
    /// @retval CToken containing the error token
    const CToken* GetErrorToken(void) const;

    /// @brief returns a human-readable error message
    /// @retval error message
    string GetErrorMessage(void) const;
    ///@}

  private:
    /// @brief sets the token causing a parse error along with a message
    /// @param t token causing the error
    /// @param message human-readable error message
    void SetError(CToken t, const string message);

    /// @brief consume a token given type and optionally store the token
    /// @param type expected token type
    /// @param token If not null, the consumed token is stored in 'token'
    /// @retval true if a token has been consumed
    /// @retval false otherwise
    bool Consume(EToken type, CToken *token=NULL);


    /// @brief initialize symbol table @a s with predefined procedures and
    ///        global variables
    void InitSymbolTable(CSymtab *s);

    /// @name methods for recursive-descent parsing
    /// @{

    /// @brief main function module.
    /// @retval return all tokens are parsed successfully
    CAstModule*           module(void);
    
    /// @brief function for subroutineDecl(in ENBF)
    /// @param s current scope.
    void                  subroutineDecl(CAstScope *s);

    /// @brief function for declaration of subroutine(function/procedure) parameter.
    /// @param s current scope
    /// @param proc current procedure symbol.
    /// @param index
    void                  varDeclParam(CAstScope *s, CSymProc *proc, int index);

    /// @brief function for variable declaration.
    /// @param s current scope.
    void                  varDecl(CAstScope *s);

    /// @brief function for getting type.
    /// @param isParam check if parameter calls type.
    /// @retval return CType.
    const CType*          type(bool isParam);

    /// @brief function for statement sequence.
    /// @param s current scope
    /// @retval return head of statSeequence.
    CAstStatement*        statSequence(CAstScope *s);

    /// @brief function for statement
    /// @param s current scope
    /// @retval return statement.
    CAstStatement*        statement(CAstScope *);

    /// @brief function for subroutine call.
    /// @param s current scope
    /// @param ident identifier.
    /// @retval return CAstStatCall node.
    CAstStatCall*         subroutineCall(CAstScope *s, CToken ident);

    /// @brief function for assignment.
    /// @param s current scope
    /// @param ident identifier.
    /// @retval return CAstStatAssign node.
    CAstStatAssign*       assignment(CAstScope *s, CToken ident);

    /// @brief function for if statement.
    /// @param s current scope
    /// @retval return CAstStatIf node.
    CAstStatIf*           ifStatement(CAstScope *s);

    /// @brief function for while statement.
    /// @param s current scope
    /// @retval return CAstStatWhile node.
    CAstStatWhile*        whileStatement(CAstScope *s);

    /// @brief function for return statement.
    /// @param s current scope.
    /// @retval return CAstStatReturn node.
    CAstStatReturn*       returnStatement(CAstScope *s);

    /// @brief function for expression(in EBNF).
    /// @param s current scope.
    /// @retval return expression.
    CAstExpression*       expression(CAstScope *s);

    /// @brief function for simpleexpr(in EBNF).
    /// @param s current scope
    /// @retval return simpleexpr.
    CAstExpression*       simpleexpr(CAstScope *s);

    /// @brief function for term(in EBNF).
    /// @param s current scope.
    /// @retval return term.
    CAstExpression*       term(CAstScope *s);

    /// @brief function for factor(in EBNF).
    /// @param s current scope.
    /// @retval return factor.
    CAstExpression*       factor(CAstScope *s);

    /// @}


    CScanner     *_scanner;       ///< CScanner instance
    CAstModule   *_module;        ///< root node of the program
    CToken        _token;         ///< current token

    /// @name error handling
    CToken        _error_token;   ///< error token
    string        _message;       ///< error message
    bool          _abort;         ///< error flag

};

#endif // __SnuPL_PARSER_H__
