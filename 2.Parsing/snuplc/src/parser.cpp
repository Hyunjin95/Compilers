//------------------------------------------------------------------------------
/// @brief SnuPL/0 parser
/// @author Bernhard Egger <bernhard@csap.snu.ac.kr>
/// @section changelog Change Log
/// 2012/09/14 Bernhard Egger created
/// 2013/03/07 Bernhard Egger adapted to SnuPL/0
/// 2014/11/04 Bernhard Egger maintain unary '+' signs in the AST
/// 2016/04/01 Bernhard Egger adapted to SnuPL/1 (this is not a joke)
/// 2016/09/28 Bernhard Egger assignment 2: parser for SnuPL/-1
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

#include <limits.h>
#include <cassert>
#include <errno.h>
#include <cstdlib>
#include <vector>
#include <iostream>
#include <exception>

#include "parser.h"
using namespace std;


//------------------------------------------------------------------------------
// CParser
//
CParser::CParser(CScanner *scanner)
{
  _scanner = scanner;
  _module = NULL;
}

CAstNode* CParser::Parse(void)
{
  _abort = false;

  if (_module != NULL) { delete _module; _module = NULL; }

  try {
    if (_scanner != NULL) _module = module();

    if (_module != NULL) {
      CToken t;
      string msg;
      //if (!_module->TypeCheck(&t, &msg)) SetError(t, msg);
    }
  } catch (...) {
    _module = NULL;
  }

  return _module;
}

const CToken* CParser::GetErrorToken(void) const
{
  if (_abort) return &_error_token;
  else return NULL;
}

string CParser::GetErrorMessage(void) const
{
  if (_abort) return _message;
  else return "";
}

void CParser::SetError(CToken t, const string message)
{
  _error_token = t;
  _message = message;
  _abort = true;
  throw message;
}

bool CParser::Consume(EToken type, CToken *token)
{
  if (_abort) return false;

  CToken t = _scanner->Get();

  if (t.GetType() != type) {
    SetError(t, "expected '" + CToken::Name(type) + "', got '" +
             t.GetName() + "'");
  }

  if (token != NULL) *token = t;

  return t.GetType() == type;
}

void CParser::InitSymbolTable(CSymtab *s)
{
  CTypeManager *tm = CTypeManager::Get();

  // TODO: add predefined functions here
}

CAstModule* CParser::module() {
  //
  // module ::= "module" ident ";" varDeclaration { subroutineDecl }
  //            "begin" statSequence "end" ident ".".
  //
  
  CToken module_name;
  CToken module_name_check;
  CAstStatement *statseq = NULL;
  
  Consume(tModule);
  Consume(tIdent, &module_name);
  Consume(tSemicolon);

  CAstModule *m = new CAstModule(module_name, module_name.GetValue());

  varDeclaration(m);
/*
  if(_scanner->peek().GetType() == tProcedure || _scanner->peek().GetType() == tFunction) {
    subroutinDecl();
  }
*/
  Consume(tBegin);
  
  statseq = statSequence(m);
  m->SetStatementSequence(statseq);

  Consume(tEnd);
  Consume(tIdent, &module_name_check);
  
  if(module_name.GetValue() != module_name_check.GetValue()) {
    SetError(module_name_check, "expected '" + module_name.GetValue() + "', got '" + module_name_check.GetValue() + "'");
  }

  Consume(tDot);

  return m;
}

void CParser::varDeclaration(CAstScope *s) {
  //
  // varDeclaration ::= [ "var" varDeclSequence ";" ].
  // Last semicolon is consumed by varDeclSequence in my implementation.
  //

  if(_scanner->Peek().GetType() == tVar) {
    Consume(tVar);
    varDeclSequence(s);
  }
}

void CParser::varDeclSequence(CAstScope *s) {
  //
  // varDeclSequence ::= varDecl { ";" varDecl }.
  //

  varDecl(s);
  Consume(tSemicolon);

  if(_scanner->Peek().GetType() == tIdent) {
    varDeclSequence(s);
  }
}

void CParser::varDecl(CAstScope *s) {
  //
  // varDecl ::= ident { "," ident } ":" type.
  //
  
  CToken t;
  const CType *var_type;
  vector<string> vars;

  Consume(tIdent, &t);
  vars.push_back(t.GetValue());

  while(_scanner->Peek().GetType() == tComma) {
    Consume(tComma);
    Consume(tIdent, &t);
    vars.push_back(t.GetValue());
  }

  Consume(tColon);
  var_type = type();

  for(int i = vars.size()-1; i >= 0; i--) {
    s->GetSymbolTable()->AddSymbol(s->CreateVar(vars[i], var_type));
    vars.pop_back();
  }
}

