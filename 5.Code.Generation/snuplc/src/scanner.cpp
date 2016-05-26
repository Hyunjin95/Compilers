//------------------------------------------------------------------------------
/// @brief SnuPL/1 scanner
/// @author Bernhard Egger <bernhard@csap.snu.ac.kr>
/// @section changelog Change Log
/// 2012/09/14 Bernhard Egger created
/// 2013/03/07 Bernhard Egger adapted to SnuPL/0
/// 2014/09/10 Bernhard Egger assignment 1: scans SnuPL/-1
/// 2016/03/13 Bernhard Egger assignment 1: adapted to modified SnuPL/-1 syntax
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

#include <iostream>
#include <sstream>
#include <cctype>
#include <cstdlib>
#include <cstring>
#include <cassert>
#include <cstdio>

#include "scanner.h"
using namespace std;

//------------------------------------------------------------------------------
// token names
//
#define TOKEN_STRLEN 16

char ETokenName[][TOKEN_STRLEN] = {
  "tCharacter",                       ///< a character
  "tString",                          ///< a string

  "tIdent",                           ///< an identifier
  "tNumber",                          ///< a number

  "tTermOp",                          ///< '+' or '-' or '&&'
  "tFactOp",                          ///< '*' or '/' or '||'
  "tRelOp",                           ///< relational operator
  
  "tAssign",                          ///< assignment operator ':='
  "tSemicolon",                       ///< a semicolon ';'
  "tColon",                           ///< a colon ':'
  "tDot",                             ///< a dot '.'
  "tComma",                           ///< a comma ','
  "tLBrak",                           ///< a left bracket '('
  "tRBrak",                           ///< a right bracket ')'
  "tLSBrak",                          ///< a left square bracket '['
  "tRSBrak",                          ///< a right square bracket ']'
  "tEMark",                           ///< an exclamation mark '!'

  "tModule",                          ///< a reserved keyword 'module'
  "tBegin",                           ///< a reserved keyword 'begin'
  "tEnd",                             ///< a reserved keyword 'end'
  "tTrue",                            ///< a reserved keyword 'true'
  "tFalse",                           ///< a reserved keyword 'false'
  "tBoolean",                         ///< a reserved keyword 'boolean'
  "tChar",                            ///< a reserved keyword 'char'
  "tInteger",                         ///< a reserved keyword 'integer'
  "tIf",                              ///< a reserved keyword 'if'
  "tThen",                            ///< a reserved keyword 'then'
  "tElse",                            ///< a reserved keyword 'else'
  "tWhile",                           ///< a reserved keyword 'while'
  "tDo",                              ///< a reserved keyword 'do'
  "tReturn",                          ///< a reserved keyword 'return'
  "tVar",                             ///< a reserved keyword 'var'
  "tProcedure",                       ///< a reserved keyword 'procedure'
  "tFunction",                        ///< a reserved keyword 'function'

  "tEOF",                             ///< end of file
  "tIOError",                         ///< I/O error
  "tUndefined",                       ///< undefined 
};


//------------------------------------------------------------------------------
// format strings used for printing tokens
//

char ETokenStr[][TOKEN_STRLEN] = {
  "tCharacter (%s)",                  ///< a character
  "tString (%s)",                     ///< a string

  "tIdent (%s)",                      ///< an identifier
  "tNumber (%s)",                     ///< a number

  "tTermOp (%s)",                     ///< '+' or '-' or '&&'
  "tFactOp (%s)",                     ///< '*' or '/' or '||'
  "tRelOp (%s)",                      ///< relational operator
  
  "tAssign",                          ///< assignment operator ':='
  "tSemicolon",                       ///< a semicolon ';'
  "tColon",                           ///< a colon ':'
  "tDot",                             ///< a dot '.'
  "tComma",                           ///< a comma ','
  "tLBrak",                           ///< a left bracket '('
  "tRBrak",                           ///< a right bracket ')'
  "tLSBrak",                          ///< a left square bracket '['
  "tRSBrak",                          ///< a right square bracket ']'
  "tEMark",                           ///< an exclamation mark '!'

  "tModule",                          ///< a reserved keyword 'module'
  "tBegin",                           ///< a reserved keyword 'begin'
  "tEnd",                             ///< a reserved keyword 'end'
  "tTrue",                            ///< a reserved keyword 'true'
  "tFalse",                           ///< a reserved keyword 'false'
  "tBoolean",                         ///< a reserved keyword 'boolean'
  "tChar",                            ///< a reserved keyword 'char'
  "tInteger",                         ///< a reserved keyword 'integer'
  "tIf",                              ///< a reserved keyword 'if'
  "tThen",                            ///< a reserved keyword 'then'
  "tElse",                            ///< a reserved keyword 'else'
  "tWhile",                           ///< a reserved keyword 'while'
  "tDo",                              ///< a reserved keyword 'do'
  "tReturn",                          ///< a reserved keyword 'return'
  "tVar",                             ///< a reserved keyword 'var'
  "tProcedure",                       ///< a reserved keyword 'procedure'
  "tFunction",                        ///< a reserved keyword 'function'

  "tEOF",                             ///< end of file
  "tIOError",                         ///< I/O error
  "tUndefined (%s)",                  ///< undefined
};


