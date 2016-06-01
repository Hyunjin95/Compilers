//------------------------------------------------------------------------------
/// @brief SnuPL backend
/// @author Bernhard Egger <bernhard@csap.snu.ac.kr>
/// @section changelog Change Log
/// 2012/11/28 Bernhard Egger created
/// 2013/06/09 Bernhard Egger adapted to SnuPL/0
/// 2016/04/04 Bernhard Egger adapted to SnuPL/1
///
/// @section license_section License
/// Copyright (c) 2012-2016 Bernhard Egger
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

#include <fstream>
#include <sstream>
#include <iomanip>
#include <cassert>

#include "backend.h"
using namespace std;


//------------------------------------------------------------------------------
// CBackend
//
CBackend::CBackend(ostream &out)
  : _out(out)
{
}

CBackend::~CBackend(void)
{
}

bool CBackend::Emit(CModule *m)
{
  assert(m != NULL);
  _m = m;

  if (!_out.good()) return false;

  bool res = true;

  try {
    EmitHeader();
    EmitCode();
    EmitData();
    EmitFooter();

    res = _out.good();
  } catch (...) {
    res = false;
  }

  return res;
}

void CBackend::EmitHeader(void)
{
}

void CBackend::EmitCode(void)
{
}

void CBackend::EmitData(void)
{
}

void CBackend::EmitFooter(void)
{
}


//------------------------------------------------------------------------------
// CBackendx86
//
CBackendx86::CBackendx86(ostream &out)
  : CBackend(out), _curr_scope(NULL)
{
  _ind = string(4, ' ');
}

CBackendx86::~CBackendx86(void)
{
}

void CBackendx86::EmitHeader(void)
{
  _out << "##################################################" << endl
       << "# " << _m->GetName() << endl
       << "#" << endl
       << endl;
}

void CBackendx86::EmitCode(void)
{
  _out << _ind << "#-----------------------------------------" << endl
       << _ind << "# text section" << endl
       << _ind << "#" << endl
       << _ind << ".text" << endl
       << _ind << ".align 4" << endl
       << endl
       << _ind << "# entry point and pre-defined functions" << endl
       << _ind << ".global main" << endl
       << _ind << ".extern DIM" << endl
       << _ind << ".extern DOFS" << endl
       << _ind << ".extern ReadInt" << endl
       << _ind << ".extern WriteInt" << endl
       << _ind << ".extern WriteStr" << endl
       << _ind << ".extern WriteChar" << endl
       << _ind << ".extern WriteLn" << endl
       << endl;

  // Get subscopes.
  const vector<CScope *> subscopes = _m->GetSubscopes();

  // for all subscope, EmitScope(s).
  for(int i = 0; i < subscopes.size(); i++) {
    CScope *s = subscopes.at(i);
    EmitScope(s);
  }

  // EmitScope program.
  EmitScope(_m);

  _out << _ind << "# end of text section" << endl
       << _ind << "#-----------------------------------------" << endl
       << endl;
}

void CBackendx86::EmitData(void)
{
  _out << _ind << "#-----------------------------------------" << endl
       << _ind << "# global data section" << endl
       << _ind << "#" << endl
       << _ind << ".data" << endl
       << _ind << ".align 4" << endl
       << endl;

  EmitGlobalData(_m);

  _out << _ind << "# end of global data section" << endl
       << _ind << "#-----------------------------------------" << endl
       << endl;
}

void CBackendx86::EmitFooter(void)
{
  _out << _ind << ".end" << endl
       << "##################################################" << endl;
}

void CBackendx86::SetScope(CScope *scope)
{
  _curr_scope = scope;
}

CScope* CBackendx86::GetScope(void) const
{
  return _curr_scope;
}

