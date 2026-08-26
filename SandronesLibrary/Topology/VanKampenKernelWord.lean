import SandronesLibrary.Topology.VanKampenResidualGauge

open Set
open scoped unitInterval

noncomputable section

namespace SandronesLibrary.Topology

variable {X : Type*} [TopologicalSpace X]

/-- For a nonempty word, the second-level block chain ends at the combined
frame of the last fine edge of the last block.

> **Entry**: topology.fundamental-group.van-kampen-kernel-word -/
theorem PathConcatAlignedSquareSubdivision.leftBoundaryLetterBlockChain_end
    {x₀ : X} {U V : Set X} (hxU : x₀ ∈ U) (hxV : x₀ ∈ V)
    (hUV : IsPathConnected (U ∩ V))
    (hU : IsPathConnected U) (hV : IsPathConnected V)
    (letters : List (BinaryVanKampenLetter U V hxU hxV))
    (Fhom : Path.Homotopy
      (binaryVanKampenLetterConcatLoop hxU hxV letters) (Path.refl x₀))
    (A : PathConcatAlignedSquareSubdivision (pathHomotopySquare Fhom) U V
      letters.reverse.length)
    (hn : 0 < letters.reverse.length) :
    let firstBlock : Fin letters.reverse.length := ⟨0, hn⟩
    let firstLengthPos := pathConcatSegmentGridLength_pos
      letters.reverse.length A.factor A.factor_pos firstBlock
    let lastBlock : Fin letters.reverse.length :=
      ⟨letters.reverse.length - 1, Nat.sub_lt hn Nat.zero_lt_one⟩
    let lastLength := pathConcatSegmentGridLength
      letters.reverse.length A.factor lastBlock
    let lastLengthPos := pathConcatSegmentGridLength_pos
      letters.reverse.length A.factor A.factor_pos lastBlock
    let start := A.leftBoundaryCombinedStartFrame
      hxU hxV hUV hU hV letters Fhom firstBlock ⟨0, firstLengthPos⟩
    edgeChainEnd start
        (A.leftBoundaryLetterBlockChain
          hxU hxV hUV hU hV letters Fhom) =
      A.leftBoundaryCombinedEndFrame
        hxU hxV hUV hU hV letters Fhom lastBlock
          (finLastOfPos lastLength lastLengthPos) := by
  dsimp only
  unfold PathConcatAlignedSquareSubdivision.leftBoundaryLetterBlockChain
  exact edgeChainEnd_ofFn_of_pos _ hn _ _ _

/-- The global start and finish frames of the nonempty left-boundary word are
equal.  The proof separates the common letter-side basepoint potential from
the cell residual gauge propagated around the other three sides of the
homotopy square.