//------------------------------------------------------------------------------
// reserved keywords
//
pair<const char*, EToken> Keywords[] =
{
  make_pair("module", tModule),
  make_pair("begin", tBegin),
  make_pair("end", tEnd),
  make_pair("true", tTrue),
  make_pair("false", tFalse),
  make_pair("boolean", tBoolean),
  make_pair("char", tChar),
  make_pair("integer", tInteger),
  make_pair("if", tIf),
  make_pair("then", tThen),
  make_pair("else", tElse),
  make_pair("end", tEnd),
  make_pair("while", tWhile),
  make_pair("do", tDo),
  make_pair("return", tReturn),
  make_pair("var", tVar),
  make_pair("procedure", tProcedure),
  make_pair("function", tFunction),
};



//------------------------------------------------------------------------------
// CToken
//
CToken::CToken()
{
  _type = tUndefined;
  _value = "";
  _line = _char = 0;
}

CToken::CToken(int line, int charpos, EToken type, const string value)
{
  _type = type;
  _value = escape(value);
  _line = line;
  _char = charpos;
}

CToken::CToken(const CToken &token)
{
  _type = token.GetType();
  _value = token.GetValue();
  _line = token.GetLineNumber();
  _char = token.GetCharPosition();
}

CToken::CToken(const CToken *token)
{
  _type = token->GetType();
  _value = token->GetValue();
  _line = token->GetLineNumber();
  _char = token->GetCharPosition();
}

const string CToken::Name(EToken type)
{
  return string(ETokenName[type]);
}

const string CToken::GetName(void) const
{
  return string(ETokenName[GetType()]);
}

ostream& CToken::print(ostream &out) const
{
  int str_len = _value.length();
  str_len = TOKEN_STRLEN + (str_len < 64 ? str_len : 64);
  char *str = (char*)malloc(str_len);
  snprintf(str, str_len, ETokenStr[GetType()], _value.c_str());
  out << dec << _line << ":" << _char << ": " << str;
  free(str);
  return out;
}

string CToken::escape(const string text)
{
  const char *t = text.c_str();
  string s;

  while (*t != '\0') {
    switch (*t) {
      case '\n': s += "\\n";  break;
      case '\t': s += "\\t";  break;
      case '\0': s += "\\0";  break;
      case '\'': s += "\\'";  break;
      case '\"': s += "\\\""; break;
      case '\\': s += "\\\\"; break;
      default :  s += *t;
    }
    t++;
  }

  return s;
}

string CToken::unescape(const string text) {
  const char *t = text.c_str();
  string s;

  while (*t != '\0') {
    if(*t == '\\') {
      switch(*++t) {
        case 'n': s += "\n"; break;
        case 't': s += "\t"; break;
        case '0': s += "\0"; break;
        case '\'': s += "'"; break;
        case '"': s += "\""; break;
        case '\\': s += "\\"; break;
        default : s += '?';
      }
    }
    else {
      s += *t;
    }
    t++;
  }

  return s;
}

ostream& operator<<(ostream &out, const CToken &t)
{
  return t.print(out);
}

ostream& operator<<(ostream &out, const CToken *t)
{
  return t->print(out);
}


//------------------------------------------------------------------------------
// CScanner
//
map<string, EToken> CScanner::keywords;

CScanner::CScanner(istream *in)
{
  InitKeywords();
  _in = in;
  _delete_in = false;
  _line = _char = 1;
  _token = NULL;
  _good = in->good();
  NextToken();
}

