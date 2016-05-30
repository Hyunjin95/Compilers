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
static bool isExpr(CToken);

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
      if (!_module->TypeCheck(&t, &msg)) SetError(t, msg);
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
  
  // predefined functions:
  //  - DIM(a: ptr to array; dim: integer): integer
  //  - DOFS(a: ptr to array): integer
  //  - ReadInt(): integer
  //  - WriteInt(i:integer): void
  //  - WriteChar(c:char): void
  //  - WriteStr(str: char[]): void
  //  - WriteLn():void

  //  - DIM(a: ptr to array; dim: integer): integer
  CSymProc *DIM = new CSymProc("DIM", tm->GetInt());
  CSymParam *DIM_a = new CSymParam(0, "a", tm->GetPointer(tm->GetNull()));
  CSymParam *DIM_dim = new CSymParam(1, "dim", tm->GetInt());
  DIM->AddParam(DIM_a);
  DIM->AddParam(DIM_dim);
  s->AddSymbol(DIM);

  //  - DOFS(a: ptr to array): integer
  CSymProc *DOFS = new CSymProc("DOFS", tm->GetInt());
  CSymParam *DOFS_a = new CSymParam(0, "a", tm->GetPointer(tm->GetNull()));
  DOFS->AddParam(DOFS_a);
  s->AddSymbol(DOFS);

  //  - ReadInt(): integer
  CSymProc *ReadInt = new CSymProc("ReadInt", tm->GetInt());
  s->AddSymbol(ReadInt);
  
  //  - WriteInt(i:integer): void
  CSymProc *WriteInt = new CSymProc("WriteInt", tm->GetNull());
  CSymParam *WriteInt_i = new CSymParam(0, "i", tm->GetInt());
  WriteInt->AddParam(WriteInt_i);
  s->AddSymbol(WriteInt);

  //  - WriteChar(c:char): void
  CSymProc *WriteChar = new CSymProc("WriteChar", tm->GetNull());
  CSymParam *WriteChar_c = new CSymParam(0, "c", tm->GetChar());
  WriteChar->AddParam(WriteChar_c);
  s->AddSymbol(WriteChar);

  //  - WriteStr(str: char[]): void
  CSymProc *WriteStr = new CSymProc("WriteStr", tm->GetNull());
  CSymParam *WriteStr_str = new CSymParam(0, "str", tm->GetPointer(tm->GetArray(CArrayType::OPEN, tm->GetChar())));
  WriteStr->AddParam(WriteStr_str);
  s->AddSymbol(WriteStr);

  //  - WriteLn():void
  CSymProc *WriteLn = new CSymProc("WriteLn", tm->GetNull());
  s->AddSymbol(WriteLn);
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

  InitSymbolTable(m->GetSymbolTable());

  // varDeclaration
  if(_scanner->Peek().GetType() == tVar) {
    Consume(tVar);
    varDecl(m);
    Consume(tSemicolon);

    while(1) {
      if(_scanner->Peek().GetType() == tIdent) {
        varDecl(m);
        Consume(tSemicolon);
      }
      else break;
    }
  }

  // subroutineDecl
  while(_scanner->Peek().GetType() == tProcedure || _scanner->Peek().GetType() == tFunction) {
    subroutineDecl(m);
  }

  Consume(tBegin);

  // statSequence
  statseq = statSequence(m);
  m->SetStatementSequence(statseq);

  Consume(tEnd);
  Consume(tIdent, &module_name_check);
  
  // Check module names are equal.
  if(module_name.GetValue() != module_name_check.GetValue()) {
    SetError(module_name_check, "module identifier mismatch ('" + module_name.GetValue() + "' != '" + module_name_check.GetValue() + "').");
  }

  Consume(tDot);

  return m;
}

