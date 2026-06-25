# LiquidHaskell Copilot Instructions

## Build & Test

**Toolchain**: GHC 9.14.1, cabal-install 3.16.1.0, z3 ≥ 4.8.17 (all must be in `PATH`).
Initialise submodules before building: `git submodule update --init`.

```bash
# Build the main packages
cabal build liquidhaskell liquid-prelude liquid-vector

# Run the full test suite
./scripts/test/test_plugin.sh

# Run a specific test group (e.g. unit-pos-5)
./scripts/test/test_plugin.sh unit-pos-5

# List all available test groups
./scripts/test/test_plugin.sh --show-all

# Faster iteration: skip rebuilding the main packages
# when only liquidhaskell-boot changed
# It may give wrong results if changes actually affect those packages,
# so consider building them as part of testing the changes are correct.
cabal build liquidhaskell-boot

# Build a test group with extra LH flags
cabal build tests:unit-neg --ghc-options=-fplugin-opt=LiquidHaskell:--no-termination
```

## Repository Layout

```
src/                    # Assumption modules for boot packages
liquidhaskell-boot/     # The GHC plugin + core verification logic (the main package)
  src/                  # LH source, no GHC-version-specific code
  src-ghc/              # GHC-API-facing code (Liquid.GHC.API, Extra, Compat)
  src-ghc-9.10/         # GHC-version compatibility shim (Liquid.GHC.API.Compat)
  ghc-api-tests/        # Integration tests exercising the GHC API directly
liquid-fixpoint/        # Git submodule: the SMT-backed fixpoint solver
liquid-prelude/         # LH utility modules
liquid-vector/          # LH specs for the vector package
tests/                  # All regression/benchmark tests (separate cabal project)
  tests.cabal           # All test executables defined here
  harness/              # The test-driver executable source
  pos/                  # Tests expected to verify (positive)
  neg/                  # Tests expected to fail verification (negative)
  names/                # Name-resolution-specific tests
  errors/               # Tests checking specific error messages
```

## Key Conventions

Do not mark the commits as `Co-authored-by: Copilot`.

The default branch for pull requests is `develop`, not `main`/`master`.

`liquid-fixpoint/` is a git submodule pinned to a specific commit. To update it, commit the new pointer in the parent repo. Do not edit files inside `liquid-fixpoint/` for LH-specific changes.
