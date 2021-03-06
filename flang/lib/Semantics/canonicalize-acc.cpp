//===-- lib/Semantics/canonicalize-acc.cpp --------------------------------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include "canonicalize-acc.h"
#include "flang/Parser/parse-tree-visitor.h"
#include "flang/Semantics/tools.h"

// After Loop Canonicalization, rewrite OpenACC parse tree to make OpenACC
// Constructs more structured which provide explicit scopes for later
// structural checks and semantic analysis.
//   1. move structured DoConstruct into
//      OpenACCLoopConstruct. Compilation will not proceed in case of errors
//      after this pass.
//   2. move structured DoConstruct into OpenACCCombinedConstruct. Move
//      AccEndCombinedConstruct into OpenACCCombinedConstruct if present.
//      Compilation will not proceed in case of errors after this pass.
namespace Fortran::semantics {

using namespace parser::literals;

class CanonicalizationOfAcc {
public:
  template <typename T> bool Pre(T &) { return true; }
  template <typename T> void Post(T &) {}
  CanonicalizationOfAcc(parser::Messages &messages) : messages_{messages} {}

  void Post(parser::Block &block) {
    for (auto it{block.begin()}; it != block.end(); ++it) {
      if (auto *accLoop{parser::Unwrap<parser::OpenACCLoopConstruct>(*it)}) {
        RewriteOpenACCLoopConstruct(*accLoop, block, it);
      } else if (auto *accCombined{
                     parser::Unwrap<parser::OpenACCCombinedConstruct>(*it)}) {
        RewriteOpenACCCombinedConstruct(*accCombined, block, it);
      } else if (auto *endDir{
                     parser::Unwrap<parser::AccEndCombinedDirective>(*it)}) {
        // Unmatched AccEndCombinedDirective
        messages_.Say(endDir->v.source,
            "The %s directive must follow the DO loop associated with the "
            "loop construct"_err_en_US,
            parser::ToUpperCaseLetters(endDir->v.source.ToString()));
      }
    } // Block list
  }

private:
  void RewriteOpenACCLoopConstruct(parser::OpenACCLoopConstruct &x,
      parser::Block &block, parser::Block::iterator it) {
    // Check the sequence of DoConstruct in the same iteration
    //
    // Original:
    //   ExecutableConstruct -> OpenACCConstruct -> OpenACCLoopConstruct
    //     ACCBeginLoopDirective
    //   ExecutableConstruct -> DoConstruct
    //
    // After rewriting:
    //   ExecutableConstruct -> OpenACCConstruct -> OpenACCLoopConstruct
    //     AccBeginLoopDirective
    //     DoConstruct
    parser::Block::iterator nextIt;
    auto &beginDir{std::get<parser::AccBeginLoopDirective>(x.t)};
    auto &dir{std::get<parser::AccLoopDirective>(beginDir.t)};

    nextIt = it;
    if (++nextIt != block.end()) {
      if (auto *doCons{parser::Unwrap<parser::DoConstruct>(*nextIt)}) {
        if (doCons->GetLoopControl()) {
          // move DoConstruct
          std::get<std::optional<parser::DoConstruct>>(x.t) =
              std::move(*doCons);
          nextIt = block.erase(nextIt);
        } else {
          messages_.Say(dir.source,
              "DO loop after the %s directive must have loop control"_err_en_US,
              parser::ToUpperCaseLetters(dir.source.ToString()));
        }
        return; // found do-loop
      }
    }
    messages_.Say(dir.source,
        "A DO loop must follow the %s directive"_err_en_US,
        parser::ToUpperCaseLetters(dir.source.ToString()));
  }

  void RewriteOpenACCCombinedConstruct(parser::OpenACCCombinedConstruct &x,
      parser::Block &block, parser::Block::iterator it) {
    // Check the sequence of DoConstruct in the same iteration
    //
    // Original:
    //   ExecutableConstruct -> OpenACCConstruct -> OpenACCCombinedConstruct
    //     ACCBeginCombinedDirective
    //   ExecutableConstruct -> DoConstruct
    //   ExecutableConstruct -> AccEndCombinedDirective (if available)
    //
    // After rewriting:
    //   ExecutableConstruct -> OpenACCConstruct -> OpenACCCombinedConstruct
    //     ACCBeginCombinedDirective
    //     DoConstruct
    //     AccEndCombinedDirective (if available)
    parser::Block::iterator nextIt;
    auto &beginDir{std::get<parser::AccBeginCombinedDirective>(x.t)};
    auto &dir{std::get<parser::AccCombinedDirective>(beginDir.t)};

    nextIt = it;
    if (++nextIt != block.end()) {
      if (auto *doCons{parser::Unwrap<parser::DoConstruct>(*nextIt)}) {
        if (doCons->GetLoopControl()) {
          // move DoConstruct
          std::get<std::optional<parser::DoConstruct>>(x.t) =
              std::move(*doCons);
          nextIt = block.erase(nextIt);
          // try to match AccEndCombinedDirective
          if (nextIt != block.end()) {
            if (auto *endDir{
                    parser::Unwrap<parser::AccEndCombinedDirective>(*nextIt)}) {
              std::get<std::optional<parser::AccEndCombinedDirective>>(x.t) =
                  std::move(*endDir);
              block.erase(nextIt);
            }
          }
        } else {
          messages_.Say(dir.source,
              "DO loop after the %s directive must have loop control"_err_en_US,
              parser::ToUpperCaseLetters(dir.source.ToString()));
        }
        return; // found do-loop
      }
    }
    messages_.Say(dir.source,
        "A DO loop must follow the %s directive"_err_en_US,
        parser::ToUpperCaseLetters(dir.source.ToString()));
  }

  parser::Messages &messages_;
};

bool CanonicalizeAcc(parser::Messages &messages, parser::Program &program) {
  CanonicalizationOfAcc acc{messages};
  Walk(program, acc);
  return !messages.AnyFatalError();
}
} // namespace Fortran::semantics