void CParser::subroutineDecl(CAstScope *s) {
  //
  // subroutineDecl ::= (procedureDecl | functionDecl) subroutineBody ident ";".
  // procedureDecl ::= "procedure" ident [ formalParam ] ";".
  // functionDecl ::= "function" ident [ formalParam ] ":" type ";".
  // formalParam ::= "(" [ varDeclSequence ] ")".
  // subroutineBody ::= varDeclaration "begin" statSequence "end".
  // varDeclSequence ::= varDecl { ";" varDecl }.
  // varDecl ::= ident { "," ident } ":" type.
  //


  CToken subroutine_name;
  CToken subroutine_name_check;
  CTypeManager *tm = CTypeManager::Get();

  // procedureDecl
  if(_scanner->Peek().GetType() == tProcedure) {
    CToken t;
    CAstStatement *statseq = NULL;

    Consume(tProcedure);
    Consume(tIdent, &subroutine_name);
 
    // Check duplicate procedure declaration.
    if(dynamic_cast<CAstModule *>(s)) {
      if(s->GetSymbolTable()->FindSymbol(subroutine_name.GetValue(), sGlobal) != NULL)
        SetError(subroutine_name, "duplicate procedure/function declaration '" + subroutine_name.GetValue() + "'.");
    }
    else {
      if(s->GetSymbolTable()->FindSymbol(subroutine_name.GetValue(), sLocal) != NULL)
        SetError(subroutine_name, "duplicate procedure/function declaration '" + subroutine_name.GetValue() + "'.");
    }

    CSymProc *symproc = new CSymProc(subroutine_name.GetValue(), tm->GetNull());
    CAstProcedure *procedure = new CAstProcedure(subroutine_name, subroutine_name.GetValue(), s, symproc);

    // formalParam
    if(_scanner->Peek().GetType() == tLBrak) {
      Consume(tLBrak);

      if(_scanner->Peek().GetType() == tIdent) {
        varDeclParam(procedure, symproc, 0);

        while(1) {
          if(_scanner->Peek().GetType() == tSemicolon) {
            Consume(tSemicolon);
            varDeclParam(procedure, symproc, symproc->GetNParams());
          }
          else break;
        }
      }

      Consume(tRBrak);
    }
    
    s->GetSymbolTable()->AddSymbol(symproc);
    
    Consume(tSemicolon);

    // subroutineBody from here.
    // subroutineBody ::= varDeclaration "begin" statSequence "end".

    // varDeclaration
    if(_scanner->Peek().GetType() == tVar) {
      Consume(tVar);
      varDecl(procedure);
      Consume(tSemicolon);

      while(1) {
        if(_scanner->Peek().GetType() == tIdent) {
          varDecl(procedure);
          Consume(tSemicolon);
        }
        else break;
      }
    }

    Consume(tBegin);
    
    // statSequence
    statseq = statSequence(procedure);
    procedure->SetStatementSequence(statseq);

    Consume(tEnd);

    Consume(tIdent, &subroutine_name_check);
    
    // Check procedure names are equal.
    if(subroutine_name.GetValue() != subroutine_name_check.GetValue()) {
      SetError(subroutine_name_check, "procedure/function identifier mismatch ('" + subroutine_name.GetValue() + "' != '" + subroutine_name_check.GetValue() + "').");
    }

    Consume(tSemicolon);
  }
  // functionDecl
  else {
    CToken tmp;
    
    // Parameters are pushed into params. Then they will be added into symproc later.
    vector<CSymParam *> params;
    const CType *func_type;
    CAstStatement *statseq = NULL;
    
    Consume(tFunction);
    Consume(tIdent, &subroutine_name);

    // Check duplicate function declaration.
    if(dynamic_cast<CAstModule *>(s)) {
      if(s->GetSymbolTable()->FindSymbol(subroutine_name.GetValue(), sGlobal) != NULL)
        SetError(subroutine_name, "duplicate procedure/function declaration '" + subroutine_name.GetValue() + "'.");
    }
    else {
      if(s->GetSymbolTable()->FindSymbol(subroutine_name.GetValue(), sLocal) != NULL)
        SetError(subroutine_name, "duplicate procedure/function declaration '" + subroutine_name.GetValue() + "'.");
    }

    // formalParam
    if(_scanner->Peek().GetType() == tLBrak) {
      int idx = 0;
      CToken t;
      vector<string> vars;
      const CType *var_type;
      
      Consume(tLBrak);

      // Get parameters.
      if(_scanner->Peek().GetType() == tIdent) {                                                                              
        Consume(tIdent, &t);
        vars.push_back(t.GetValue());

        while(_scanner->Peek().GetType() == tComma) {
          Consume(tComma);
          Consume(tIdent, &t);

          // Check duplicate parameter declaration.
          for(int i = 0; i < vars.size(); i++) {
            if(vars[i] == t.GetValue()) {
              SetError(t, "duplicate variable declaration '" + t.GetValue() + "'.");
              break;
            }
          }

          vars.push_back(t.GetValue());
        }

        Consume(tColon);
        var_type = type(true);

        for(int i = vars.size() - 1; i >= 0; i--) {
          CSymParam *param = new CSymParam(i, vars[i], var_type);
          params.push_back(param);
          idx++;
        }

        // for multiple parameter declaration.
        while(1) {
          if(_scanner->Peek().GetType() == tSemicolon) {
            Consume(tSemicolon);

            CToken t_loop;
            vector<string> vars_loop;
            const CType *var_type_loop;

            Consume(tIdent, &t_loop);

            // Check duplicate parameter declaration.
            for(int i = 0; i < params.size(); i++) {
              if(params[i]->GetName() == t_loop.GetValue()) {
                SetError(t_loop, "duplicate variable declaration '" + t_loop.GetValue() + "'.");
                break;
              }
            }

            vars_loop.push_back(t_loop.GetValue());

            while(_scanner->Peek().GetType() == tComma) {
              Consume(tComma);
              Consume(tIdent, &t_loop);

              for(int i = 0; i < params.size(); i++) {
                if(params[i]->GetName() == t_loop.GetValue()) {
                  SetError(t_loop, "duplicate variable declaration '" + t_loop.GetValue() + "'.");
                  break;
                }
              }

              // Check duplicate parameter declaration.
              for(int i = 0; i < vars_loop.size(); i++) {
                if(vars_loop[i] == t_loop.GetValue()) {
                  SetError(t_loop, "duplicate variable declaration '" + t_loop.GetValue() + "'.");
                  break;
                }
              }

              vars_loop.push_back(t_loop.GetValue());
            }

            Consume(tColon);
            var_type_loop = type(true);
  
            int tmp_idx = idx;
            
            // Add parameters into vector 'params'.
            for(int i = vars_loop.size() - 1; i >= 0; i--) {
              CSymParam *param_loop = new CSymParam(i+tmp_idx, vars_loop[i], var_type_loop);
              params.push_back(param_loop);
              vars_loop.pop_back();
              idx++;
            }
          }
          else break;
        }
      }

      Consume(tRBrak);
    }

    Consume(tColon);
    func_type = type(false, true);
    Consume(tSemicolon);
    
    CSymProc *symproc = new CSymProc(subroutine_name.GetValue(), func_type);
    CAstProcedure *function = new CAstProcedure(subroutine_name, subroutine_name.GetValue(), s, symproc);
    
    assert(symproc != NULL);

    // Add parameters into symproc.
    for(int i = 0; i < params.size(); i++) {
      CSymParam *param = params[i];
      symproc->AddParam(param);
      function->GetSymbolTable()->AddSymbol(param);
    }

    while(!params.empty())
      params.pop_back();

    s->GetSymbolTable()->AddSymbol(symproc);
    
    // subroutineBody from here.
    // subroutineBody ::= varDeclaration "begin" statSequence "end".

    // varDeclaration
    if(_scanner->Peek().GetType() == tVar) {
      Consume(tVar);
      varDecl(function);
      Consume(tSemicolon);

      while(1) {
        if(_scanner->Peek().GetType() == tIdent) {
          varDecl(function);
          Consume(tSemicolon);
        }
        else break;
      }
    }

    Consume(tBegin);
    
    // statSequence
    statseq = statSequence(function);
    function->SetStatementSequence(statseq);

    Consume(tEnd);

    Consume(tIdent, &subroutine_name_check);
    
    // Check function names are equal.
    if(subroutine_name.GetValue() != subroutine_name_check.GetValue()) {
      SetError(subroutine_name_check, "procedure/function identifier mismatch ('" + subroutine_name.GetValue() + "' != '" + subroutine_name_check.GetValue() + "').");
    }

    Consume(tSemicolon);
  }
}