const CType* CParser::type() {
  //
  // type ::= basetype | type "[" [ number ] "]".
  // basetype ::= "boolean" | "char" | "integer".
  //
  
  CToken t;
  EToken tt = _scanner->Peek().GetType();
  CTypeManager *tm = CTypeManager::Get();
  const CType *type;
  vector<int> nelems;

  switch(tt) {
    case tBoolean:
      Consume(tBoolean, &t);
      type = dynamic_cast<const CType *>(tm->GetBool());
      break;
    case tChar:
      Consume(tChar, &t);
      type = dynamic_cast<const CType *>(tm->GetChar());
      break;
    case tInteger:
      Consume(tInteger, &t);
      type = dynamic_cast<const CType *>(tm->GetInt());
      break;

    default:
      SetError(_scanner->Peek(), "basetype expected.");
      break;
  }

  assert(type != NULL);

  while(_scanner->Peek().GetType() == tLSBrak) {
    Consume(tLSBrak);
    CToken nelem;

    if(_scanner->Peek().GetType() == tNumber) {
      Consume(tNumber, &nelem);
      nelems.push_back(atoi(nelem.GetValue().c_str()));
    }
    else {
      // TODO(or doesn't have to?): OPEN arrays are allowed only in parameter.
      nelems.push_back(-1);
    }
    Consume(tRSBrak);
  }

  for(int i = nelems.size()-1; i >= 0; i--) {
    type = dynamic_cast<const CType *>(tm->GetArray(nelems[i], type));
    assert(type != NULL);
    nelems.pop_back();
  }

  return type;
}


CAstStatement* CParser::statSequence(CAstScope *s) {
  //
  // statSequence ::= [ statement { ";" statement } ].
  //

  CAstStatement *head = NULL;
  CAstStatement *tail = NULL;

  EToken tt = _scanner->Peek().GetType();
  switch(tt) {
    case tIf:
    case tWhile:
    case tReturn:
    case tIdent:
      head = statement(s);
      assert(head != NULL);
      
      while(_scanner->Peek().GetType() == tSemicolon) {
        CAstStatement *st = NULL;
        Consume(tSemicolon);
        st = statement(s);

        assert(st != NULL);

        tail->SetNext(st);
        tail = st;
      }
      break;

    default:
      break;
  }

  return head;
}

CAstStatement* CParser::statement(CAstScope *s) {
  //
  // statement ::= assignment | subroutineCall | ifStatement | whileStatement | returnStatement.
  // 
  // Both assignment and subroutineCall have same FIRST, 'tIdent'.
  //
  CAstStatement *st;

  EToken tt = _scanner->Peek().GetType();
  switch(tt) {
    case tIf:
      st = dynamic_cast<CAstStatement *>(ifStatement(s));
      break;
    case tWhile:
      st = dynamic_cast<CAstStatement *>(whileStatement(s));
      break;
    case tReturn:
      st = dynamic_cast<CAstStatement *>(returnStatement(s));
      break;
    case tIdent:
      CToken t;
      Consume(tIdent, &t);
  
      if(_scanner->Peek().GetType() == tLBrak) {
        st = dynamic_cast<CAstStatement *>(subroutineCall(s, t));
      }
      else if(_scanner->Peek().GetType() == tAssign || _scanner->Peek().GetType() == tLSBrak) {
        st = dynamic_cast<CAstStatement *>(assignment(s, t));
      }
      else { // TODO: Error message should be modified.
        SetError(_scanner->Peek(), "Hyunjin Error");
      }
      break;

    default: // TODO: Error message should be modified.
      SetError(_scanner->Peek(), "Hyunjin Error");
      break;
  }

  assert(st != NULL);

  return st;
}

CAstStatCall* CParser::subroutineCall(CAstScope *s, CToken ident) {
  //
  // subroutineCall ::= ident "(" [ expression {"," expression} ] ")".
  //

  CToken t;
  Consume(tLBrak);
  
  CAstFunctionCall *call = new CAstFunctionCall(t, CSymtab::FindSymbol(ident.GetValue(), s));
  assert(call != NULL);
  
  if(isExpr(_scanner->Peek())) {
    CAstExpression *expr = expression(s);
    assert(expr != NULL);
    call->Addarg(expr);

    while(_scanner->Peek().GetType() == tComma) {
      Consume(tComma);
      expr = expression(s);
      assert(expr != NULL);
      call->Addarg(expr);
    }
  }
  
  Consume(tRBrak);

  return new CAstStatCall(t, call);
}

