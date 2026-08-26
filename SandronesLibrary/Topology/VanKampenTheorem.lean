import SandronesLibrary.Topology.VanKampenKernelWord

open Set
open scoped unitInterval

noncomputable section

namespace SandronesLibrary.Topology

variable {X : Type*} [TopologicalSpace X]

/-- 字母词规范同态像也可直接写成各字母环境环路类的列表乘积。 -/
private theorem binaryVanKampenCanonicalMap_letterWord_eq_prod
    {U V : Set X} {x₀ : X} (hxU : x₀ ∈ U) (hxV : x₀ ∈ V) :
    ∀ letters : List (BinaryVanKampenLetter U V hxU hxV),
      binaryVanKampenCanonicalMap U V hxU hxV
          (binaryVanKampenLetterWord U V hxU hxV letters) =
        (letters.map (fun letter => FundamentalGroup.fromPath
          ⟦letter.ambientLoop hxU hxV⟧)).prod
  | [] => by simp [binaryVanKampenLetterWord]
  | letter :: rest => by
      rw [binaryVanKampenLetterWord, map_mul,
        binaryVanKampenCanonicalMap_of_letter hxU hxV letter,
        binaryVanKampenCanonicalMap_letterWord_eq_prod hxU hxV rest]
      rfl

/-- `Path.concat` 环路的基本群类严格等于原 Pushout 字母词的规范同态像。

> **Entry**: topology.fundamental-group.van-kampen-theorem -/
theorem binaryVanKampenCanonicalMap_letterWord_eq_concatLoop
    {U V : Set X} {x₀ : X} (hxU : x₀ ∈ U) (hxV : x₀ ∈ V)
    (letters : List (BinaryVanKampenLetter U V hxU hxV)) :
    binaryVanKampenCanonicalMap U V hxU hxV
        (binaryVanKampenLetterWord U V hxU hxV letters) =
      FundamentalGroup.fromPath
        ⟦binaryVanKampenLetterConcatLoop hxU hxV letters⟧ := by
  let reversed := letters.reverse
  let q : Fin (reversed.length + 1) → X := fun _ => x₀
  let F : (i : Fin reversed.length) → Path (q i.castSucc) (q i.succ) :=
    fun i => (reversed.get i).ambientLoop hxU hxV
  let connector : (i : Fin (reversed.length + 1)) → Path x₀ (q i) :=
    fun _ => Path.refl x₀
  have hconcat := Path.correctedLoopWord_eq_concat q F connector
  have hfold := reverseDfoldl_reverse_get_eq_map_prod
    (fun letter : BinaryVanKampenLetter U V hxU hxV =>
      FundamentalGroup.fromPath ⟦letter.ambientLoop hxU hxV⟧) letters
  rw [binaryVanKampenCanonicalMap_letterWord_eq_prod hxU hxV letters]
  unfold Path.correctedLoopWord at hconcat
  have hleft : Fin.dfoldl reversed.length (fun _ => FundamentalGroup X x₀)
      (fun i acc => FundamentalGroup.fromPath
        ⟦Path.correctedLoop (connector i.castSucc) (F i) (connector i.succ)⟧ * acc) 1 =
      Fin.dfoldl reversed.length (fun _ => FundamentalGroup X x₀)
        (fun i acc => FundamentalGroup.fromPath
          ⟦(reversed.get i).ambientLoop hxU hxV⟧ * acc) 1 := by
    apply congr_arg (fun a : Fin reversed.length → FundamentalGroup X x₀ =>
      Fin.dfoldl reversed.length (fun _ => FundamentalGroup X x₀)
        (fun i acc => a i * acc) 1)
    funext i
    dsimp [connector, F, q]
    exact fundamentalGroup_fromPath_correctedLoop_refl _
  have hright : FundamentalGroup.fromPath
      ⟦Path.correctedLoop (connector 0) (Path.concat q F)
        (connector (Fin.last reversed.length))⟧ =
      FundamentalGroup.fromPath
        ⟦binaryVanKampenLetterConcatLoop hxU hxV letters⟧ := by
    dsimp [connector, q]
    exact (fundamentalGroup_fromPath_correctedLoop_refl (Path.concat (fun _ => x₀) F)).trans
      (by rfl)
  calc
    (letters.map (fun letter => FundamentalGroup.fromPath
        ⟦letter.ambientLoop hxU hxV⟧)).prod =
        Fin.dfoldl reversed.length (fun _ => FundamentalGroup X x₀)
          (fun i acc => FundamentalGroup.fromPath
            ⟦(reversed.get i).ambientLoop hxU hxV⟧ * acc) 1 := hfold.symm
    _ = Fin.dfoldl reversed.length (fun _ => FundamentalGroup X x₀)
          (fun i acc => FundamentalGroup.fromPath
            ⟦Path.correctedLoop (connector i.castSucc) (F i) (connector i.succ)⟧ * acc) 1 :=
      hleft.symm
    _ = FundamentalGroup.fromPath
          ⟦Path.correctedLoop (connector 0) (Path.concat q F)
            (connector (Fin.last reversed.length))⟧ := hconcat
    _ = FundamentalGroup.fromPath
          ⟦binaryVanKampenLetterConcatLoop hxU hxV letters⟧ := hright