void CBackendx86::EmitScope(CScope *scope)
{
  assert(scope != NULL);

  string label;

  if (scope->GetParent() == NULL) label = "main";
  else label = scope->GetName();

  // Set current scope to SCOPE.
  SetScope(scope);

  // label
  _out << _ind << "# scope " << scope->GetName() << endl
       << label << ":" << endl;

  // Get Stack offset size.
  int size = ComputeStackOffsets(scope->GetSymbolTable(), 8, -12);

  // Emit function prologue
  _out << left << _ind << "# prologue" << endl;

  EmitInstruction("pushl", "%ebp");
  EmitInstruction("movl", "%esp, %ebp");
  EmitInstruction("pushl", "%ebx", "save callee saved registers");
  EmitInstruction("pushl", "%esi");
  EmitInstruction("pushl", "%edi");
  EmitInstruction("subl", "$" + to_string(size) + ", %esp", "make room for locals");

  // Initialize local stack area when size < 20
  if(size < 20 && size > 0) {
    _out << endl;
    EmitInstruction("xorl", "%eax, %eax", "memset local stack area to 0");
    
    for(int i = size / 4; i > 0; i--) {
      EmitInstruction("movl", "%eax, " + to_string((i-1)*4) + "(%esp)");
    }
  }
  else if(size >= 20) { // Initialize local stack area when size >= 20
    _out << endl;
    EmitInstruction("cld", "", "memset local stack area to 0");
    EmitInstruction("xorl", "%eax, %eax");
    EmitInstruction("movl", "$" + to_string((size/4)) + ", %ecx");
    EmitInstruction("mov", "%esp, %edi");
    EmitInstruction("rep", "stosl");
  }

  // Get Symbol list
  vector<CSymbol*> slist = scope->GetSymbolTable()->GetSymbols();

  for(int i = 0; i < slist.size(); i++) {
    CSymbol *sym = slist.at(i);

    // Find local arrays
    if(!dynamic_cast<CSymParam *>(sym) && dynamic_cast<CSymLocal *>(sym)) {
      if(dynamic_cast<CSymLocal *>(sym)->GetDataType()->IsArray()) {
        const CArrayType *local_arr = dynamic_cast<const CArrayType *>(dynamic_cast<CSymLocal *>(sym)->GetDataType());

        // Get dimension number.
        int dim_num = local_arr->GetNDim();

        // Emit prologue instructions for array
        EmitInstruction("movl", "$" + to_string(dim_num) + "," + to_string(sym->GetOffset()) + "(" + sym->GetBaseRegister() + ")",
            "local array '" + sym->GetName() + "': " + to_string(dim_num) + " dimensions");

        for(int j = 0; j < dim_num; j++) {
          EmitInstruction("movl",
              "$" + to_string(local_arr->GetNElem()) + "," + to_string(sym->GetOffset() + 4 + j*4) + "(" + sym->GetBaseRegister() + ")",
              "  dimension " + to_string(j+1) + ": " + to_string(local_arr->GetNElem()) + " elements");

          local_arr = dynamic_cast<const CArrayType *>(local_arr->GetInnerType());
        }
      }
    }
  }

  // Get instruction list
  const list<CTacInstr *> instrs = scope->GetCodeBlock()->GetInstr();
 
  // for all instruction, EmitInstruction(i)
  _out << endl << left << _ind << "# function body" << endl;
  list<CTacInstr *>::const_iterator instr = instrs.begin();
  while (instr != instrs.end()) {
    EmitInstruction(*instr++);
  }

  // Emit function epilogue.
  _out << endl << Label("exit") << ":" << endl << _ind << "# epilogue" << endl;
  EmitInstruction("addl", "$" + to_string(size) + ", %esp", "remove locals");
  EmitInstruction("popl", "%edi");
  EmitInstruction("popl", "%esi");
  EmitInstruction("popl", "%ebx");
  EmitInstruction("popl", "%ebp");
  EmitInstruction("ret", "");

  _out << endl;
}