> **Entry**: topology.fundamental-group.van-kampen-kernel-word -/
theorem PathConcatAlignedSquareSubdivision.leftBoundaryGlobalCombinedFrames_eq
    {x₀ : X} {U V : Set X} (hxU : x₀ ∈ U) (hxV : x₀ ∈ V)
    (hUV : IsPathConnected (U ∩ V))
    (hU : IsPathConnected U) (hV : IsPathConnected V)
    (letters : List (BinaryVanKampenLetter U V hxU hxV))
    (Fhom : Path.Homotopy
      (binaryVanKampenLetterConcatLoop hxU hxV letters) (Path.refl x₀))
    (A : PathConcatAlignedSquareSubdivision (pathHomotopySquare Fhom) U V
      letters.reverse.length)
    (hn : 0 < letters.reverse.length) :
    let firstBlock : Fin letters.reverse.length := ⟨0, hn⟩
    let firstLengthPos := pathConcatSegmentGridLength_pos
      letters.reverse.length A.factor A.factor_pos firstBlock
    let firstEdge : Fin (pathConcatSegmentGridLength
      letters.reverse.length A.factor firstBlock) := ⟨0, firstLengthPos⟩
    let lastBlock : Fin letters.reverse.length :=
      ⟨letters.reverse.length - 1, Nat.sub_lt hn Nat.zero_lt_one⟩
    let lastLength := pathConcatSegmentGridLength
      letters.reverse.length A.factor lastBlock
    let lastLengthPos := pathConcatSegmentGridLength_pos
      letters.reverse.length A.factor A.factor_pos lastBlock
    let lastEdge := finLastOfPos lastLength lastLengthPos
    A.leftBoundaryCombinedStartFrame
        hxU hxV hUV hU hV letters Fhom firstBlock firstEdge =
      A.leftBoundaryCombinedEndFrame
        hxU hxV hUV hU hV letters Fhom lastBlock lastEdge := by
  dsimp only
  let firstBlock : Fin letters.reverse.length := ⟨0, hn⟩
  let firstLengthPos := pathConcatSegmentGridLength_pos
    letters.reverse.length A.factor A.factor_pos firstBlock
  let firstEdge : Fin (pathConcatSegmentGridLength
      letters.reverse.length A.factor firstBlock) := ⟨0, firstLengthPos⟩
  let lastBlock : Fin letters.reverse.length :=
    ⟨letters.reverse.length - 1, Nat.sub_lt hn Nat.zero_lt_one⟩
  let lastLength := pathConcatSegmentGridLength
    letters.reverse.length A.factor lastBlock
  let lastLengthPos := pathConcatSegmentGridLength_pos
    letters.reverse.length A.factor A.factor_pos lastBlock
  let lastEdge := finLastOfPos lastLength lastLengthPos
  let first : Fin A.subdivision.steps := ⟨0, A.subdivision.steps_pos⟩
  let last : Fin A.subdivision.steps :=
    ⟨A.subdivision.steps - 1,
      Nat.sub_lt A.subdivision.steps_pos Nat.zero_lt_one⟩
  let z₀ := binaryOpenCoverIntersectionBasepoint hxU hxV
  have hfirstRow : A.segmentGridEdgeIndex firstBlock firstEdge = first := by
    exact A.segmentGridEdgeIndex_first hn
  have hlastRow : A.segmentGridEdgeIndex lastBlock lastEdge = last := by
    exact A.segmentGridEdgeIndex_last hn
  have hfirstFrame := congrArg (fun row : Fin A.subdivision.steps =>
      (A.subdivision.rightAnchoredGridRowFramesAt
        hxU hxV hUV hU hV row.val row.isLt first).bottomLeft) hfirstRow
  have hlastFrame := congrArg (fun row : Fin A.subdivision.steps =>
      (A.subdivision.rightAnchoredGridRowFramesAt
        hxU hxV hUV hU hV row.val row.isLt first).topLeft) hlastRow
  have hfirstVertex := A.leftBoundaryBlockFirstVertex_eq_basepoint
    hxU hxV hU hV letters Fhom firstBlock
  have hlastVertex := A.leftBoundaryBlockLastVertex_eq_basepoint
    hxU hxV hU hV letters Fhom lastBlock
  have hfirstCell : binaryOpenCoverIntersectionToPiece U V
      (A.subdivision.label first (A.segmentGridEdgeIndex firstBlock firstEdge)) z₀ =
      ⟨squareGridVertex (pathHomotopySquare Fhom) A.subdivision.steps
          A.subdivision.steps_pos 0
            (A.segmentGridEdgeIndex firstBlock firstEdge).castSucc,
        by simpa [first, firstBlock, firstEdge] using
          A.leftBoundaryAlignedGridEdge_mem_cellPiece
            hxU hxV letters Fhom firstBlock firstEdge 0⟩ := by
    apply binaryOpenCoverIntersectionToPiece_basepoint_eq_of_coe hxU hxV
    exact hfirstVertex
  have hlastCell : binaryOpenCoverIntersectionToPiece U V
      (A.subdivision.label first (A.segmentGridEdgeIndex lastBlock lastEdge)) z₀ =
      ⟨squareGridVertex (pathHomotopySquare Fhom) A.subdivision.steps
          A.subdivision.steps_pos 0
            (A.segmentGridEdgeIndex lastBlock lastEdge).succ,
        by simpa [first, lastBlock, lastEdge] using
          A.leftBoundaryAlignedGridEdge_mem_cellPiece
            hxU hxV letters Fhom lastBlock lastEdge 1⟩ := by
    apply binaryOpenCoverIntersectionToPiece_basepoint_eq_of_coe hxU hxV
    exact hlastVertex
  have hfirstLetter : binaryOpenCoverIntersectionToPiece U V
      (letters.reverse.get firstBlock).1 z₀ =
      ⟨squareGridVertex (pathHomotopySquare Fhom) A.subdivision.steps
          A.subdivision.steps_pos 0
            (A.segmentGridEdgeIndex firstBlock firstEdge).castSucc,
        by simpa [firstBlock, firstEdge] using
          A.leftBoundaryAlignedGridEdge_mem_letterPiece
            hxU hxV letters Fhom firstBlock firstEdge 0⟩ := by
    apply binaryOpenCoverIntersectionToPiece_basepoint_eq_of_coe hxU hxV
    exact hfirstVertex
  have hlastLetter : binaryOpenCoverIntersectionToPiece U V
      (letters.reverse.get lastBlock).1 z₀ =
      ⟨squareGridVertex (pathHomotopySquare Fhom) A.subdivision.steps
          A.subdivision.steps_pos 0
            (A.segmentGridEdgeIndex lastBlock lastEdge).succ,
        by simpa [lastBlock, lastEdge] using
          A.leftBoundaryAlignedGridEdge_mem_letterPiece
            hxU hxV letters Fhom lastBlock lastEdge 1⟩ := by
    apply binaryOpenCoverIntersectionToPiece_basepoint_eq_of_coe hxU hxV
    exact hlastVertex
  let hbottom := A.subdivision.gridCellVertexInPiece_bottom_eq_basepoint
    Fhom hxU hxV first 0
  let htop := A.subdivision.gridCellVertexInPiece_top_eq_basepoint
    Fhom hxU hxV first 0
  have hfirstGrid : binaryOpenCoverIntersectionToPiece U V
      (A.subdivision.label first (A.segmentGridEdgeIndex firstBlock firstEdge)) z₀ =
      A.subdivision.gridCellVertexInPiece first
        (A.segmentGridEdgeIndex firstBlock firstEdge) 0 0 := by
    rw [hfirstRow]
    exact A.subdivision.intersectionBasepoint_eq_gridCellVertexInPiece_of_eq_basepoint
      hxU hxV first first 0 0 hbottom
  have hlastGrid : binaryOpenCoverIntersectionToPiece U V
      (A.subdivision.label first (A.segmentGridEdgeIndex lastBlock lastEdge)) z₀ =
      A.subdivision.gridCellVertexInPiece first
        (A.segmentGridEdgeIndex lastBlock lastEdge) 0 1 := by
    rw [hlastRow]
    exact A.subdivision.intersectionBasepoint_eq_gridCellVertexInPiece_of_eq_basepoint
      hxU hxV first last 0 1 htop
  have hfirstTransition :=
    A.leftBoundaryCellToLetterTransitions_start_eq_intersectionPotentials
      hxU hxV hUV hU hV letters Fhom firstBlock firstEdge z₀
        hfirstCell hfirstLetter
  dsimp only at hfirstTransition
  rw [A.leftBoundaryCellStartPotential_eq_gridCellPotential
    hxU hxV hUV hU hV letters Fhom firstBlock firstEdge z₀
      hfirstCell hfirstGrid] at hfirstTransition
  have hlastTransition :=
    A.leftBoundaryCellToLetterTransitions_end_eq_intersectionPotentials
      hxU hxV hUV hU hV letters Fhom lastBlock lastEdge z₀
        hlastCell hlastLetter
  dsimp only at hlastTransition
  rw [A.leftBoundaryCellEndPotential_eq_gridCellPotential
    hxU hxV hUV hU hV letters Fhom lastBlock lastEdge z₀
      hlastCell hlastGrid] at hlastTransition
  have htarget :=
    binaryOpenCoverVertexPotentialFromIntersection_basepoint_eq_of_coe
      hxU hxV hUV
      (letters.reverse.get firstBlock).1 (letters.reverse.get lastBlock).1
      ⟨squareGridVertex (pathHomotopySquare Fhom) A.subdivision.steps
          A.subdivision.steps_pos 0
            (A.segmentGridEdgeIndex firstBlock firstEdge).castSucc,
        by simpa [firstBlock, firstEdge] using
          A.leftBoundaryAlignedGridEdge_mem_letterPiece
            hxU hxV letters Fhom firstBlock firstEdge 0⟩
      ⟨squareGridVertex (pathHomotopySquare Fhom) A.subdivision.steps
          A.subdivision.steps_pos 0
            (A.segmentGridEdgeIndex lastBlock lastEdge).succ,
        by simpa [lastBlock, lastEdge] using
          A.leftBoundaryAlignedGridEdge_mem_letterPiece
            hxU hxV letters Fhom lastBlock lastEdge 1⟩
      (A.leftBoundaryAlignedGridEdgeLetterStart
        hxU hxV hU hV letters Fhom firstBlock firstEdge)
      (A.leftBoundaryAlignedGridEdgeLetterEnd
        hxU hxV hU hV letters Fhom lastBlock lastEdge)
      (A.coe_leftBoundaryBlockFirstLetterStart
        hxU hxV hU hV letters Fhom firstBlock)
      (A.coe_leftBoundaryBlockLastLetterEnd
        hxU hxV hU hV letters Fhom lastBlock)
      hfirstLetter hlastLetter
  have hnormalized := A.subdivision.leftResidualGauge_bottom_eq_top
    Fhom hxU hxV hUV hU hV
  unfold PathConcatAlignedSquareSubdivision.leftBoundaryCombinedStartFrame
    PathConcatAlignedSquareSubdivision.leftBoundaryCombinedEndFrame
  dsimp only
  rw [hfirstTransition, hlastTransition]
  apply combinedFrame_eq_of_target_and_normalized
  · exact htarget
  · simp only [hfirstRow, hlastRow]
    rw [hfirstFrame, hlastFrame]
    unfold BinaryOpenCoverSquareSubdivision.gridCellBasepointPotential at hnormalized
    simpa [first, last, z₀] using hnormalized