/-- 每个 kernel 元素都有精确恢复该元素的非空字母词候选，以及拼接环路到常值道路的
显式同伦。空字母词对应的元素已经是 `1`，后续 VK3 证明可单独立即结束。

> **Entry**: topology.fundamental-group.van-kampen-theorem -/
theorem exists_binaryVanKampenKernelConcatLoopHomotopy
    (U V : Set X) {x₀ : X} (hxU : x₀ ∈ U) (hxV : x₀ ∈ V)
    (a : binaryVanKampenPushout U V hxU hxV)
    (ha : binaryVanKampenCanonicalMap U V hxU hxV a = 1) :
    ∃ letters : List (BinaryVanKampenLetter U V hxU hxV),
      binaryVanKampenLetterWord U V hxU hxV letters = a ∧
        Nonempty ((binaryVanKampenLetterConcatLoop hxU hxV letters).Homotopy
          (Path.refl x₀)) := by
  rcases exists_binaryVanKampenLetterWord U V hxU hxV a with ⟨letters, hletters⟩
  refine ⟨letters, hletters, ?_⟩
  apply pathHomotopic_refl_of_fromPath_eq_one
  rw [← binaryVanKampenCanonicalMap_letterWord_eq_concatLoop hxU hxV letters,
    hletters, ha]

/-- Every element in the kernel of the binary van Kampen canonical map is the
unit.  The empty letter word is immediate; a nonempty word is handled by an
aligned square subdivision of its null-homotopy.

> **Entry**: topology.fundamental-group.van-kampen-theorem -/
theorem binaryVanKampenCanonicalMap_eq_one_imp
    {x₀ : X} (U V : Set X) (hxU : x₀ ∈ U) (hxV : x₀ ∈ V)
    (hUopen : IsOpen U) (hVopen : IsOpen V) (hcover : U ∪ V = Set.univ)
    (hU : IsPathConnected U) (hV : IsPathConnected V)
    (hUV : IsPathConnected (U ∩ V))
    (a : binaryVanKampenPushout U V hxU hxV)
    (ha : binaryVanKampenCanonicalMap U V hxU hxV a = 1) :
    a = 1 := by
  rcases exists_binaryVanKampenKernelConcatLoopHomotopy
    U V hxU hxV a ha with ⟨letters, hletters, ⟨Fhom⟩⟩
  by_cases hempty : letters = []
  · subst letters
    simpa [binaryVanKampenLetterWord] using hletters.symm
  · have hn : 0 < letters.reverse.length := by
      exact List.length_pos_iff.mpr (List.reverse_ne_nil_iff.mpr hempty)
    have hSquare : ∀ z, pathHomotopySquare Fhom z ∈ U ∨
        pathHomotopySquare Fhom z ∈ V := by
      intro z
      have hz : pathHomotopySquare Fhom z ∈ U ∪ V := by
        rw [hcover]
        exact Set.mem_univ _
      exact hz
    obtain ⟨A⟩ := exists_pathConcatAlignedSquareSubdivision
      (pathHomotopySquare Fhom) hUopen hVopen hSquare letters.reverse.length
    exact hletters.symm.trans
      (A.letterWord_eq_one_of_homotopy_of_nonempty
        hxU hxV hUV hU hV letters Fhom hn)

/-- Injectivity half of the binary Seifert--van Kampen theorem.

