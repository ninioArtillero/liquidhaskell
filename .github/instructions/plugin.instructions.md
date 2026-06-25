---
applyTo:liquidhaskell-boot/**/*
---
## Architecture: How LiquidHaskell Works

LiquidHaskell is a GHC plugin (`-fplugin=LiquidHaskell`). Its pipeline, all in `liquidhaskell-boot`:

1. **`GHC/Plugin.hs`** — Entry point. Registers three hooks:
   - `parsedResultAction` — Parses LH annotations from comments.
   - `renamedResultAction` — Primes `tcg_rn_decls` (renamed AST) so it is populated for the next phase.
   - `typeCheckResultAction` — Main verification phase; runs after GHC type-checking.

2. **`GHC/Interface.hs`** — Builds `GhcSrc` (the "target source") from `ModGuts` + renamed AST.

3. **`LHNameResolution.hs`** — Two-pass name resolution:
   - Resolves Haskell-entity names (functions, types, data constructors) via `resolveLHNames`.
   - Resolves logic-entity names (reflected functions, local bindings, spec binders) via `resolveLogicNames`.
   Local specs use `LocalVars` / `LocalVarDetails` (built from Core + renamed source) to determine which symbols are in scope.

4. **`Bare/`** — Translates parsed "bare" specs into typed refinement types:
   - `Bare/Resolve.hs` — Builds `LocalVars` (`makeLocalVars`) and the name-resolution `Env`.
   - `Bare/Types.hs` — Shared data types (`Env`, `LocalVars`, `LocalVarDetails`, etc.).
   - Other `Bare/*.hs` modules handle measures, type classes, data types, axioms, etc.

5. **`Constraint/`** — Generates Horn-clause constraints from refined Core bindings and sends them to `liquid-fixpoint`.

6. **`Liquid/GHC/API.hs`** — A single re-export module that is the **only** interface between LH and the GHC API. All GHC imports in `liquidhaskell-boot/src/` go through `Liquid.GHC.API as Ghc` (or `as GHC`). GHC-API-facing code lives exclusively in `src-ghc/`.

## Key Conventions

### GHC API Isolation
All GHC API usage is funnelled through `Liquid.GHC.API`. Modules in `src/` and `liquidhaskell-boot/src` import `Liquid.GHC.API as Ghc`. New GHC types or functions needed by `src/` must be added to the explicit export list in `API.hs` or to `Liquid.GHC.API.Extra`.

GHC-version-specific differences go in `src-ghc-9.10/Liquid/GHC/API/Compat.hs`.

### Name Types
LiquidHaskell uses its own name type `LHName` (in `Types/Names.hs`) that wraps GHC `Name`s. Specs go through several resolution stages: `LHNUnresolved` → `LHNResolved`. When adding new resolution logic, use the existing `makeLocalLHName`, `makeGHCLHName`, etc. constructors; never construct `LHName` directly.

### Haddock Comments
All public functions and data types in `liquidhaskell-boot` must have Haddock comments. Internal notes and cross-references use the `[NOTE:Tag]` convention (e.g. `[NOTE:REFLECT-IMPORTS]`).
