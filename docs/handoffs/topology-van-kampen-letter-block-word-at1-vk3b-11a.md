# Topology handoff： AT1-VK3b-11a letter-block word

## Scope and gate

- branch target: `codex/topology-foundations`;
- dependency: Main shared integration `38c41f1` for VK3b-10b;
- permission: `main-38c41f1-vk3b10b-accepted-11-open.md` declares VK3b-11 `development_open`;
- formal slice: exactly one source, one Entry, and this handoff.

The module turns one aligned dyadic letter block into its finite corrected-loop word and proves that the word recovers
the original input letter.  It does not introduce dual paths, generic gauge comparison, left-boundary transport,
telescope, kernel, injectivity, or the final van Kampen equivalence.

## Files

- `SandronesLibrary/Topology/VanKampenLetterBlockWord.lean` (288 lines);
- `docs/entries/topology/fundamental-group/van-kampen-letter-block-word.md`;
- `docs/handoffs/topology-van-kampen-letter-block-word-at1-vk3b-11a.md`.

The source imports only `SandronesLibrary.Topology.PathConcatAlignedSubdivision`.

## Concept chain

| Concept | Textbook meaning | Lean carrier | First real use |
|---|---|---|---|
| block grid vertex | a fine-grid point of one fixed letter segment, viewed in that letter's cover member | subtype point returned by `binaryVanKampenLetterBlockGridVertex` | block connector and edge endpoints |
| chosen block connector | a path inside the chosen cover member from the common basepoint to a block vertex | Mathlib `Path` selected from `IsPathConnected` | `binaryVanKampenLetterBlockGridWord` |
| block grid edge | the adjacent subpath of the lifted dyadic letter segment | Mathlib `Path.subpath` | corrected-loop word |
| block word | reverse ordered product of connector-corrected fine edges in the member fundamental group | Mathlib `FundamentalGroup`, existing `Path.correctedLoopWord` | recovery theorem |

No new path, homotopy, fundamental-group, or finite-concat carrier is defined.  `Path`, `Path.subpath`,
`Path.Homotopic`, `FundamentalGroup`, `IsPathConnected`, and subtypes are semantic Mathlib carriers already explained
by prior topology Entries.  Noncomputable choice is confined to connector selection.

## Public API: 11 public / 4 private

Public:

1. `binaryVanKampenLetterBlockGridVertex`;
2. `binaryVanKampenLetterBlockGridVertex_zero`;
3. `binaryVanKampenLetterBlockGridVertex_last`;
4. `binaryVanKampenLetterBlockGridConnector`;
5. `binaryVanKampenLetterBlockGridConnector_zero`;
6. `binaryVanKampenLetterBlockGridConnector_last`;
7. `binaryVanKampenLetterBlockGridEdgeInPiece`;
8. `binaryVanKampenLetterBlockGridEdgeInPiece_eq_subpath`;
9. `binaryVanKampenLetterBlockGridWord`;
10. `binaryVanKampenLetterBlockGridWord_eq_concat`;
11. `binaryVanKampenLetterBlockGridWord_eq_letter`.

Private proof machinery:

- `binaryOpenCoverPieceConnector`;
- `binaryVanKampenLetterBlockGridSubdivision`;
- `binaryVanKampenLetterBlockGridBasedConnectors`;
- `binaryVanKampenLetterBlockGridEdges_concat_homotopic_dyadicSegment`.

The connector and its endpoint computations remain public because 12--14 contain real direct consumers.  The four
private declarations have no consumer through 15c; the narrowed surface and the complete downstream overlay compile.

## Mathematical proof boundary

The aligned 10b mesh supplies the block length and fine subpaths.  Road connectivity selects endpoint connectors,
with the first and last chosen canonically as reflexive paths.  The existing subdivision corrected-word theorem
reduces the finite corrected product to the entire lifted dyadic segment.  The 09 representative theorem then
identifies its fundamental-group class with the original letter.

Only `IsPathConnected U` and `IsPathConnected V` are needed to choose member-internal connectors.  This slice does
not require the intersection to be path connected, the sets to be open, or their union to cover the ambient space.

## Verification already performed

```text
lake build SandronesLibrary.Topology.PathConcatAlignedSubdivision
Build completed successfully (1762 jobs).

lake env lean /tmp/sandrones-library/vk3b-11-formal-candidate/
  SandronesLibrary/Topology/VanKampenLetterBlockWord.lean
exit code 0; no output
```

The same narrowed 11a source was used as the root of the compiled 11a--15c overlay.  Placeholder scan is empty.
The proof chain uses only the standard axioms `propext`, `Classical.choice`, and `Quot.sound`.

## Stable downstream boundary

11b may depend on the public vertex/connector/edge/word interface, but not on the four private helper names.  Nothing
in this batch establishes same/dual path comparison, transition potentials, boundary cocycles, telescope identities,
kernel triviality, injectivity, or a van Kampen equivalence.
