; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -verify-machineinstrs -ppc-asm-full-reg-names -ppc-vsr-nums-as-vr \
; RUN:   < %s -mtriple=powerpc64-unknown-linux -mcpu=pwr8 | FileCheck %s\
; RUN:   -check-prefix=P8
; RUN: llc -verify-machineinstrs -ppc-asm-full-reg-names -ppc-vsr-nums-as-vr \
; RUN:   < %s -mtriple=powerpc64le-unknown-linux -mcpu=pwr9 | FileCheck %s \
; RUN:   -check-prefix=P9
; RUN: llc -verify-machineinstrs -ppc-asm-full-reg-names -ppc-vsr-nums-as-vr \
; RUN:   < %s -mtriple=powerpc64le-unknown-linux -mcpu=pwr8 -mattr=-vsx \
; RUN:   | FileCheck %s -check-prefix=NOVSX
; RUN: llc -mtriple=powerpc64le-unknown-linux -mcpu=pwr9 < %s -simplify-mir \
; RUN:   -stop-after=machine-cp | FileCheck %s -check-prefix=MIR

declare i32 @llvm.experimental.constrained.fptosi.i32.f128(fp128, metadata)
declare i64 @llvm.experimental.constrained.fptosi.i64.f128(fp128, metadata)
declare i64 @llvm.experimental.constrained.fptoui.i64.f128(fp128, metadata)
declare i32 @llvm.experimental.constrained.fptoui.i32.f128(fp128, metadata)

declare i32 @llvm.experimental.constrained.fptosi.i32.ppcf128(ppc_fp128, metadata)
declare i64 @llvm.experimental.constrained.fptosi.i64.ppcf128(ppc_fp128, metadata)
declare i64 @llvm.experimental.constrained.fptoui.i64.ppcf128(ppc_fp128, metadata)
declare i32 @llvm.experimental.constrained.fptoui.i32.ppcf128(ppc_fp128, metadata)

declare i128 @llvm.experimental.constrained.fptosi.i128.ppcf128(ppc_fp128, metadata)
declare i128 @llvm.experimental.constrained.fptoui.i128.ppcf128(ppc_fp128, metadata)
declare i128 @llvm.experimental.constrained.fptosi.i128.f128(fp128, metadata)
declare i128 @llvm.experimental.constrained.fptoui.i128.f128(fp128, metadata)

define i128 @q_to_i128(fp128 %m) #0 {
; P8-LABEL: q_to_i128:
; P8:       # %bb.0: # %entry
; P8-NEXT:    mflr r0
; P8-NEXT:    std r0, 16(r1)
; P8-NEXT:    stdu r1, -112(r1)
; P8-NEXT:    .cfi_def_cfa_offset 112
; P8-NEXT:    .cfi_offset lr, 16
; P8-NEXT:    bl __fixtfti
; P8-NEXT:    nop
; P8-NEXT:    addi r1, r1, 112
; P8-NEXT:    ld r0, 16(r1)
; P8-NEXT:    mtlr r0
; P8-NEXT:    blr
;
; P9-LABEL: q_to_i128:
; P9:       # %bb.0: # %entry
; P9-NEXT:    mflr r0
; P9-NEXT:    std r0, 16(r1)
; P9-NEXT:    stdu r1, -32(r1)
; P9-NEXT:    .cfi_def_cfa_offset 32
; P9-NEXT:    .cfi_offset lr, 16
; P9-NEXT:    bl __fixtfti
; P9-NEXT:    nop
; P9-NEXT:    addi r1, r1, 32
; P9-NEXT:    ld r0, 16(r1)
; P9-NEXT:    mtlr r0
; P9-NEXT:    blr
;
; NOVSX-LABEL: q_to_i128:
; NOVSX:       # %bb.0: # %entry
; NOVSX-NEXT:    mflr r0
; NOVSX-NEXT:    std r0, 16(r1)
; NOVSX-NEXT:    stdu r1, -32(r1)
; NOVSX-NEXT:    .cfi_def_cfa_offset 32
; NOVSX-NEXT:    .cfi_offset lr, 16
; NOVSX-NEXT:    bl __fixtfti
; NOVSX-NEXT:    nop
; NOVSX-NEXT:    addi r1, r1, 32
; NOVSX-NEXT:    ld r0, 16(r1)
; NOVSX-NEXT:    mtlr r0
; NOVSX-NEXT:    blr
entry:
  %conv = tail call i128 @llvm.experimental.constrained.fptosi.i128.f128(fp128 %m, metadata !"fpexcept.strict") #0
  ret i128 %conv
}

