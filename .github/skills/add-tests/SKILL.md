1. Define a category for the test.
2. Create `tests/<category>/pos/MyTest.hs` (or `neg/`).
3. Add the module name to the matching executable's `other-modules` list in `tests/tests.cabal`
4. Positive tests (`pos/`) must verify cleanly; negative tests (`neg/`) must produce a verification error.
5. Per-file LH flags go in the source as `{-@ LIQUID "--flag" @-}`.
6. Verification errors resulting from `neg/` tests should be catch using `{-@ LIQUID "--expect-error-containing=<first-line-of-error-message-description>" @-}`, or alternatively `{-@ LIQUID "--expect-any-error" @-}`.
6. Test groups covering the `pos/` directory are named `unit-pos-1` through `unit-pos-5` (files are spread across them alphabetically).
