# Topology AT2-C5d handoff: pointed covering recovered subgroup

## Scope and baseline

- branch: `codex/topology-foundations`
- synchronized Main: `d780483`
- permission: `development_open`
- source: `SandronesLibrary/Topology/CoveringSubgroupRecoveryStandard.lean`
- Entry draft: `docs/entries/topology/covering/pointed-recovered-subgroup.md`
- Registry id proposal: `topology.covering.pointed-recovered-subgroup`
- shared-file suggestion only: import the module, register the Entry, and mark C5d integrated after Main build

The formal migration excludes the prototype's C5c constant-path point. It does not package a subgroup-built cover,
prove construction-recovery laws, or touch C5e--C5g.

## Frozen mathematical interface

`PointedCovering X x0` assumes a path-connected base and bundles an independently universe-polymorphic total type, its topology, a
`PathConnectedSpace` instance, projection, Mathlib `IsCoveringMap`, chosen lift point, and projection-point equality.
`PointedCovering.recoveredSubgroup C` is exactly the range of
`FundamentalGroup.mapOfEq C.projectionContinuousMap C.projectionContinuousMap_point`.

`PointedCovering.Equiv C D` bundles a total-space homeomorphism with strict projection commutation and strict point
preservation. The file provides `Equiv.refl`, `Equiv.symm`, `Equiv.trans`, and proves
`recoveredSubgroup_eq_of_equiv`.

## Concept freeze

| Concept | Textbook meaning | Lean carrier | Expansion / first property | Mathlib role or bridge | First consumer | Entry |
|---|---|---|---|---|---|---|
| pointed connected covering | covering projection between a path-connected base and path-connected total space, with chosen point over `x0` | new `PointedCovering X x0` | base class plus seven explicit fields | reuses `PathConnectedSpace` and `IsCoveringMap`; no Mathlib bundle was found | recovered subgroup | this Entry |
| induced fundamental-group map | `p_* : π₁(E,e0) → π₁(X,x0)` | Mathlib `FundamentalGroup.mapOfEq` | continuous projection plus point equality | exact semantic match | recovered subgroup | this Entry |
| recovered subgroup | image `p_*(π₁(E,e0))` | new `PointedCovering.recoveredSubgroup` | `MonoidHom.range` | same range already consumed by C4b lifting criterion | equivalence invariance | this Entry |
| pointed-cover equivalence | homeomorphism over `X` preserving chosen point | new `PointedCovering.Equiv` | homeomorph + two strict equations | reuses `Homeomorph`; no Mathlib pointed-cover equivalence found | subgroup invariance | this Entry |
| equivalence operations | identity, inverse, composition | `Equiv.refl/symm/trans` | fieldwise constructions | reuses homeomorphism operations | reverse range inclusion | this Entry |
| subgroup invariance | pointed-equivalent covers recover the same subgroup | `recoveredSubgroup_eq_of_equiv` | two range inclusions | uses real `mapOfEq` composition, not a packaged final theorem | future C5e | this Entry |

## Public signature scan

Category 1, semantic public Mathlib carriers:

- `TopologicalSpace`, `PathConnectedSpace`, `IsCoveringMap`;
- `FundamentalGroup`, `FundamentalGroup.mapOfEq`, `Subgroup`, `MonoidHom.range`;
- `Homeomorph`.

Category 2, necessary library-specific interfaces:

- `PointedCovering`, because Mathlib has no bundle recording projection, lift point, and point equality;
- `PointedCovering.Equiv`, because ordinary `Homeomorph` does not record projection or chosen-point compatibility;
- `recoveredSubgroup`, which freezes the textbook range as the sole primary definition.

Category 3, proof backend:

- path-homotopy quotient `map_cast`/`map_comp` and proof irrelevance are used to establish `mapOfEq` composition;
- monodromy is not imported or used.

Category 4: none. No local path connectedness, semilocal simple connectivity, C5c chart carrier, monodromy permutation,
classification equivalence, or universal-cover interface leaks into the signatures.

## Proof audit

- the `PointedCovering` topology and path-connected instances are projections of explicit structure fields;
- projection continuity is derived from the bundled `IsCoveringMap`;
- the recovered subgroup is definitionally the range used by C4b;
- `Equiv.symm` derives reverse projection commutation by evaluating the forward equation at the inverse point;
- `Equiv.trans` composes both strict compatibility equations;
- range inclusion maps a source loop through the total-space homeomorphism;
- a proved `mapOfEq` composition lemma and continuous-map equality identify its projection image;
- applying the inclusion to `e` and `e.symm` yields literal subgroup equality.

## Verification

Completed before commit:

```text
lake build SandronesLibrary.Topology.CoveringSubgroupRecoveryStandard
lake env lean /tmp/TopologyC5dAggregate.lean
rg -n "sorry|admit|sorryAx|native_decide|axiom" SandronesLibrary/Topology/CoveringSubgroupRecoveryStandard.lean
python3 map_entry_to_decl + probe_axioms for topology.covering.pointed-recovered-subgroup
git diff --check
```

Results: module build passed with 1808 jobs; the aggregate checked `PointedCovering`, both projected total-space
instances, `recoveredSubgroup`, `Equiv.refl/symm/trans`, and `recoveredSubgroup_eq_of_equiv`. Its printed signatures
also confirmed that equivalent pointed coverings may have total spaces in different universes. The forbidden-token
scan had no matches and `git diff --check` passed. The Entry mapper found 12 declarations, including both structures,
the recovered-subgroup definition, all equivalence operations, and the invariance theorem; each axiom probe reported
only `propext`, `Classical.choice`, and `Quot.sound`.

Main owns top-level import, Registry, ROADMAP, RADAR, generated indices, and final full-library build.

## Stable API and honest boundary

After Main integration, downstream C5e may rely on the bundled carrier, recovered range, pointed equivalence, and
invariance theorem. It must not infer that C5c's subgroup-built carrier is already path connected or packaged as a
`PointedCovering`; those are future construction-recovery obligations.

For a disconnected base, one fundamental group at `x0` does not describe the other path components; for a disconnected
total space, the selected point recovers only the subgroup of its path component. Therefore this Entry keeps both base
and total path connected and does
not model an entire disconnected covering by one subgroup. No pointed/unpointed classification bijection, conjugacy
quotient, or universal cover is claimed.