void CBackendx86::EmitGlobalData(CScope *scope)
{
  assert(scope != NULL);

  // emit the globals for the current scope
  CSymtab *st = scope->GetSymbolTable();
  assert(st != NULL);

  bool header = false;

  vector<CSymbol*> slist = st->GetSymbols();

  _out << dec;

  size_t size = 0;

  for (size_t i=0; i<slist.size(); i++) {
    CSymbol *s = slist[i];
    const CType *t = s->GetDataType();

    if (s->GetSymbolType() == stGlobal) {
      if (!header) {
        _out << _ind << "# scope: " << scope->GetName() << endl;
        header = true;
      }

      // insert alignment only when necessary
      if ((t->GetAlign() > 1) && (size % t->GetAlign() != 0)) {
        size += t->GetAlign() - size % t->GetAlign();
        _out << setw(4) << " " << ".align "
             << right << setw(3) << t->GetAlign() << endl;
      }

      _out << left << setw(36) << s->GetName() + ":" << "# " << t << endl;

      if (t->IsArray()) {
        const CArrayType *a = dynamic_cast<const CArrayType*>(t);
        assert(a != NULL);
        int dim = a->GetNDim();

        _out << setw(4) << " "
          << ".long " << right << setw(4) << dim << endl;

        for (int d=0; d<dim; d++) {
          assert(a != NULL);

          _out << setw(4) << " "
            << ".long " << right << setw(4) << a->GetNElem() << endl;

          a = dynamic_cast<const CArrayType*>(a->GetInnerType());
        }
      }

      const CDataInitializer *di = s->GetData();
      if (di != NULL) {
        const CDataInitString *sdi = dynamic_cast<const CDataInitString*>(di);
        assert(sdi != NULL);  // only support string data initializers for now

        _out << left << setw(4) << " "
          << ".asciz " << '"' << sdi->GetData() << '"' << endl;
      } else {
        _out  << left << setw(4) << " "
          << ".skip " << dec << right << setw(4) << t->GetDataSize()
          << endl;
      }

      size += t->GetSize();
    }
  }

  _out << endl;

  // emit globals in subscopes (necessary if we support static local variables)
  vector<CScope*>::const_iterator sit = scope->GetSubscopes().begin();
  while (sit != scope->GetSubscopes().end()) EmitGlobalData(*sit++);
}

void CBackendx86::EmitLocalData(CScope *scope)
{
  assert(scope != NULL);

  // TODO TODO!
}

void CBackendx86::EmitCodeBlock(CCodeBlock *cb)
{
  assert(cb != NULL);

  const list<CTacInstr*> &instr = cb->GetInstr();
  list<CTacInstr*>::const_iterator it = instr.begin();

  while (it != instr.end()) EmitInstruction(*it++);
}

void CBackendx86::EmitInstruction(CTacInstr *i)
{
  assert(i != NULL);

  ostringstream cmt;
  string mnm;
  cmt << i;

  EOperation op = i->GetOperation();

  switch (op) {
    // binary operators
    // dst = src1 op src2
    case opAdd:
    case opSub:
    case opMul:
    case opDiv:
    case opAnd:
    case opOr:
      EmitInstruction("# ???", "not implemented", cmt.str());
      break;

    // unary operators
    // dst = op src1
    case opNeg:
    case opPos:
    case opNot:
      EmitInstruction("# ???", "not implemented", cmt.str());
      break;

    // memory operations
    // dst = src1
    case opAssign:
      EmitInstruction("# ???", "not implemented", cmt.str());
      break;

    // pointer operations
    // dst = &src1
    case opAddress:
      EmitInstruction("# ???", "not implemented", cmt.str());
      break;

    // dst = *src1
    case opDeref:
      // opDeref not generated for now
      EmitInstruction("# opDeref", "not implemented", cmt.str());
      break;

    // unconditional branching
    // goto dst
    case opGoto:
      EmitInstruction("# ???", "not implemented", cmt.str());
      break;

    // conditional branching
    // if src1 relOp src2 then goto dst
    case opEqual:
    case opNotEqual:
    case opLessThan:
    case opLessEqual:
    case opBiggerEqual:
    case opBiggerThan:
      EmitInstruction("# ???", "not implemented", cmt.str());
      break;

    // function call-related operations
    case opCall:
    case opReturn:
    case opParam:
      EmitInstruction("# ???", "not implemented", cmt.str());
      break;

    // special
    case opLabel:
      _out << Label(dynamic_cast<CTacLabel*>(i)) << ":" << endl;
      break;

    case opNop:
      EmitInstruction("nop", "", cmt.str());
      break;


    default:
      EmitInstruction("# ???", "not implemented", cmt.str());
  }
}

void CBackendx86::EmitInstruction(string mnemonic, string args, string comment)
{
  _out << left
       << _ind
       << setw(7) << mnemonic << " "
       << setw(23) << args;
  if (comment != "") _out << " # " << comment;
  _out << endl;
}

void CBackendx86::Load(CTacAddr *src, string dst, string comment)
{
  assert(src != NULL);

  string mnm = "mov";
  string mod = "l";

  // set operator modifier based on the operand size
  switch (OperandSize(src)) {
    case 1: mod = "zbl"; break;
    case 2: mod = "zwl"; break;
    case 4: mod = "l"; break;
  }

  // emit the load instruction
  EmitInstruction(mnm + mod, Operand(src) + ", " + dst, comment);
}