> **Entry**: topology.fundamental-group.van-kampen-theorem -/
theorem injective_binaryVanKampenCanonicalMap
    {x₀ : X} (U V : Set X) (hxU : x₀ ∈ U) (hxV : x₀ ∈ V)
    (hUopen : IsOpen U) (hVopen : IsOpen V) (hcover : U ∪ V = Set.univ)
    (hU : IsPathConnected U) (hV : IsPathConnected V)
    (hUV : IsPathConnected (U ∩ V)) :
    Function.Injective (binaryVanKampenCanonicalMap U V hxU hxV) := by
  rw [← MonoidHom.ker_eq_bot_iff]
  ext a
  simp only [MonoidHom.mem_ker, Subgroup.mem_bot]
  exact ⟨binaryVanKampenCanonicalMap_eq_one_imp
    U V hxU hxV hUopen hVopen hcover hU hV hUV a,
    fun ha => by simp [ha]⟩

/-- Binary Seifert--van Kampen: for a path-connected open two-set cover with
path-connected intersection, the canonical amalgamated free-product map is a
group isomorphism.

> **Entry**: topology.fundamental-group.van-kampen-theorem -/
noncomputable def binaryVanKampenCanonicalEquiv
    {x₀ : X} (U V : Set X) (hxU : x₀ ∈ U) (hxV : x₀ ∈ V)
    (hUopen : IsOpen U) (hVopen : IsOpen V) (hcover : U ∪ V = Set.univ)
    (hU : IsPathConnected U) (hV : IsPathConnected V)
    (hUV : IsPathConnected (U ∩ V)) :
    binaryVanKampenPushout U V hxU hxV ≃*
      FundamentalGroup X x₀ :=
  MulEquiv.ofBijective (binaryVanKampenCanonicalMap U V hxU hxV)
    ⟨injective_binaryVanKampenCanonicalMap
      U V hxU hxV hUopen hVopen hcover hU hV hUV,
     Path.surjective_binaryVanKampenCanonicalMap
      U V hxU hxV hUopen hVopen hcover hU hV hUV⟩

/-- The forward homomorphism of the binary van Kampen equivalence is exactly
the canonical map induced by the two inclusions into the ambient space.

> **Entry**: topology.fundamental-group.van-kampen-theorem -/
theorem binaryVanKampenCanonicalEquiv_toMonoidHom
    {x₀ : X} (U V : Set X) (hxU : x₀ ∈ U) (hxV : x₀ ∈ V)
    (hUopen : IsOpen U) (hVopen : IsOpen V) (hcover : U ∪ V = Set.univ)
    (hU : IsPathConnected U) (hV : IsPathConnected V)
    (hUV : IsPathConnected (U ∩ V)) :
    (binaryVanKampenCanonicalEquiv U V hxU hxV hUopen hVopen hcover hU hV hUV).toMonoidHom =
      binaryVanKampenCanonicalMap U V hxU hxV :=
  rfl

/-- Applying the binary van Kampen equivalence is applying its canonical map.

> **Entry**: topology.fundamental-group.van-kampen-theorem -/
@[simp] theorem binaryVanKampenCanonicalEquiv_apply
    {x₀ : X} (U V : Set X) (hxU : x₀ ∈ U) (hxV : x₀ ∈ V)
    (hUopen : IsOpen U) (hVopen : IsOpen V) (hcover : U ∪ V = Set.univ)
    (hU : IsPathConnected U) (hV : IsPathConnected V)
    (hUV : IsPathConnected (U ∩ V))
    (a : binaryVanKampenPushout U V hxU hxV) :
    binaryVanKampenCanonicalEquiv U V hxU hxV hUopen hVopen hcover hU hV hUV a =
      binaryVanKampenCanonicalMap U V hxU hxV a :=
  rfl

/-- On a generator from either member of the cover, the binary van Kampen
equivalence is the map on fundamental groups induced by that inclusion.

> **Entry**: topology.fundamental-group.van-kampen-theorem -/
@[simp] theorem binaryVanKampenCanonicalEquiv_of
    {x₀ : X} (U V : Set X) (hxU : x₀ ∈ U) (hxV : x₀ ∈ V)
    (hUopen : IsOpen U) (hVopen : IsOpen V) (hcover : U ∪ V = Set.univ)
    (hU : IsPathConnected U) (hV : IsPathConnected V)
    (hUV : IsPathConnected (U ∩ V)) (b : Bool)
    (g : FundamentalGroup (binaryOpenCoverPiece U V b)
      (binaryOpenCoverBasepoint hxU hxV b)) :
    binaryVanKampenCanonicalEquiv U V hxU hxV hUopen hVopen hcover hU hV hUV
        (Monoid.PushoutI.of b g) =
      binaryOpenCoverPieceMaps U V hxU hxV b g := by
  rw [binaryVanKampenCanonicalEquiv_apply, binaryVanKampenCanonicalMap,
    Monoid.PushoutI.lift_of]

end SandronesLibrary.Topology