define i128 @q_to_u128(fp128 %m) #0 {
; P8-LABEL: q_to_u128:
; P8:       # %bb.0: # %entry
; P8-NEXT:    mflr r0
; P8-NEXT:    std r0, 16(r1)
; P8-NEXT:    stdu r1, -112(r1)
; P8-NEXT:    .cfi_def_cfa_offset 112
; P8-NEXT:    .cfi_offset lr, 16
; P8-NEXT:    bl __fixunstfti
; P8-NEXT:    nop
; P8-NEXT:    addi r1, r1, 112
; P8-NEXT:    ld r0, 16(r1)
; P8-NEXT:    mtlr r0
; P8-NEXT:    blr
;
; P9-LABEL: q_to_u128:
; P9:       # %bb.0: # %entry
; P9-NEXT:    mflr r0
; P9-NEXT:    std r0, 16(r1)
; P9-NEXT:    stdu r1, -32(r1)
; P9-NEXT:    .cfi_def_cfa_offset 32
; P9-NEXT:    .cfi_offset lr, 16
; P9-NEXT:    bl __fixunstfti
; P9-NEXT:    nop
; P9-NEXT:    addi r1, r1, 32
; P9-NEXT:    ld r0, 16(r1)
; P9-NEXT:    mtlr r0
; P9-NEXT:    blr
;
; NOVSX-LABEL: q_to_u128:
; NOVSX:       # %bb.0: # %entry
; NOVSX-NEXT:    mflr r0
; NOVSX-NEXT:    std r0, 16(r1)
; NOVSX-NEXT:    stdu r1, -32(r1)
; NOVSX-NEXT:    .cfi_def_cfa_offset 32
; NOVSX-NEXT:    .cfi_offset lr, 16
; NOVSX-NEXT:    bl __fixunstfti
; NOVSX-NEXT:    nop
; NOVSX-NEXT:    addi r1, r1, 32
; NOVSX-NEXT:    ld r0, 16(r1)
; NOVSX-NEXT:    mtlr r0
; NOVSX-NEXT:    blr
entry:
  %conv = tail call i128 @llvm.experimental.constrained.fptoui.i128.f128(fp128 %m, metadata !"fpexcept.strict") #0
  ret i128 %conv
}

define i128 @ppcq_to_i128(ppc_fp128 %m) #0 {
; P8-LABEL: ppcq_to_i128:
; P8:       # %bb.0: # %entry
; P8-NEXT:    mflr r0
; P8-NEXT:    std r0, 16(r1)
; P8-NEXT:    stdu r1, -112(r1)
; P8-NEXT:    .cfi_def_cfa_offset 112
; P8-NEXT:    .cfi_offset lr, 16
; P8-NEXT:    bl __fixtfti
; P8-NEXT:    nop
; P8-NEXT:    addi r1, r1, 112
; P8-NEXT:    ld r0, 16(r1)
; P8-NEXT:    mtlr r0
; P8-NEXT:    blr
;
; P9-LABEL: ppcq_to_i128:
; P9:       # %bb.0: # %entry
; P9-NEXT:    mflr r0
; P9-NEXT:    std r0, 16(r1)
; P9-NEXT:    stdu r1, -32(r1)
; P9-NEXT:    .cfi_def_cfa_offset 32
; P9-NEXT:    .cfi_offset lr, 16
; P9-NEXT:    bl __fixtfti
; P9-NEXT:    nop
; P9-NEXT:    addi r1, r1, 32
; P9-NEXT:    ld r0, 16(r1)
; P9-NEXT:    mtlr r0
; P9-NEXT:    blr
;
; NOVSX-LABEL: ppcq_to_i128:
; NOVSX:       # %bb.0: # %entry
; NOVSX-NEXT:    mflr r0
; NOVSX-NEXT:    std r0, 16(r1)
; NOVSX-NEXT:    stdu r1, -32(r1)
; NOVSX-NEXT:    .cfi_def_cfa_offset 32
; NOVSX-NEXT:    .cfi_offset lr, 16
; NOVSX-NEXT:    bl __fixtfti
; NOVSX-NEXT:    nop
; NOVSX-NEXT:    addi r1, r1, 32
; NOVSX-NEXT:    ld r0, 16(r1)
; NOVSX-NEXT:    mtlr r0
; NOVSX-NEXT:    blr
entry:
  %conv = tail call i128 @llvm.experimental.constrained.fptosi.i128.ppcf128(ppc_fp128 %m, metadata !"fpexcept.strict") #0
  ret i128 %conv
}