/-- A nonempty Pushout letter word whose ambient concat loop is null-homotopic
is already the unit of the Pushout.

> **Entry**: topology.fundamental-group.van-kampen-kernel-word -/
theorem PathConcatAlignedSquareSubdivision.letterWord_eq_one_of_homotopy_of_nonempty
    {x₀ : X} {U V : Set X} (hxU : x₀ ∈ U) (hxV : x₀ ∈ V)
    (hUV : IsPathConnected (U ∩ V))
    (hU : IsPathConnected U) (hV : IsPathConnected V)
    (letters : List (BinaryVanKampenLetter U V hxU hxV))
    (Fhom : Path.Homotopy
      (binaryVanKampenLetterConcatLoop hxU hxV letters) (Path.refl x₀))
    (A : PathConcatAlignedSquareSubdivision (pathHomotopySquare Fhom) U V
      letters.reverse.length)
    (hn : 0 < letters.reverse.length) :
    binaryVanKampenLetterWord U V hxU hxV letters = 1 := by
  let firstBlock : Fin letters.reverse.length := ⟨0, hn⟩
  let firstLengthPos := pathConcatSegmentGridLength_pos
    letters.reverse.length A.factor A.factor_pos firstBlock
  let start := A.leftBoundaryCombinedStartFrame
    hxU hxV hUV hU hV letters Fhom firstBlock ⟨0, firstLengthPos⟩
  let chain := A.leftBoundaryLetterBlockChain
    hxU hxV hUV hU hV letters Fhom
  have hrebased := A.rebasedLetterWord_eq_one
    hxU hxV hUV hU hV letters Fhom hn
  dsimp only at hrebased
  have hend := A.leftBoundaryLetterBlockChain_end
    hxU hxV hUV hU hV letters Fhom hn
  dsimp only at hend
  have hframes := A.leftBoundaryGlobalCombinedFrames_eq
    hxU hxV hUV hU hV letters Fhom hn
  dsimp only at hframes
  change rebaseEdge start (edgeChainEnd start chain)
      (binaryVanKampenLetterWord U V hxU hxV letters) = 1 at hrebased
  rw [hend, ← hframes] at hrebased
  have hconjugated := congrArg (fun g =>
      start * g * start⁻¹) hrebased
  dsimp only [start, firstBlock, firstLengthPos] at hconjugated
  simpa [rebaseEdge, mul_assoc] using hconjugated

/-- Constant endpoint connectors do not change the fundamental-group class of
a loop.  This is the bridge used by the final canonical-map computation.

> **Entry**: topology.fundamental-group.van-kampen-kernel-word -/
@[simp] theorem fundamentalGroup_fromPath_correctedLoop_refl
    {Y : Type*} [TopologicalSpace Y] {y : Y} (p : Path y y) :
    FundamentalGroup.fromPath
        ⟦Path.correctedLoop (Path.refl y) p (Path.refl y)⟧ =
      FundamentalGroup.fromPath ⟦p⟧ := by
  unfold Path.correctedLoop FundamentalGroup.fromPath FundamentalGroup.fromArrow
  simp


end SandronesLibrary.Topology
