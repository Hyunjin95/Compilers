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
  size_t size = ComputeStackOffsets(scope->GetSymbolTable(), 8, -12);

  // Emit function prologue
  _out << left << _ind << "# prologue" << endl;

  EmitInstruction("pushl", "%ebp");
  EmitInstruction("movl", "%esp, %ebp");
  EmitInstruction("pushl", "%ebx", "save callee saved registers");
  EmitInstruction("pushl", "%esi");
  EmitInstruction("pushl", "%edi");
  EmitInstruction("subl", Imm((int)size) + ", %esp", "make room for locals");

  // Initialize local stack area when size < 20
  if(size > 0 && size < 20) {
    _out << endl;
    EmitInstruction("xorl", "%eax, %eax", "memset local stack area to 0");
    
    for(int i = (int)size / 4; i > 0; i--) {
      EmitInstruction("movl", "%eax, " + to_string((i-1)*4) + "(%esp)");
    }
  }
  else if(size >= 20) { // Initialize local stack area when size >= 20
    _out << endl;
    EmitInstruction("cld", "", "memset local stack area to 0");
    EmitInstruction("xorl", "%eax, %eax");
    EmitInstruction("movl", Imm((int)(size/4)) + ", %ecx");
    EmitInstruction("mov", "%esp, %edi");
    EmitInstruction("rep", "stosl");
  }
  else {
  }

  // Emit local data(for arrays)
  EmitLocalData(scope);

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
  EmitInstruction("addl", Imm((int)size) + ", %esp", "remove locals");
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
        EmitInstruction("movl", Imm(dim_num) + "," + to_string(sym->GetOffset()) + "(" + sym->GetBaseRegister() + ")",
            "local array '" + sym->GetName() + "': " + to_string(dim_num) + " dimensions");

        for(int j = 0; j < dim_num; j++) {
          EmitInstruction("movl",
              Imm(local_arr->GetNElem()) + "," + to_string(sym->GetOffset() + 4 + j*4) + "(" + sym->GetBaseRegister() + ")",
              "  dimension " + to_string(j+1) + ": " + to_string(local_arr->GetNElem()) + " elements");

          local_arr = dynamic_cast<const CArrayType *>(local_arr->GetInnerType());
        }
      }
    }
  }
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
      Load(i->GetSrc(1), "%eax", cmt.str());
      Load(i->GetSrc(2), "%ebx");
      EmitInstruction("addl", "%ebx, %eax");
      Store(i->GetDest(), 'a');
      break;
    case opSub:
      Load(i->GetSrc(1), "%eax", cmt.str());
      Load(i->GetSrc(2), "%ebx");
      EmitInstruction("subl", "%ebx, %eax");
      Store(i->GetDest(), 'a');
      break;
    case opMul:
      Load(i->GetSrc(1), "%eax", cmt.str());
      Load(i->GetSrc(2), "%ebx");
      EmitInstruction("imull", "%ebx");
      Store(i->GetDest(), 'a');
      break;
    case opDiv:
      Load(i->GetSrc(1), "%eax", cmt.str());
      Load(i->GetSrc(2), "%ebx");
      EmitInstruction("cdq");
      EmitInstruction("idivl", "%ebx");
      Store(i->GetDest(), 'a');
      break;
    case opAnd:
      // opAnd instructions are replaced to another instruction in phase 4.
      EmitInstruction("# opAnd", "not implemented", cmt.str());
      break;
    case opOr:
      // opOr instructions are replaced to another instruction in phase 4.
      EmitInstruction("# opOr", "not implemented", cmt.str());
      break;

    // unary operators
    // dst = op src1
    case opNeg:
      Load(i->GetSrc(1), "%eax", cmt.str());
      EmitInstruction("negl", "%eax");
      Store(i->GetDest(), 'a');
      break;
    case opPos:
      EmitInstruction("# ???", "not implemented", cmt.str());
      break;
    case opNot:
      // opNot instructions are replaced to another instruction in phase 4.
      EmitInstruction("# opNot", "not implemented", cmt.str());
      break;

    // memory operations
    // dst = src1
    case opAssign:
      Load(i->GetSrc(1), "%eax", cmt.str());
      Store(i->GetDest(), 'a');
      break;

    // pointer operations
    // dst = &src1
    case opAddress:
      EmitInstruction("leal", Operand(i->GetSrc(1)) + ", %eax", cmt.str());
      Store(i->GetDest(), 'a');
      break;
    // dst = *src1
    case opDeref:
      // opDeref not generated for now
      EmitInstruction("# opDeref", "not implemented", cmt.str());
      break;
    case opCast:
      // opCast not generated for now
      EmitInstruction("# opCast", "not implemented", cmt.str());
      break;

    // unconditional branching
    // goto dst
    case opGoto:
    {
      EmitInstruction("jmp", Label(dynamic_cast<CTacLabel *>(i->GetDest())->GetLabel()), cmt.str());
      break;
    }

    // conditional branching
    // if src1 relOp src2 then goto dst
    case opEqual:
    case opNotEqual:
    case opLessThan:
    case opLessEqual:
    case opBiggerEqual:
    case opBiggerThan:
      Load(i->GetSrc(1), "%eax", cmt.str());
      Load(i->GetSrc(2), "%ebx");
      EmitInstruction("cmpl", "%ebx, %eax");
      EmitInstruction("j" + Condition(i->GetOperation()), Label(dynamic_cast<CTacLabel *>(i->GetDest())->GetLabel()));
      break;

    // function call-related operations
    case opCall:
    {
      int params = dynamic_cast<const CSymProc *>(dynamic_cast<CTacName *>(i->GetSrc(1))->GetSymbol())->GetNParams();

      EmitInstruction("call", dynamic_cast<CTacName *>(i->GetSrc(1))->GetSymbol()->GetName(), cmt.str());
      if(params > 0) {
        EmitInstruction("addl", Imm(params*4) + ", %esp");
      }
      if(i->GetDest()) {
        Store(i->GetDest(), 'a');
      }
      break;
    }
    case opReturn:
      if(i->GetSrc(1)) Load(i->GetSrc(1), "%eax", cmt.str());
      EmitInstruction("jmp", Label("exit"));
      break;
    case opParam:
      Load(i->GetSrc(1), "%eax", cmt.str());
      EmitInstruction("pushl", "%eax");
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
    int offset = dynamic_cast<const CTacName *>(op)->GetSymbol()->GetOffset(); 
    const CSymbol *sym = dynamic_cast<const CTacReference *>(op)->GetSymbol();

    // Add Instruction for temporary variable of array
    EmitInstruction("movl", to_string(offset) + "(" + sym->GetBaseRegister() + "), %edi");

    operand = "(%edi)";

    // Global case.
    if(sym->GetSymbolType() == stGlobal) operand = sym->GetName();
  }
  else if(dynamic_cast<const CTacConst *>(op)) { // const case
    operand = Imm(dynamic_cast<const CTacConst *>(op)->GetValue());
  }
  else { // Others
    const CSymbol *sym = dynamic_cast<const CTacName *>(op)->GetSymbol();
    int offset = sym->GetOffset();
    string baseReg = sym->GetBaseRegister();

    operand = to_string(offset) + "(" + baseReg + ")";

    // Global case.
    if(sym->GetSymbolType() == stGlobal) operand = sym->GetName();
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

  // Constant.
  if(dynamic_cast<CTacConst *>(t)) {
    size = 4;
    return size;
  }
  
  // non reference case.
  if(!dynamic_cast<CTacReference *>(t)) {
    const CSymbol *sym = dynamic_cast<CTacName *>(t)->GetSymbol();

    // if not array, just return its size
    if(!sym->GetDataType()->IsArray()) {
      size = sym->GetDataType()->GetSize();
    }
    else { // array returns size of base type.
      size = dynamic_cast<const CArrayType *>(sym->GetDataType())->GetBaseType()->GetSize();
    }

    return size;
  }
  else { // reference case: array, pointer
    const CSymbol *sym = dynamic_cast<CTacReference *>(t)->GetDerefSymbol();
    
    // array returns size of base type.
    if(sym->GetDataType()->IsArray()) {
      size = dynamic_cast<const CArrayType *>(sym->GetDataType())->GetBaseType()->GetSize();
    } // pointer returns size of base type of base type(array)
    else if(sym->GetDataType()->IsPointer()) {
      size = dynamic_cast<const CArrayType *>(dynamic_cast<const CPointerType *>(sym->GetDataType())->GetBaseType())->GetBaseType()->GetSize();
    }

    return size;
  }
}

size_t CBackendx86::ComputeStackOffsets(CSymtab *symtab,
                                        int param_ofs,int local_ofs)
{
  assert(symtab != NULL);
  vector<CSymbol*> slist = symtab->GetSymbols();
  size_t size = 0;

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
      size += (size_t)sym_local->GetDataType()->GetSize();
      
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