define i128 @ppcq_to_u128(ppc_fp128 %m) #0 {
; P8-LABEL: ppcq_to_u128:
; P8:       # %bb.0: # %entry
; P8-NEXT:    mflr r0
; P8-NEXT:    std r0, 16(r1)
; P8-NEXT:    stdu r1, -112(r1)
; P8-NEXT:    .cfi_def_cfa_offset 112
; P8-NEXT:    .cfi_offset lr, 16
; P8-NEXT:    bl __fixtfti
; P8-NEXT:    nop
; P8-NEXT:    addi r1, r1, 112
; P8-NEXT:    ld r0, 16(r1)
; P8-NEXT:    mtlr r0
; P8-NEXT:    blr
;
; P9-LABEL: ppcq_to_u128:
; P9:       # %bb.0: # %entry
; P9-NEXT:    mflr r0
; P9-NEXT:    std r0, 16(r1)
; P9-NEXT:    stdu r1, -32(r1)
; P9-NEXT:    .cfi_def_cfa_offset 32
; P9-NEXT:    .cfi_offset lr, 16
; P9-NEXT:    bl __fixtfti
; P9-NEXT:    nop
; P9-NEXT:    addi r1, r1, 32
; P9-NEXT:    ld r0, 16(r1)
; P9-NEXT:    mtlr r0
; P9-NEXT:    blr
;
; NOVSX-LABEL: ppcq_to_u128:
; NOVSX:       # %bb.0: # %entry
; NOVSX-NEXT:    mflr r0
; NOVSX-NEXT:    std r0, 16(r1)
; NOVSX-NEXT:    stdu r1, -32(r1)
; NOVSX-NEXT:    .cfi_def_cfa_offset 32
; NOVSX-NEXT:    .cfi_offset lr, 16
; NOVSX-NEXT:    bl __fixtfti
; NOVSX-NEXT:    nop
; NOVSX-NEXT:    addi r1, r1, 32
; NOVSX-NEXT:    ld r0, 16(r1)
; NOVSX-NEXT:    mtlr r0
; NOVSX-NEXT:    blr
entry:
  %conv = tail call i128 @llvm.experimental.constrained.fptosi.i128.ppcf128(ppc_fp128 %m, metadata !"fpexcept.strict") #0
  ret i128 %conv
}

define signext i32 @q_to_i32(fp128 %m) #0 {
; P8-LABEL: q_to_i32:
; P8:       # %bb.0: # %entry
; P8-NEXT:    mflr r0
; P8-NEXT:    std r0, 16(r1)
; P8-NEXT:    stdu r1, -112(r1)
; P8-NEXT:    .cfi_def_cfa_offset 112
; P8-NEXT:    .cfi_offset lr, 16
; P8-NEXT:    bl __fixkfsi
; P8-NEXT:    nop
; P8-NEXT:    extsw r3, r3
; P8-NEXT:    addi r1, r1, 112
; P8-NEXT:    ld r0, 16(r1)
; P8-NEXT:    mtlr r0
; P8-NEXT:    blr
;
; P9-LABEL: q_to_i32:
; P9:       # %bb.0: # %entry
; P9-NEXT:    xscvqpswz v2, v2
; P9-NEXT:    mfvsrwz r3, v2
; P9-NEXT:    extsw r3, r3
; P9-NEXT:    blr
;
; NOVSX-LABEL: q_to_i32:
; NOVSX:       # %bb.0: # %entry
; NOVSX-NEXT:    mflr r0
; NOVSX-NEXT:    std r0, 16(r1)
; NOVSX-NEXT:    stdu r1, -32(r1)
; NOVSX-NEXT:    .cfi_def_cfa_offset 32
; NOVSX-NEXT:    .cfi_offset lr, 16
; NOVSX-NEXT:    bl __fixkfsi
; NOVSX-NEXT:    nop
; NOVSX-NEXT:    extsw r3, r3
; NOVSX-NEXT:    addi r1, r1, 32
; NOVSX-NEXT:    ld r0, 16(r1)
; NOVSX-NEXT:    mtlr r0
; NOVSX-NEXT:    blr
;
; MIR-LABEL: name: q_to_i32
; MIR: renamable $v{{[0-9]+}} = XSCVQPSWZ
; MIR-NEXT: renamable $r{{[0-9]+}} = MFVSRWZ
entry:
  %conv = tail call i32 @llvm.experimental.constrained.fptosi.i32.f128(fp128 %m, metadata !"fpexcept.strict") #0
  ret i32 %conv
}