CAstStatAssign* CParser::assignment(CAstScope *s, CToken ident) {
  //
  // assignment ::= qualident ":=" expression.
  // qualident ::= ident { "[" expression "]" }.
  //
  
  CToken t;
  CAstDesignator *lhs;

  if(_scanner->Peek().GetType() == tAssign) {
    lhs = new CAstArrayDesignator(t, CSymtab::FindSymbol(ident.GetValue(), s));
  }
  else {
    CAstArrayDesignator *arraylhs = new CAstArrayDesignator(t, CSymtab::FindSymbol(ident.GetValue(), s));
    
    while(_scanner->Peek().GetType() == tLSBrak) { // It means array assignment.
      Consume(tLSBrak);

      CAstExpression *expr = expression(s);
      assert(expr != NULL);
      arraylhs->AddIndex(expr);

      Consume(tRSBrak);
    }
    arraylhs->IndicesComplete();

    lhs = dynamic_cast<CAstDesignator *>arraylhs;
  }
  assert(lhs != NULL);

  Consume(tAssign);

  CAstExpression *rhs = expression(s);
  assert(rhs != NULL);

  return new CAstStatAssign(t, lhs, rhs);
}


CAstStatIf* CParser::ifStatement(CAstScope *s) {
  //
  // ifStatement ::= "if" "(" expression ")" "then" statSequence [ "else" statSequence ] "end".
  //
  
  CToken t;
  CAstExpression *cond;
  CAstStatement *ifbody, *elsebody;

  Consume(tIf);
  Consume(tLBrak);

  cond = expression(s);
  assert(cond != NULL);

  Consume(tRBrak);
  Consume(tThen);

  ifbody = statSequence(s);
  assert(ifbody != NULL);
  
  if(_scanner->Peek()->GetType() == tElse) {
    Consume(tElse);
    elsebody = statSequence(s);
    assert(elsebody != NULL);
  }

  Consume(tEnd);

  return new CAstStatIf(t, cond, ifbody, elsebody);
}

CAstStatWhile* CParser::whileStatement(CAstScope *s) {
  //
  // whileStatement ::= "while" "(" expression ")" "do" statSequence "end".
  //
  CToken t;
  CAstExpression *cond;
  CAstStatement *body;

  Consume(tWhile);
  Consume(tLBrak);

  cond = expression(s);
  assert(cond != NULL);
  
  Consume(tRBrak);
  Consume(tDo);

  body = statSequence(s);
  assert(body != NULL);

  Consume(tEnd);

  return new CAstStatWhile(t, cond, body);
}

CAstStatReturn* CParser::returnStatement(CAstScope *s) {
  //
  // returnStatement ::= "return" [ expression ].
  // expression ::= simpleexpr [ relOp simpleexpr ].
  // simpleexpr ::= ["+" | "-"] term { termOp term }.
  // term ::= factor { factOp factor }.
  // factor ::= qualident | number | boolean | char | string | "(" expression ")" | subroutineCall | "!" factor.
  // 
  // So FIRST(expression) = {tTermOp, tIdent, tNumber, tTrue, tFalse, tCharacter, tString, tLBrak, tEMark}.
  //
  
  CToken t;
  CAstExpression *expr = NULL;

  Consume(tReturn);

  if(isExpr(_scanner->Peek())) {
    expr = expression(s);
    assert(expr != NULL);
  }

  return new CAstStatReturn(t, expr);
}

CAstExpression* CParser::expression(CAstScope *s) {
  simpleexpr(s);
  if(_scanner->Peek().GetType() == tRelOp) {
    CToken relOp;
    Consume(tRelOp, &relOp);
    simpleexpr(s);
  }
}



static bool isExpr(CToken t) {
  EToken tt = t.GetType();

  switch(tt) {
    case tIdent:
    case tNumber:
    case tTrue:
    case tFalse:
    case tCharacter:
    case tString:
    case tLBrak:
    case tRBrak:
    case tEMark:
      return true;

    case tTermOp:
      if(t.GetValue() != "||")
        return true;
      return false;

    default:
      return false;
  }
}


