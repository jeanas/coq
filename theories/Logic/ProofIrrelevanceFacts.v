(************************************************************************)
(*         *      The Rocq Prover / The Rocq Development Team           *)
(*  v      *         Copyright INRIA, CNRS and contributors             *)
(* <O___,, * (see version control and CREDITS file for authors & dates) *)
(*   \VV/  **************************************************************)
(*    //   *    This file is distributed under the terms of the         *)
(*         *     GNU Lesser General Public License Version 2.1          *)
(*         *     (see LICENSE file for the text of the license)         *)
(************************************************************************)

(** This defines the functor that build consequences of proof-irrelevance *)

Require Export EqdepFacts.

Module Type ProofIrrelevance.

  Axiom proof_irrelevance : forall (P:Prop) (p1 p2:P), p1 = p2.

End ProofIrrelevance.

Module ProofIrrelevanceTheory (M:ProofIrrelevance).

  (** Proof-irrelevance implies uniqueness of reflexivity proofs *)

  Module Eq_rect_eq.
    Lemma eq_rect_eq :
      forall (U:Type) (p:U) (Q:U -> Type) (x:Q p) (h:p = p),
        x = eq_rect p Q x p h.
    Proof.
      intros U p Q x h; rewrite (M.proof_irrelevance _ h (eq_refl p)).
      reflexivity.
    Qed.
  End Eq_rect_eq.

  (** Export the theory of injective dependent elimination *)

  Module EqdepTheory := EqdepTheory(Eq_rect_eq).
  Export EqdepTheory.

  Scheme eq_indd := Induction for eq Sort Prop.

  (** We derive the irrelevance of the membership property for subsets *)

  Lemma subset_eq_compat :
    forall (U:Type) (P:U->Prop) (x y:U) (p:P x) (q:P y),
      x = y -> exist P x p = exist P y q.
  Proof.
    intros U P x y p q H.
    rewrite (M.proof_irrelevance _ q (eq_rect x P p y H)).
    elim H using eq_indd.
    reflexivity.
  Qed.

  Lemma subsetT_eq_compat :
    forall (U:Type) (P:U->Prop) (x y:U) (p:P x) (q:P y),
      x = y -> existT P x p = existT P y q.
  Proof.
    intros U P x y p q H.
    rewrite (M.proof_irrelevance _ q (eq_rect x P p y H)).
    elim H using eq_indd.
    reflexivity.
  Qed.

End ProofIrrelevanceTheory.