define i64 @q_to_i64(fp128 %m) #0 {
; P8-LABEL: q_to_i64:
; P8:       # %bb.0: # %entry
; P8-NEXT:    mflr r0
; P8-NEXT:    std r0, 16(r1)
; P8-NEXT:    stdu r1, -112(r1)
; P8-NEXT:    .cfi_def_cfa_offset 112
; P8-NEXT:    .cfi_offset lr, 16
; P8-NEXT:    bl __fixkfdi
; P8-NEXT:    nop
; P8-NEXT:    addi r1, r1, 112
; P8-NEXT:    ld r0, 16(r1)
; P8-NEXT:    mtlr r0
; P8-NEXT:    blr
;
; P9-LABEL: q_to_i64:
; P9:       # %bb.0: # %entry
; P9-NEXT:    xscvqpsdz v2, v2
; P9-NEXT:    mfvsrd r3, v2
; P9-NEXT:    blr
;
; NOVSX-LABEL: q_to_i64:
; NOVSX:       # %bb.0: # %entry
; NOVSX-NEXT:    mflr r0
; NOVSX-NEXT:    std r0, 16(r1)
; NOVSX-NEXT:    stdu r1, -32(r1)
; NOVSX-NEXT:    .cfi_def_cfa_offset 32
; NOVSX-NEXT:    .cfi_offset lr, 16
; NOVSX-NEXT:    bl __fixkfdi
; NOVSX-NEXT:    nop
; NOVSX-NEXT:    addi r1, r1, 32
; NOVSX-NEXT:    ld r0, 16(r1)
; NOVSX-NEXT:    mtlr r0
; NOVSX-NEXT:    blr
;
; MIR-LABEL: name: q_to_i64
; MIR: renamable $v{{[0-9]+}} = XSCVQPSDZ
; MIR-NEXT: renamable $x{{[0-9]+}} = MFVRD
entry:
  %conv = tail call i64 @llvm.experimental.constrained.fptosi.i64.f128(fp128 %m, metadata !"fpexcept.strict") #0
  ret i64 %conv
}

define i64 @q_to_u64(fp128 %m) #0 {
; P8-LABEL: q_to_u64:
; P8:       # %bb.0: # %entry
; P8-NEXT:    mflr r0
; P8-NEXT:    std r0, 16(r1)
; P8-NEXT:    stdu r1, -112(r1)
; P8-NEXT:    .cfi_def_cfa_offset 112
; P8-NEXT:    .cfi_offset lr, 16
; P8-NEXT:    bl __fixunskfdi
; P8-NEXT:    nop
; P8-NEXT:    addi r1, r1, 112
; P8-NEXT:    ld r0, 16(r1)
; P8-NEXT:    mtlr r0
; P8-NEXT:    blr
;
; P9-LABEL: q_to_u64:
; P9:       # %bb.0: # %entry
; P9-NEXT:    xscvqpudz v2, v2
; P9-NEXT:    mfvsrd r3, v2
; P9-NEXT:    blr
;
; NOVSX-LABEL: q_to_u64:
; NOVSX:       # %bb.0: # %entry
; NOVSX-NEXT:    mflr r0
; NOVSX-NEXT:    std r0, 16(r1)
; NOVSX-NEXT:    stdu r1, -32(r1)
; NOVSX-NEXT:    .cfi_def_cfa_offset 32
; NOVSX-NEXT:    .cfi_offset lr, 16
; NOVSX-NEXT:    bl __fixunskfdi
; NOVSX-NEXT:    nop
; NOVSX-NEXT:    addi r1, r1, 32
; NOVSX-NEXT:    ld r0, 16(r1)
; NOVSX-NEXT:    mtlr r0
; NOVSX-NEXT:    blr
;
; MIR-LABEL: name: q_to_u64
; MIR: renamable $v{{[0-9]+}} = XSCVQPUDZ
; MIR-NEXT: renamable $x{{[0-9]+}} = MFVRD
entry:
  %conv = tail call i64 @llvm.experimental.constrained.fptoui.i64.f128(fp128 %m, metadata !"fpexcept.strict") #0
  ret i64 %conv
}