CScanner::CScanner(string in)
{
  InitKeywords();
  _in = new istringstream(in);
  _delete_in = true;
  _line = _char = 1;
  _token = NULL;
  _good = true;
  NextToken();
}

CScanner::~CScanner()
{
  if (_token != NULL) delete _token;
  if (_delete_in) delete _in;
}

void CScanner::InitKeywords(void)
{
  if (keywords.size() == 0) {
    int size = sizeof(Keywords) / sizeof(Keywords[0]);
    for (int i=0; i<size; i++) {
      keywords[Keywords[i].first] = Keywords[i].second;
    }
  }
}

CToken CScanner::Get()
{
  CToken result(_token);

  EToken type = _token->GetType();
  _good = !(type == tIOError);

  NextToken();
  return result;
}

CToken CScanner::Peek() const
{
  return CToken(_token);
}

void CScanner::NextToken()
{
  if (_token != NULL) delete _token;

  _token = Scan();
}

void CScanner::RecordStreamPosition()
{
  _saved_line = _line;
  _saved_char = _char;
}

void CScanner::GetRecordedStreamPosition(int *lineno, int *charpos)
{
  *lineno = _saved_line;
  *charpos = _saved_char;
}

CToken* CScanner::NewToken(EToken type, const string token)
{
  return new CToken(_saved_line, _saved_char, type, token);
}