// This function is used for adding procedure parameters.
void CParser::varDeclParam(CAstScope *s, CSymProc *proc, int index) {
  //
  // varDecl ::= ident { "," ident } ":" type.
  //
  
  CToken t;
  const CType *var_type;
  vector<string> vars;

  Consume(tIdent, &t);
  vars.push_back(t.GetValue());

  // Check duplicate parameter declaration.
  if(dynamic_cast<CAstModule *>(s)) {
    if(dynamic_cast<const CSymParam *>(s->GetSymbolTable()->FindSymbol(t.GetValue(), sGlobal)) != NULL)
      SetError(t, "duplicate variable declaration '" + t.GetValue() + "'.");
  }
  else {
    if(dynamic_cast<const CSymParam *>(s->GetSymbolTable()->FindSymbol(t.GetValue(), sLocal)) != NULL)
      SetError(t, "duplicate variable declaration '" + t.GetValue() + "'.");
  }

  while(_scanner->Peek().GetType() == tComma) {
    Consume(tComma);
    Consume(tIdent, &t);

    // Check duplicate parameter declaration
    if(dynamic_cast<CAstModule *>(s)) {
      if(dynamic_cast<const CSymParam *>(s->GetSymbolTable()->FindSymbol(t.GetValue(), sGlobal)) != NULL)
        SetError(t, "duplicate variable declaration '" + t.GetValue() + "'.");
    }
    else {
      if(dynamic_cast<const CSymParam *>(s->GetSymbolTable()->FindSymbol(t.GetValue(), sLocal)) != NULL)
        SetError(t, "duplicate variable declaration '" + t.GetValue() + "'.");
    }

    for(int i = 0; i < vars.size(); i++) {
      if(vars[i] == t.GetValue()) {
        SetError(t, "duplicate variable declaration '" + t.GetValue() + "'.");
        break;
      }
    }

    vars.push_back(t.GetValue());
  }

  Consume(tColon);
  var_type = type(true);

  // Add parameters into symproc.
  for(int i = vars.size()-1; i >= 0; i--) {
    CSymParam *param = new CSymParam(index + i, vars[i], var_type);
    proc->AddParam(param);
    s->GetSymbolTable()->AddSymbol(param);
    vars.pop_back();
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

  // Check duplicate variable declaration.
  if(dynamic_cast<CAstModule *>(s)) {
    if(s->GetSymbolTable()->FindSymbol(t.GetValue(), sGlobal) != NULL)
      SetError(t, "duplicate variable declaration '" + t.GetValue() + "'.");
  }
  else {
    if(s->GetSymbolTable()->FindSymbol(t.GetValue(), sLocal) != NULL)
      SetError(t, "duplicate variable declaration '" + t.GetValue() + "'.");
  }

  vars.push_back(t.GetValue());

  while(_scanner->Peek().GetType() == tComma) {
    Consume(tComma);
    Consume(tIdent, &t);
   
    // Check duplicate variable declaration.
    if(dynamic_cast<CAstModule *>(s)) {
      if(s->GetSymbolTable()->FindSymbol(t.GetValue(), sGlobal) != NULL)
        SetError(t, "duplicate variable declaration '" + t.GetValue() + "'.");
    }
    else {
      if(s->GetSymbolTable()->FindSymbol(t.GetValue(), sLocal) != NULL)
        SetError(t, "duplicate variable declaration '" + t.GetValue() + "'.");
    }

    for(int i = 0; i < vars.size(); i++) {
      if(vars[i] == t.GetValue()) {
        SetError(t, "duplicate variable declaration '" + t.GetValue() + "'.");
        break;
      }
    }

    vars.push_back(t.GetValue());
  }

  Consume(tColon);
  var_type = type(false);

  // Add symbols into symbol table.
  for(int i = vars.size()-1; i >= 0; i--) {
    s->GetSymbolTable()->AddSymbol(s->CreateVar(vars[i], var_type));
    vars.pop_back();
  }
}

const CType* CParser::type(bool isParam, bool isFunction) {
  //
  // type ::= basetype | type "[" [ number ] "]".
  // basetype ::= "boolean" | "char" | "integer".
  //
  
  CToken t;
  CToken tk;
  EToken tt = _scanner->Peek().GetType();
  CTypeManager *tm = CTypeManager::Get();
  const CType *type;
  vector<int> nelems;

  // basetype cases.
  switch(tt) {
    case tBoolean:
      Consume(tBoolean, &t);
      tk = t;
      type = dynamic_cast<const CType *>(tm->GetBool());
      break;
    case tChar:
      Consume(tChar, &t);
      tk = t;
      type = dynamic_cast<const CType *>(tm->GetChar());
      break;
    case tInteger:
      Consume(tInteger, &t);
      tk = t;
      type = dynamic_cast<const CType *>(tm->GetInt());
      break;

    default:
      SetError(_scanner->Peek(), "basetype expected.");
      break;
  }

  assert(type != NULL);

  // array case.
  while(_scanner->Peek().GetType() == tLSBrak) {
    Consume(tLSBrak);
    CToken nelem;

    if(_scanner->Peek().GetType() == tNumber) {
      Consume(tNumber, &nelem);
      nelems.push_back(atoi(nelem.GetValue().c_str()));
    }
    else {
      // open arrays are allowed only in parameter.
      if(isParam)
        nelems.push_back(-1);
      else
        SetError(_scanner->Peek(), "expected 'tNumber', got '" + _scanner->Peek().GetName() + "'");
    }
    Consume(tRSBrak);
  }

  for(int i = nelems.size()-1; i >= 0; i--) {
    type = dynamic_cast<const CType *>(tm->GetArray(nelems[i], type));
    assert(type != NULL);
    nelems.pop_back();

    // Arrays are addressed in parameter.
    if(i == 0 && isParam)
      type = dynamic_cast<const CType *>(tm->GetPointer(type));
  }

  if(isFunction && !type->IsScalar()) {
    SetError(tk, "invalid composite type for function.");
  }

  return type;
}


CAstStatement* CParser::statSequence(CAstScope *s) {
  //
  // statSequence ::= [ statement { ";" statement } ].
  // FIRST(statement) = {tIF, tWhile, tReturn, tIdent}.
  // FOLLOW(statSequence) = {tEnd, tElse}.
  //

  CAstStatement *head = NULL;
  CAstStatement *tail = NULL;

  EToken tt = _scanner->Peek().GetType();

  switch(tt) {
    case tIf:
    case tWhile:
    case tReturn:
    case tIdent:
      head = tail = statement(s);
      assert(head != NULL);

      // for multiple statements.
      while(1) {
        if(_scanner->Peek().GetType() == tEnd ||
           _scanner->Peek().GetType() == tElse) {
          break;
        }
        else {
          Consume(tSemicolon);

          CAstStatement *st = NULL;
          st = statement(s);
          
          assert(st != NULL);
          
          tail->SetNext(st);
          tail = st;
        }
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
  // FIRST(statement) = {tIf, tWhile, tReturn, tIdent}.
  // Both assignment and subroutineCall have same FIRST, 'tIdent'.
  //
  
  CAstStatement *st = NULL;

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
    {
      CToken t;
      Consume(tIdent, &t);

      // case subroutineCall
      if(_scanner->Peek().GetType() == tLBrak) {
        st = dynamic_cast<CAstStatement *>(subroutineCall(s, t));
      }
      // case assignment.
      else {
        st = dynamic_cast<CAstStatement *>(assignment(s, t));
      }

      break;
    }

    default:
      SetError(_scanner->Peek(), "statement expected.");
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
  CSymtab *symtab = s->GetSymbolTable();
  CAstFunctionCall *call = NULL;

  // Check undefined procedure/function call.
  if(symtab->FindSymbol(ident.GetValue(), sLocal) == NULL && symtab->FindSymbol(ident.GetValue(), sGlobal) != NULL) {
    // Check if symbol is procedure.
    if(dynamic_cast<const CSymProc *>(symtab->FindSymbol(ident.GetValue(), sGlobal)) == NULL)
      SetError(ident, "invalid procedure/function identifier.");
    
    call = new CAstFunctionCall(ident, dynamic_cast<const CSymProc *>(symtab->FindSymbol(ident.GetValue(), sGlobal)));
  }
  else if(symtab->FindSymbol(ident.GetValue(), sLocal) != NULL) {
    // Check if symbol is procedure.
    if(dynamic_cast<const CSymProc *>(symtab->FindSymbol(ident.GetValue(), sLocal)) == NULL)
        SetError(ident, "invalid procedure/function identifier.");
    
    call = new CAstFunctionCall(ident, dynamic_cast<const CSymProc *>(symtab->FindSymbol(ident.GetValue(), sLocal)));
  }
  else
    SetError(ident, "undefined identifier.");
  
  // Add expressions.
  if(isExpr(_scanner->Peek())) {
    CAstExpression *expr = expression(s);
    assert(expr != NULL);

    // Arrays are addressed.
    if(expr->GetType()->IsArray())
      expr = new CAstSpecialOp(expr->GetToken(), opAddress, expr, NULL);

    call->AddArg(expr);

    while(_scanner->Peek().GetType() == tComma) {
      Consume(tComma);
      expr = expression(s);
      assert(expr != NULL);

      // Arrays are addressed.
      if(expr->GetType()->IsArray())
        expr = new CAstSpecialOp(expr->GetToken(), opAddress, expr, NULL);

      call->AddArg(expr);
    }
  }
  
  Consume(tRBrak);

  return new CAstStatCall(ident, call);
}

CAstStatAssign* CParser::assignment(CAstScope *s, CToken ident) {
  //
  // assignment ::= qualident ":=" expression.
  // qualident ::= ident { "[" expression "]" }.
  //
  
  CToken t;
  CAstDesignator *lhs = NULL;
  CSymtab *symtab = s->GetSymbolTable();

  if(_scanner->Peek().GetType() == tAssign) { // non-array case.
    const CSymbol *tmpsym = symtab->FindSymbol(ident.GetValue(), sLocal);

    if(tmpsym == NULL && symtab->FindSymbol(ident.GetValue(), sGlobal) != NULL) {
      // Check if symbol is procedure.
      if(dynamic_cast<const CSymProc *>(symtab->FindSymbol(ident.GetValue(), sGlobal)) != NULL) {
        SetError(ident, "designator expected.");
      }

      lhs = new CAstDesignator(ident, symtab->FindSymbol(ident.GetValue(), sGlobal));
    }
    else if(tmpsym != NULL) {
      // Check if symbol is procedure.
      if(dynamic_cast<const CSymProc *>(tmpsym) != NULL) {
        SetError(ident, "designator expected.");
      }
        
      lhs = new CAstDesignator(ident, symtab->FindSymbol(ident.GetValue(), sLocal));
    }
    else
      SetError(ident, "undefined identifier.");
    
    assert(lhs != NULL);
  }
  else if(_scanner->Peek().GetType() == tLSBrak) { // array case.
    const CSymbol *tmpsym = symtab->FindSymbol(ident.GetValue(), sLocal);
    CAstArrayDesignator *arraylhs;

    if(tmpsym == NULL && symtab->FindSymbol(ident.GetValue(), sGlobal) != NULL) {
      // Check if symbol is procedure.
      if(dynamic_cast<const CSymProc *>(symtab->FindSymbol(ident.GetValue(), sGlobal)) != NULL) {
        SetError(ident, "designator expected.");
      }

      arraylhs = new CAstArrayDesignator(ident, symtab->FindSymbol(ident.GetValue(), sGlobal));
    }
    else if(tmpsym != NULL) {
      // Check if symbol is procedure.
      if(dynamic_cast<const CSymProc *>(tmpsym) != NULL) {
        SetError(ident, "designator expected.");
      }

      arraylhs = new CAstArrayDesignator(ident, symtab->FindSymbol(ident.GetValue(), sLocal));
    }
    else
      SetError(ident, "undefined identifier.");
  
    // multiple index.
    while(_scanner->Peek().GetType() == tLSBrak) {
      Consume(tLSBrak);

      CAstExpression *expr = expression(s);
      assert(expr != NULL);
      arraylhs->AddIndex(expr);

      Consume(tRSBrak);
    }
    arraylhs->IndicesComplete();

    lhs = dynamic_cast<CAstDesignator *>(arraylhs);
    assert(lhs != NULL);
  }

  CToken k;
  Consume(tAssign, &k);

  CAstExpression *rhs = expression(s);
  assert(rhs != NULL);

  return new CAstStatAssign(k, lhs, rhs);
}


CAstStatIf* CParser::ifStatement(CAstScope *s) {
  //
  // ifStatement ::= "if" "(" expression ")" "then" statSequence [ "else" statSequence ] "end".
  //
  
  CToken t;
  CAstExpression *cond = NULL;
  CAstStatement *ifbody = NULL;
  CAstStatement *elsebody = NULL;

  Consume(tIf, &t);
  Consume(tLBrak);

  // condition
  cond = expression(s);
  assert(cond != NULL);

  Consume(tRBrak);
  Consume(tThen);

  // ifbody
  ifbody = statSequence(s);

  // elsebody
  if(_scanner->Peek().GetType() == tElse) {
    Consume(tElse);
    elsebody = statSequence(s);
  }

  Consume(tEnd);

  return new CAstStatIf(t, cond, ifbody, elsebody);
}

CAstStatWhile* CParser::whileStatement(CAstScope *s) {
  //
  // whileStatement ::= "while" "(" expression ")" "do" statSequence "end".
  //
  
  CToken t;
  CAstExpression *cond = NULL;
  CAstStatement *body = NULL;

  Consume(tWhile, &t);
  Consume(tLBrak);

  // condition
  cond = expression(s);
  assert(cond != NULL);

  Consume(tRBrak);
  Consume(tDo);

  // whilebody
  body = statSequence(s);

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

  Consume(tReturn, &t);

  // Check expression.
  if(isExpr(_scanner->Peek())) {
    expr = expression(s);
    assert(expr != NULL);
  }

  return new CAstStatReturn(t, s, expr);
}

CAstExpression* CParser::expression(CAstScope *s) {
  //
  // expression ::= simpleexpr [ relOp simpleexpr ].
  // relop = {=, #, <, <=, >, >=}.
  //
  
  CToken t;
  EOperation relop;
  CAstExpression *left = NULL, *right = NULL;

  left = simpleexpr(s);

  // Check relop.
  if (_scanner->Peek().GetType() == tRelOp) {
    Consume(tRelOp, &t);
    right = simpleexpr(s);

    if (t.GetValue() == "=")
      relop = opEqual;
    else if (t.GetValue() == "#")
      relop = opNotEqual;
    else if (t.GetValue() == "<")
      relop = opLessThan;
    else if (t.GetValue() == "<=")
      relop = opLessEqual;
    else if (t.GetValue() == ">")
      relop = opBiggerThan;
    else if (t.GetValue() == ">=")
      relop = opBiggerEqual;
    else
      SetError(t, "invalid relation operator.");

    return new CAstBinaryOp(t, relop, left, right);
  }
  else {
    return left;
  }
}

CAstExpression* CParser::simpleexpr(CAstScope *s) {
  //
  // simpleexpr ::= ["+" | "-"] term { termOp term }.
  // termOp = {+, -, ||}.
  //
  
  CAstExpression *n = NULL;
  EOperation eOp;
  CToken tt;

  // unary operation case.
  if(_scanner->Peek().GetType() == tTermOp) {
    CToken t, tOp;

    Consume(tTermOp, &tOp);

    if(tOp.GetValue() == "+")
      eOp = opPos;
    else if(tOp.GetValue() == "-")
      eOp = opNeg;
    else
      SetError(tOp, "invalid term operator");

    CAstExpression *tmp = term(s);

    // If term is constant, then negate it. -> Simple.
    if(dynamic_cast<CAstConstant *>(tmp) != NULL && tmp->GetType()->IsInt()) {
      if(eOp == opNeg)
        dynamic_cast<CAstConstant *>(tmp)->SetValue(-dynamic_cast<CAstConstant *>(tmp)->GetValue());
      
      n = tmp;
    }
    else {
      n = new CAstUnaryOp(tOp, eOp, tmp);
    }

    while(_scanner->Peek().GetType() == tTermOp) {
      CAstExpression *l = n, *r;
      Consume(tTermOp, &tt);
      r = term(s);

      if(tt.GetValue() == "+") {
        n = new CAstBinaryOp(tt, opAdd, l, r);
      }
      else if(tt.GetValue() == "-") {
        n = new CAstBinaryOp(tt, opSub, l, r);
      }
      else {
        n = new CAstBinaryOp(tt, opOr, l, r);
      }
    }

    return n;
  }
  else { // non-unary case.
    n = term(s);

    while (_scanner->Peek().GetType() == tTermOp) {
      CToken t;
      CAstExpression *l = n, *r;

      Consume(tTermOp, &tt);

      r = term(s);
      
      if(tt.GetValue() == "+") {
        n = new CAstBinaryOp(tt, opAdd, l, r);
      }
      else if(tt.GetValue() == "-") {
        n = new CAstBinaryOp(tt, opSub, l, r);
      }
      else {
        n = new CAstBinaryOp(tt, opOr, l, r);
      }
    }

    return n;
  }
}

CAstExpression* CParser::term(CAstScope *s) {
  //
  // term ::= factor { factOp factor }.
  // factOp = {*, /, &&}.
  //

  CAstExpression *n = NULL;

  n = factor(s);

  EToken tt = _scanner->Peek().GetType();

  // Check factOp.
  while ((tt == tFactOp)) {
    CToken t;
    CAstExpression *l = n, *r;

    Consume(tFactOp, &t);
 
    r = factor(s);

    if(t.GetValue() == "*") {
      n = new CAstBinaryOp(t, opMul, l, r);
    }
    else if(t.GetValue() == "/") {
      n = new CAstBinaryOp(t, opDiv, l, r);
    }
    else {
      n = new CAstBinaryOp(t, opAnd, l, r);
    }

    tt = _scanner->Peek().GetType();
  }

  return n;
}

CAstExpression* CParser::factor(CAstScope *s) {
  //
  // factor ::= qualident | number | boolean | char | string | "(" expression ")" | subroutineCall | "!" factor.
  // FIRST(factor) = { tIdent, tNumber, tTrue, tFalse, tCharacter, tString, tLBrak, tEMark }.
  //
  
  CToken t;
  EToken tt = _scanner->Peek().GetType();
  CTypeManager *tm = CTypeManager::Get();
  CAstExpression *n = NULL;
  CSymtab *symtab = s->GetSymbolTable();

  switch(tt) {
    case tTrue:
      Consume(tTrue, &t);
      n = new CAstConstant(t, tm->GetBool(), 1);
      break;

    case tFalse:
      Consume(tFalse, &t);
      n = new CAstConstant(t, tm->GetBool(), 0);
      break;

    case tNumber:
    {
      Consume(tNumber, &t);
      errno = 0;
      long long v = strtoll(t.GetValue().c_str(), NULL, 10);
      if (errno != 0) SetError(t, "invalid number.");

      // integer range validation check.
      if(v > 2147483648)
        SetError(t, "integer constant outside valid range.");

      n = new CAstConstant(t, tm->GetInt(), v);
      break;
    }

    case tIdent:
    {
      Consume(tIdent, &t);

      if(_scanner->Peek().GetType() == tLBrak) { // subroutineCall
        Consume(tLBrak);
        CAstFunctionCall *f;

        // If subroutineCall calls undefined procedure/function, then set error.
        if(symtab->FindSymbol(t.GetValue(),sLocal) == NULL && symtab->FindSymbol(t.GetValue(), sGlobal) != NULL) {
          // Check if symbol is procedure.
          if(dynamic_cast<const CSymProc *>(symtab->FindSymbol(t.GetValue(), sGlobal)) == NULL)
            SetError(t, "invalid procedure/function identifier.");

          f = new CAstFunctionCall(t, dynamic_cast<const CSymProc *>(symtab->FindSymbol(t.GetValue(), sGlobal)));
        }
        else if(symtab->FindSymbol(t.GetValue(), sLocal) != NULL) {
          // Check if symbol is procedure.
          if(dynamic_cast<const CSymProc *>(symtab->FindSymbol(t.GetValue(), sLocal)) == NULL)
            SetError(t, "invalid procedure/function identifier.");

          f = new CAstFunctionCall(t, dynamic_cast<const CSymProc *>(symtab->FindSymbol(t.GetValue(), sLocal)));
        }
        else
          SetError(t, "undefined identifier.");

        assert(f != NULL);

        if(isExpr(_scanner->Peek())) {
          CAstExpression *expr = expression(s);
          assert(expr != NULL);
 
          // If array, then addressed.
          if(expr->GetType()->IsArray())
            expr = new CAstSpecialOp(expr->GetToken(), opAddress, expr, NULL);

          f->AddArg(expr);

          while(_scanner->Peek().GetType() == tComma) {
            Consume(tComma);
            expr = expression(s);
            assert(expr != NULL);
 
            // If array, then addressed.
            if(expr->GetType()->IsArray())
              expr = new CAstSpecialOp(expr->GetToken(), opAddress, expr, NULL);

            f->AddArg(expr);
          }
        }
        Consume(tRBrak);

        n = f;
      }
      else { // qualident
        if(_scanner->Peek().GetType() == tLSBrak) { // It means array
          CAstArrayDesignator *f;

          if(symtab->FindSymbol(t.GetValue(), sLocal) == NULL && symtab->FindSymbol(t.GetValue(), sGlobal) != NULL) {
            // Check if symbol is procedure.
            if(dynamic_cast<const CSymProc *>(symtab->FindSymbol(t.GetValue(), sGlobal)) != NULL)
              SetError(t, "designator expected.");

            f = new CAstArrayDesignator(t, symtab->FindSymbol(t.GetValue(), sGlobal));
          }
          else if(symtab->FindSymbol(t.GetValue(), sLocal) != NULL) {
            // Check if symbol is procedure.
            if(dynamic_cast<const CSymProc *>(symtab->FindSymbol(t.GetValue(), sLocal)) != NULL)
              SetError(t, "designator expected");

            f = new CAstArrayDesignator(t, symtab->FindSymbol(t.GetValue(), sLocal));
          }
          else {
            SetError(t, "undefined identifier.");
          }
          
          while(_scanner->Peek().GetType() == tLSBrak) {
            Consume(tLSBrak);

            CAstExpression *expr = expression(s);
            assert(expr != NULL);
            f->AddIndex(expr);

            Consume(tRSBrak);
          }

          f->IndicesComplete();

          n = f;
        } // non-array case.
        else {
          if(symtab->FindSymbol(t.GetValue(), sLocal) == NULL && symtab->FindSymbol(t.GetValue(), sGlobal) != NULL) {
            // Check if symbol is procedure.
            if(dynamic_cast<const CSymProc *>(symtab->FindSymbol(t.GetValue(), sGlobal)) != NULL) {
              SetError(t, "designator expected.");
            }
            n = new CAstDesignator(t, symtab->FindSymbol(t.GetValue(), sGlobal));
          }
          else if(symtab->FindSymbol(t.GetValue(), sLocal) != NULL) {
            // Check if symbol is procedure.
            if(dynamic_cast<const CSymProc *>(symtab->FindSymbol(t.GetValue(), sLocal)) != NULL) {
              SetError(t, "designator expected.");
            }
            n = new CAstDesignator(t, symtab->FindSymbol(t.GetValue(), sLocal));
          }
          else
            SetError(t, "undefined identifier.");
        }
      }
      break;
    }

    case tString:
      Consume(tString, &t);
      n = new CAstStringConstant(t, t.GetValue(), s);
      break;

    case tCharacter:
    {
      Consume(tCharacter, &t);
      char res;

      // If character length is 0, it means character is '\0' because invalid character cases are handled in scanner.
      if(t.GetValue().length() == 0)
        res = '\0';
      else if(t.GetValue().length() == 1) {
        if(t.GetValue().at(0) != '\\')
          res = t.GetValue().at(0);
        else SetError(t, "wrong character");
      }
      // unescape.
      else if(t.GetValue().length() == 2) {
        if(t.GetValue().at(0) == '\\') {
          if(t.GetValue().at(1) == 'n') {
            res = '\n';
          }
          else if(t.GetValue().at(1) == 't') {
            res = '\t';
          }
          else if(t.GetValue().at(1) == '"') {
            res = '"';
          }
          else if(t.GetValue().at(1) == '\'') {
            res = '\'';
          }
          else if(t.GetValue().at(1) == '\\') {
            res = '\\';
          }
          else if(t.GetValue().at(1) == '0') {
            res = '\0';
          }
          else
            SetError(t, "wrong character");
        }
      }
      else SetError(t, "wrong character");

      n = new CAstConstant(t, tm->GetChar(), (long long)res);
      break;
    }

    case tLBrak:
      Consume(tLBrak);
      n = expression(s);
      Consume(tRBrak);
      break;

    case tEMark:
      Consume(tEMark, &t);
      n = new CAstUnaryOp(t, opNot, factor(s));
      break;

    default:
//      cout << "got " << _scanner->Peek() << endl;
      SetError(_scanner->Peek(), "factor expected.");
      break;
  }

  return n;
}

// Check whether token is FIRST(expression).
static bool isExpr(CToken t) {
  //
  // FIRST(expression) = {tIdent, tNumber, tTrue, tFalse, tCharacter, tString, tLBrak, tEMark, tTermOp}.
  //

  EToken tt = t.GetType();

  switch(tt) {
    case tIdent:
    case tNumber:
    case tTrue:
    case tFalse:
    case tCharacter:
    case tString:
    case tLBrak:
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