define zeroext i32 @q_to_u32(fp128 %m) #0 {
; P8-LABEL: q_to_u32:
; P8:       # %bb.0: # %entry
; P8-NEXT:    mflr r0
; P8-NEXT:    std r0, 16(r1)
; P8-NEXT:    stdu r1, -112(r1)
; P8-NEXT:    .cfi_def_cfa_offset 112
; P8-NEXT:    .cfi_offset lr, 16
; P8-NEXT:    bl __fixunskfsi
; P8-NEXT:    nop
; P8-NEXT:    addi r1, r1, 112
; P8-NEXT:    ld r0, 16(r1)
; P8-NEXT:    mtlr r0
; P8-NEXT:    blr
;
; P9-LABEL: q_to_u32:
; P9:       # %bb.0: # %entry
; P9-NEXT:    xscvqpuwz v2, v2
; P9-NEXT:    mfvsrwz r3, v2
; P9-NEXT:    clrldi r3, r3, 32
; P9-NEXT:    blr
;
; NOVSX-LABEL: q_to_u32:
; NOVSX:       # %bb.0: # %entry
; NOVSX-NEXT:    mflr r0
; NOVSX-NEXT:    std r0, 16(r1)
; NOVSX-NEXT:    stdu r1, -32(r1)
; NOVSX-NEXT:    .cfi_def_cfa_offset 32
; NOVSX-NEXT:    .cfi_offset lr, 16
; NOVSX-NEXT:    bl __fixunskfsi
; NOVSX-NEXT:    nop
; NOVSX-NEXT:    addi r1, r1, 32
; NOVSX-NEXT:    ld r0, 16(r1)
; NOVSX-NEXT:    mtlr r0
; NOVSX-NEXT:    blr
;
; MIR-LABEL: name: q_to_u32
; MIR: renamable $v{{[0-9]+}} = XSCVQPUWZ
; MIR-NEXT: renamable $r{{[0-9]+}} = MFVSRWZ
entry:
  %conv = tail call i32 @llvm.experimental.constrained.fptoui.i32.f128(fp128 %m, metadata !"fpexcept.strict") #0
  ret i32 %conv
}

define signext i32 @ppcq_to_i32(ppc_fp128 %m) #0 {
; P8-LABEL: ppcq_to_i32:
; P8:       # %bb.0: # %entry
; P8-NEXT:    mflr r0
; P8-NEXT:    std r0, 16(r1)
; P8-NEXT:    stdu r1, -112(r1)
; P8-NEXT:    .cfi_def_cfa_offset 112
; P8-NEXT:    .cfi_offset lr, 16
; P8-NEXT:    bl __gcc_qtou
; P8-NEXT:    nop
; P8-NEXT:    extsw r3, r3
; P8-NEXT:    addi r1, r1, 112
; P8-NEXT:    ld r0, 16(r1)
; P8-NEXT:    mtlr r0
; P8-NEXT:    blr
;
; P9-LABEL: ppcq_to_i32:
; P9:       # %bb.0: # %entry
; P9-NEXT:    mflr r0
; P9-NEXT:    std r0, 16(r1)
; P9-NEXT:    stdu r1, -32(r1)
; P9-NEXT:    .cfi_def_cfa_offset 32
; P9-NEXT:    .cfi_offset lr, 16
; P9-NEXT:    bl __gcc_qtou
; P9-NEXT:    nop
; P9-NEXT:    extsw r3, r3
; P9-NEXT:    addi r1, r1, 32
; P9-NEXT:    ld r0, 16(r1)
; P9-NEXT:    mtlr r0
; P9-NEXT:    blr
;
; NOVSX-LABEL: ppcq_to_i32:
; NOVSX:       # %bb.0: # %entry
; NOVSX-NEXT:    mflr r0
; NOVSX-NEXT:    std r0, 16(r1)
; NOVSX-NEXT:    stdu r1, -32(r1)
; NOVSX-NEXT:    .cfi_def_cfa_offset 32
; NOVSX-NEXT:    .cfi_offset lr, 16
; NOVSX-NEXT:    bl __gcc_qtou
; NOVSX-NEXT:    nop
; NOVSX-NEXT:    extsw r3, r3
; NOVSX-NEXT:    addi r1, r1, 32
; NOVSX-NEXT:    ld r0, 16(r1)
; NOVSX-NEXT:    mtlr r0
; NOVSX-NEXT:    blr
entry:
  %conv = tail call i32 @llvm.experimental.constrained.fptosi.i32.ppcf128(ppc_fp128 %m, metadata !"fpexcept.strict") #0
  ret i32 %conv
}