CToken* CScanner::Scan()
{
  EToken token;
  string tokval;
  char c;

  // Consume all white spaces.
  while (_in->good() && IsWhite(_in->peek())) GetChar();

  RecordStreamPosition();
  
  if (_in->eof()) return NewToken(tEOF);
  if (!_in->good()) return NewToken(tIOError);

  c = GetChar();
  
  // Consume comments.
  if(c == '/') {
    while(_in->peek() == '/') { // consume consecutive comments.
      while(_in->peek() != '\n') GetChar(); // consume one line.
      while(IsWhite(_in->peek())) GetChar(); // consume white spaces.
      
      RecordStreamPosition();
      c = GetChar();
      if(c != '/') {
        if(c == EOF) return NewToken(tEOF);
        break;
      }
    }
  }
  
  tokval = c;
  token = tUndefined;

  switch (c) {
    case ':':
      token = tColon;
      if (_in->peek() == '=') {
        tokval += GetChar();
        token = tAssign;
      }
      break;
    
    case ';':
      token = tSemicolon;
      break;
    
    case '.':
      token = tDot;
      break;

    case ',':
      token = tComma;
      break;

    case '(':
      token = tLBrak;
      break;

    case ')':
      token = tRBrak;
      break;

    case '[':
      token = tLSBrak;
      break;

    case ']':
      token = tRSBrak;
      break;

    case '!':
      token = tEMark;
      break;

    case '+':
    case '-':
      token = tTermOp;
      break;

    case '|':
      if (_in->peek() == '|') {
        token = tTermOp;
        tokval += GetChar();
      }
      break;

    case '*':
      token = tFactOp;
      break;

    case '/':
      token = tFactOp;
      break;

    case '&':
      if (_in->peek() == '&') {
        token = tFactOp;
        tokval += GetChar();
      }
      break;

    case '=':
    case '#':
      token = tRelOp;
      break;

    case '<':
    case '>':
      token = tRelOp;
      if (_in->peek() == '=')
        tokval += GetChar();
      break;

    case '\'':
    {
      int length = 0;
      char tmp_char;
      bool is_valid = true;
      bool is_char, is_escape;

      // Get all characters before second '\''.
      while(_in->peek() != '\'' && _in->peek() != EOF) {
        is_char = true;
        is_escape = false;
        tmp_char = GetChar();
        tokval += tmp_char;
        length++;

        // Valid escape characters.
        if(tmp_char == '\\') {
          if(_in->peek() == 'n') {
            GetChar();
            is_escape = true;
            tokval = tokval.substr(0, tokval.length() - 1);
            tokval += '\n';
          }
          else if(_in->peek() == 't') {
            GetChar();
            is_escape = true;
            tokval = tokval.substr(0, tokval.length() - 1);
            tokval += '\t';
          }
          else if(_in->peek() == '\'') {
            GetChar();
            is_escape = true;
            tokval = tokval.substr(0, tokval.length() - 1);
            tokval += '\'';
          }
          else if(_in->peek() == '"') {
            GetChar();
            is_escape = true;
            tokval = tokval.substr(0, tokval.length() - 1);
            tokval += '\"';
          }
          else if(_in->peek() == '0') {
            GetChar();
            is_escape = true;
            tokval = tokval.substr(0, tokval.length() - 1);
            tokval += '\0';
          }
          else if(_in->peek() == '\\') {
            GetChar();
            is_escape = true;
            tokval = tokval.substr(0, tokval.length() - 1);
            tokval += '\\';
          }
        }
        // Check whether input is ASCII character.
        else if(!IsChar(tmp_char)) is_char = false;

        if(!(is_char || is_escape)) is_valid = false;
      }
      
      if(_in->peek() != EOF) tokval += GetChar();

      // Check whether length is 1 and character is valid.
      if(length == 1 && is_valid) {
        token = tCharacter;
        tokval = tokval.substr(1, tokval.length() - 2);
      }
    }
      break;

    case '"':
    {
      char tmp_char;
      bool is_valid = true;
      bool is_char, is_escape;

      // Get all characters before second '"'
      while(_in->peek() != '"' && _in->peek() != EOF) {
        is_char = true;
        is_escape = false;
        tmp_char = GetChar();
        tokval += tmp_char;

        // Valid escape characters.
        if(tmp_char == '\\') {
          if(_in->peek() == 'n') {
            GetChar();
            is_escape = true;
            tokval = tokval.substr(0, tokval.length() - 1);
            tokval += '\n';
          }
          else if(_in->peek() == 't') {
            GetChar();
            is_escape = true;
            tokval = tokval.substr(0, tokval.length() - 1);
            tokval += '\t';
          }
          else if(_in->peek() == '\'') {
            GetChar();
            is_escape = true;
            tokval = tokval.substr(0, tokval.length() - 1);
            tokval += '\'';
          }
          else if(_in->peek() == '"') {
            GetChar();
            is_escape = true;
            tokval = tokval.substr(0, tokval.length() - 1);
            tokval += '\"';
          }
          else if(_in->peek() == '0') {
            GetChar();
            is_escape = true;
            tokval = tokval.substr(0, tokval.length() - 1);
            tokval += '\0';
          }
          else if(_in->peek() == '\\') {
            GetChar();
            is_escape = true;
            tokval = tokval.substr(0, tokval.length() - 1);
            tokval += '\\';
          }
        }
        // Check whether input is ASCII character.
        else if(!IsChar(tmp_char)) is_char = false;

        if(!(is_char || is_escape)) is_valid = false;
      }
      
      if(_in->peek() != EOF) tokval += GetChar();

      // Check whether all characters are valid.
      if(is_valid) {
        token = tString;
        tokval = tokval.substr(1, tokval.length() - 2);
      }
    }
      break;
   

    default:
      if (IsLetter(c)) {
        while(IsLetter(_in->peek()) || IsDigit(_in->peek()))
          tokval += GetChar();
        
        // Check whether input is reserved keyword.
        map<string, EToken>::iterator it = keywords.find(tokval);
        if(it != keywords.end()) token = (*it).second;
        else token = tIdent;
      }
      else if (IsDigit(c)) {
        token = tNumber;
        while(IsDigit(_in->peek()))
          tokval += GetChar();
      }
      // return tUndefined token if error.
      else token = tUndefined;
      break;
  }

  return NewToken(token, tokval);
}

bool CScanner:: IsLetter(char c) const {
  return ((c >= 'A' && c <= 'Z') || (c >= 'a' && c <= 'z') || (c == '_'));
}

bool CScanner:: IsDigit(char c) const {
  return (c >= '0' && c <= '9');
}

bool CScanner:: IsChar(char c) const {
  return (((int)c >= 32 && (int) c <= 126));
}

char CScanner::GetChar()
{
  char c = _in->get();
  if (c == '\n') { _line++; _char = 1; } else _char++;
  return c;
}

string CScanner::GetChar(int n)
{
  string str;
  for (int i=0; i<n; i++) str += GetChar();
  return str;
}

bool CScanner::IsWhite(char c) const
{
  return ((c == ' ') || (c == '\n') || (c == '\t'));
}