void CBackendx86::Store(CTac *dst, char src_base, string comment)
{
  assert(dst != NULL);

  string mnm = "mov";
  string mod = "l";
  string src = "%";

  // compose the source register name based on the operand size
  switch (OperandSize(dst)) {
    case 1: mod = "b"; src += string(1, src_base) + "l"; break;
    case 2: mod = "w"; src += string(1, src_base) + "x"; break;
    case 4: mod = "l"; src += "e" + string(1, src_base) + "x"; break;
  }

  // emit the store instruction
  EmitInstruction(mnm + mod, src + ", " + Operand(dst), comment);
}

string CBackendx86::Operand(const CTac *op)
{
  string operand;

  // CTacReference
  if(dynamic_cast<const CTacReference *>(op)) {
    operand = dynamic_cast<const CTacReference *>(op)->GetDerefSymbol()->GetName();
  }
  else { // Others
    operand = dynamic_cast<const CTacName *>(op)->GetSymbol()->GetName();
  }

  return operand;
}

string CBackendx86::Imm(int value) const
{
  ostringstream o;
  o << "$" << dec << value;
  return o.str();
}

string CBackendx86::Label(const CTacLabel* label) const
{
  CScope *cs = GetScope();
  assert(cs != NULL);

  ostringstream o;
  o << "l_" << cs->GetName() << "_" << label->GetLabel();
  return o.str();
  return "l_" + cs->GetName() + "_" + label->GetLabel();
}

string CBackendx86::Label(string label) const
{
  CScope *cs = GetScope();
  assert(cs != NULL);

  return "l_" + cs->GetName() + "_" + label;
}

string CBackendx86::Condition(EOperation cond) const
{
  switch (cond) {
    case opEqual:       return "e";
    case opNotEqual:    return "ne";
    case opLessThan:    return "l";
    case opLessEqual:   return "le";
    case opBiggerThan:  return "g";
    case opBiggerEqual: return "ge";
    default:            assert(false); break;
  }
}

int CBackendx86::OperandSize(CTac *t) const
{
  int size = 4;

  
  // TODO
  // compute the size for operand t of type CTacName
  // Hint: you need to take special care of references (incl. references to pointers!)
  //       and arrays. Compare your output to that of the reference implementation
  //       if you are not sure.

  return size;
}

size_t CBackendx86::ComputeStackOffsets(CSymtab *symtab,
                                        int param_ofs,int local_ofs)
{
  assert(symtab != NULL);
  vector<CSymbol*> slist = symtab->GetSymbols();
  int size = 0;

  for(int i = 0; i < slist.size(); i++) {
    CSymbol *sym = slist.at(i);

    // parameter
    if(dynamic_cast<CSymParam *>(sym)) {
      CSymParam *sym_param = dynamic_cast<CSymParam *>(sym);

      int off_param = param_ofs + (sym_param->GetIndex())*4;

      // Set offset
      sym->SetOffset(off_param);

      // Set base register to %ebp
      sym->SetBaseRegister("%ebp");
    } // local
    else if(dynamic_cast<CSymLocal *>(sym)) {
      CSymLocal *sym_local = dynamic_cast<CSymLocal *>(sym);
      size += sym_local->GetDataType()->GetSize();
      
      int off_local = local_ofs - sym_local->GetDataType()->GetSize();

      // 4-byte alignment
      if(sym_local->GetDataType()->IsInt() || sym_local->GetDataType()->IsPointer() || sym_local->GetDataType()->IsArray()) {
        while(off_local % 4 != 0) {
          off_local--;
          size++;
        }
      }

      local_ofs = off_local;

      // Set offset
      sym->SetOffset(off_local);

      // Set base register to %ebp
      sym->SetBaseRegister("%ebp");
    }
  }

  // 4-byte alignment
  while(size % 4 != 0) size++;
  
  // dump stack frame to assembly file
  _out << _ind << "# stack offsets:" << endl;
  for(int i = 0; i < slist.size(); i++) {
    CSymbol *sym = slist.at(i);
    if(dynamic_cast<CSymParam *>(sym) || dynamic_cast<CSymLocal *>(sym)) {
      stringstream ss;
      sym->print(ss);
      _out << _ind << "#" << "   " << right << setw(4) << to_string(sym->GetOffset()) << "(" << sym->GetBaseRegister() << ")"
        << right << "  " << setw(2) << sym->GetDataType()->GetSize() << "  " << ss.str() << endl;
    }
  }

  _out << endl;

  return size;
}