define i64 @ppcq_to_i64(ppc_fp128 %m) #0 {
; P8-LABEL: ppcq_to_i64:
; P8:       # %bb.0: # %entry
; P8-NEXT:    mflr r0
; P8-NEXT:    std r0, 16(r1)
; P8-NEXT:    stdu r1, -112(r1)
; P8-NEXT:    .cfi_def_cfa_offset 112
; P8-NEXT:    .cfi_offset lr, 16
; P8-NEXT:    bl __fixtfdi
; P8-NEXT:    nop
; P8-NEXT:    addi r1, r1, 112
; P8-NEXT:    ld r0, 16(r1)
; P8-NEXT:    mtlr r0
; P8-NEXT:    blr
;
; P9-LABEL: ppcq_to_i64:
; P9:       # %bb.0: # %entry
; P9-NEXT:    mflr r0
; P9-NEXT:    std r0, 16(r1)
; P9-NEXT:    stdu r1, -32(r1)
; P9-NEXT:    .cfi_def_cfa_offset 32
; P9-NEXT:    .cfi_offset lr, 16
; P9-NEXT:    bl __fixtfdi
; P9-NEXT:    nop
; P9-NEXT:    addi r1, r1, 32
; P9-NEXT:    ld r0, 16(r1)
; P9-NEXT:    mtlr r0
; P9-NEXT:    blr
;
; NOVSX-LABEL: ppcq_to_i64:
; NOVSX:       # %bb.0: # %entry
; NOVSX-NEXT:    mflr r0
; NOVSX-NEXT:    std r0, 16(r1)
; NOVSX-NEXT:    stdu r1, -32(r1)
; NOVSX-NEXT:    .cfi_def_cfa_offset 32
; NOVSX-NEXT:    .cfi_offset lr, 16
; NOVSX-NEXT:    bl __fixtfdi
; NOVSX-NEXT:    nop
; NOVSX-NEXT:    addi r1, r1, 32
; NOVSX-NEXT:    ld r0, 16(r1)
; NOVSX-NEXT:    mtlr r0
; NOVSX-NEXT:    blr
entry:
  %conv = tail call i64 @llvm.experimental.constrained.fptosi.i64.ppcf128(ppc_fp128 %m, metadata !"fpexcept.strict") #0
  ret i64 %conv
}

define i64 @ppcq_to_u64(ppc_fp128 %m) #0 {
; P8-LABEL: ppcq_to_u64:
; P8:       # %bb.0: # %entry
; P8-NEXT:    mflr r0
; P8-NEXT:    std r0, 16(r1)
; P8-NEXT:    stdu r1, -112(r1)
; P8-NEXT:    .cfi_def_cfa_offset 112
; P8-NEXT:    .cfi_offset lr, 16
; P8-NEXT:    bl __fixunstfdi
; P8-NEXT:    nop
; P8-NEXT:    addi r1, r1, 112
; P8-NEXT:    ld r0, 16(r1)
; P8-NEXT:    mtlr r0
; P8-NEXT:    blr
;
; P9-LABEL: ppcq_to_u64:
; P9:       # %bb.0: # %entry
; P9-NEXT:    mflr r0
; P9-NEXT:    std r0, 16(r1)
; P9-NEXT:    stdu r1, -32(r1)
; P9-NEXT:    .cfi_def_cfa_offset 32
; P9-NEXT:    .cfi_offset lr, 16
; P9-NEXT:    bl __fixunstfdi
; P9-NEXT:    nop
; P9-NEXT:    addi r1, r1, 32
; P9-NEXT:    ld r0, 16(r1)
; P9-NEXT:    mtlr r0
; P9-NEXT:    blr
;
; NOVSX-LABEL: ppcq_to_u64:
; NOVSX:       # %bb.0: # %entry
; NOVSX-NEXT:    mflr r0
; NOVSX-NEXT:    std r0, 16(r1)
; NOVSX-NEXT:    stdu r1, -32(r1)
; NOVSX-NEXT:    .cfi_def_cfa_offset 32
; NOVSX-NEXT:    .cfi_offset lr, 16
; NOVSX-NEXT:    bl __fixunstfdi
; NOVSX-NEXT:    nop
; NOVSX-NEXT:    addi r1, r1, 32
; NOVSX-NEXT:    ld r0, 16(r1)
; NOVSX-NEXT:    mtlr r0
; NOVSX-NEXT:    blr
entry:
  %conv = tail call i64 @llvm.experimental.constrained.fptoui.i64.ppcf128(ppc_fp128 %m, metadata !"fpexcept.strict") #0
  ret i64 %conv
}