/*
CAstModule* CParser::module(void)
{
  //
  // module ::= statSequence  ".".
  //
  CToken dummy;
  CAstModule *m = new CAstModule(dummy, "placeholder");
  CAstStatement *statseq = NULL;

  statseq = statSequence(m);
  Consume(tDot);

  m->SetStatementSequence(statseq);

  return m;
}


CAstStatement* CParser::statSequence(CAstScope *s)
{
  //
  // statSequence ::= [ statement { ";" statement } ].
  // statement ::= assignment.
  // FIRST(statSequence) = { tNumber }
  // FOLLOW(statSequence) = { tDot }
  //
  CAstStatement *head = NULL;

  EToken tt = _scanner->Peek().GetType();
  if (!(tt == tDot)) {
    CAstStatement *tail = NULL;

    do {
      CToken t;
      EToken tt = _scanner->Peek().GetType();
      CAstStatement *st = NULL;

      switch (tt) {
        // statement ::= assignment
        case tNumber:
          st = assignment(s);
          break;

        default:
          SetError(_scanner->Peek(), "statement expected.");
          break;
      }

      assert(st != NULL);
      if (head == NULL) head = st;
      else tail->SetNext(st);
      tail = st;

      tt = _scanner->Peek().GetType();
      if (tt == tDot) break;

      Consume(tSemicolon);
    } while (!_abort);
  }

  return head;
}

CAstStatAssign* CParser::assignment(CAstScope *s)
{
  //
  // assignment ::= number ":=" expression.
  //
  CToken t;

  CAstConstant *lhs = number();
  Consume(tAssign, &t);

  CAstExpression *rhs = expression(s);

  return new CAstStatAssign(t, lhs, rhs);
}

CAstExpression* CParser::expression(CAstScope* s)
{
  //
  // expression ::= simpleexpr [ relOp simpleexpression ].
  //
  CToken t;
  EOperation relop;
  CAstExpression *left = NULL, *right = NULL;

  left = simpleexpr(s);

  if (_scanner->Peek().GetType() == tRelOp) {
    Consume(tRelOp, &t);
    right = simpleexpr(s);

    if (t.GetValue() == "=")       relop = opEqual;
    else if (t.GetValue() == "#")  relop = opNotEqual;
    else SetError(t, "invalid relation.");

    return new CAstBinaryOp(t, relop, left, right);
  } else {
    return left;
  }
}

CAstExpression* CParser::simpleexpr(CAstScope *s)
{
  //
  // simpleexpr ::= term { termOp term }.
  //
  CAstExpression *n = NULL;

  n = term(s);

  while (_scanner->Peek().GetType() == tTermOp) {
    CToken t;
    CAstExpression *l = n, *r;

    Consume(tTermOp, &t);

    r = term(s);

    n = new CAstBinaryOp(t, t.GetValue() == "+" ? opAdd : opSub, l, r);
  }


  return n;
}

CAstExpression* CParser::term(CAstScope *s)
{
  //
  // term ::= factor { ("*"|"/") factor }.
  //
  CAstExpression *n = NULL;

  n = factor(s);

  EToken tt = _scanner->Peek().GetType();

  while ((tt == tFactOp)) {
    CToken t;
    CAstExpression *l = n, *r;

    Consume(tFactOp, &t);

    r = factor(s);

    n = new CAstBinaryOp(t, t.GetValue() == "*" ? opMul : opDiv, l, r);

    tt = _scanner->Peek().GetType();
  }

  return n;
}

CAstExpression* CParser::factor(CAstScope *s)
{
  //
  // factor ::= number | "(" expression ")"
  //
  // FIRST(factor) = { tNumber, tLBrak }
  //

  CToken t;
  EToken tt = _scanner->Peek().GetType();
  CAstExpression *unary = NULL, *n = NULL;

  switch (tt) {
    // factor ::= number
    case tNumber:
      n = number();
      break;

    // factor ::= "(" expression ")"
    case tLBrak:
      Consume(tLBrak);
      n = expression(s);
      Consume(tRBrak);
      break;

    default:
      cout << "got " << _scanner->Peek() << endl;
      SetError(_scanner->Peek(), "factor expected.");
      break;
  }

  return n;
}

CAstConstant* CParser::number(void)
{
  //
  // number ::= digit { digit }.
  //
  // "digit { digit }" is scanned as one token (tNumber)
  //

  CToken t;

  Consume(tNumber, &t);

  errno = 0;
  long long v = strtoll(t.GetValue().c_str(), NULL, 10);
  if (errno != 0) SetError(t, "invalid number.");

  return new CAstConstant(t, CTypeManager::Get()->GetInt(), v);
}

CAstStringConstant* CParser::ident(CAstScope *s) {
  //
  // ident ::= letter { letter | digit }.   
  //
  // "letter { letter | digit }" is scanned as one token (tIdent)
  //
    
  CToken t;
    
  Consume(tIdent, &t);
   
  return new CAstStringConstant(t, t.GetValue(), s);
*/