define zeroext i32 @ppcq_to_u32(ppc_fp128 %m) #0 {
; P8-LABEL: ppcq_to_u32:
; P8:       # %bb.0: # %entry
; P8-NEXT:    mflr r0
; P8-NEXT:    std r0, 16(r1)
; P8-NEXT:    stdu r1, -112(r1)
; P8-NEXT:    .cfi_def_cfa_offset 112
; P8-NEXT:    .cfi_offset lr, 16
; P8-NEXT:    bl __fixunstfsi
; P8-NEXT:    nop
; P8-NEXT:    addi r1, r1, 112
; P8-NEXT:    ld r0, 16(r1)
; P8-NEXT:    mtlr r0
; P8-NEXT:    blr
;
; P9-LABEL: ppcq_to_u32:
; P9:       # %bb.0: # %entry
; P9-NEXT:    mflr r0
; P9-NEXT:    std r0, 16(r1)
; P9-NEXT:    stdu r1, -32(r1)
; P9-NEXT:    .cfi_def_cfa_offset 32
; P9-NEXT:    .cfi_offset lr, 16
; P9-NEXT:    bl __fixunstfsi
; P9-NEXT:    nop
; P9-NEXT:    addi r1, r1, 32
; P9-NEXT:    ld r0, 16(r1)
; P9-NEXT:    mtlr r0
; P9-NEXT:    blr
;
; NOVSX-LABEL: ppcq_to_u32:
; NOVSX:       # %bb.0: # %entry
; NOVSX-NEXT:    mflr r0
; NOVSX-NEXT:    std r0, 16(r1)
; NOVSX-NEXT:    stdu r1, -32(r1)
; NOVSX-NEXT:    .cfi_def_cfa_offset 32
; NOVSX-NEXT:    .cfi_offset lr, 16
; NOVSX-NEXT:    bl __fixunstfsi
; NOVSX-NEXT:    nop
; NOVSX-NEXT:    addi r1, r1, 32
; NOVSX-NEXT:    ld r0, 16(r1)
; NOVSX-NEXT:    mtlr r0
; NOVSX-NEXT:    blr
entry:
  %conv = tail call i32 @llvm.experimental.constrained.fptoui.i32.ppcf128(ppc_fp128 %m, metadata !"fpexcept.strict") #0
  ret i32 %conv
}

define void @fptoint_nofpexcept(fp128 %m, i32* %addr1, i64* %addr2) {
; MIR-LABEL: name: fptoint_nofpexcept
; MIR: renamable $v{{[0-9]+}} = nofpexcept XSCVQPSWZ
; MIR: renamable $v{{[0-9]+}} = nofpexcept XSCVQPUWZ
; MIR: renamable $v{{[0-9]+}} = nofpexcept XSCVQPSDZ
; MIR: renamable $v{{[0-9]+}} = nofpexcept XSCVQPUDZ
entry:
  %conv1 = tail call i32 @llvm.experimental.constrained.fptosi.i32.f128(fp128 %m, metadata !"fpexcept.ignore") #0
  store volatile i32 %conv1, i32* %addr1, align 4
  %conv2 = tail call i32 @llvm.experimental.constrained.fptoui.i32.f128(fp128 %m, metadata !"fpexcept.ignore") #0
  store volatile i32 %conv2, i32* %addr1, align 4
  %conv3 = tail call i64 @llvm.experimental.constrained.fptosi.i64.f128(fp128 %m, metadata !"fpexcept.ignore") #0
  store volatile i64 %conv3, i64* %addr2, align 8
  %conv4 = tail call i64 @llvm.experimental.constrained.fptoui.i64.f128(fp128 %m, metadata !"fpexcept.ignore") #0
  store volatile i64 %conv4, i64* %addr2, align 8
  ret void
}

attributes #0 = { strictfp }
