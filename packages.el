;;; packages.el --- table-manipulation layer packages file for Spacemacs.
;;
;; Copyright (c) 2012-2018 Sylvain Benner & Contributors
;;
;; Author: mickaushy <mickaushy@gmail.com>
;; URL: https://github.com/mickaushy/spacemacs-table-manipulation-layer
;;
;; This file is not part of GNU Emacs.
;;
;;; License: GPLv3

;;; Commentary:

;; See the Spacemacs documentation and FAQs for instructions on how to implement
;; a new layer:
;;
;;   SPC h SPC layers RET
;;
;;
;; Briefly, each package to be installed or configured by this layer should be
;; added to `table-manipulation-packages'. Then, for each package PACKAGE:
;;
;; - If PACKAGE is not referenced by any other Spacemacs layer, define a
;;   function `table-manipulation/init-PACKAGE' to load and initialize the package.

;; - Otherwise, PACKAGE is already referenced by another Spacemacs layer, so
;;   define the functions `table-manipulation/pre-init-PACKAGE' and/or
;;   `table-manipulation/post-init-PACKAGE' to customize the package as it is loaded.

;;; Code:

(defconst table-manipulation-packages
  '(table)
  "The list of Lisp packages required by the table-manipulation layer.

Each entry is either:

1. A symbol, which is interpreted as a package to be installed, or

2. A list of the form (PACKAGE KEYS...), where PACKAGE is the
    name of the package to be installed or loaded, and KEYS are
    any number of keyword-value-pairs.

    The following keys are accepted:

    - :excluded (t or nil): Prevent the package from being loaded
      if value is non-nil

    - :location: Specify a custom installation location.
      The following values are legal:

      - The symbol `elpa' (default) means PACKAGE will be
        installed using the Emacs package manager.

      - The symbol `local' directs Spacemacs to load the file at
        `./local/PACKAGE/PACKAGE.el'

      - A list beginning with the symbol `recipe' is a melpa
        recipe.  See: https://github.com/milkypostman/melpa#recipe-format")



(spacemacs|define-transient-state table-manipulation
  :title "Table.el Manipulation Transient State"
  :on-enter
  (progn
    (setq org-edit?
          (fboundp 'org-edit-table.el))
    (if (string-match "^\*Org Src .*\[ table \]\*$" (buffer-name))
        (message "stay in current src-buffer.")
      (when org-edit? ; else
        (org-edit-table.el)
        (buffer-face-mode-invoke "org-table" 1)
        ;; (buffer-face-mode -1) ;; force fixed-pitch
        )))
  :on-exit
  nil
  :doc
  (concat "
     [_q_] apply change & quit src-block  [_RET_] quit, stay src-block
     [_Q_] ABORT CHANGE & quit src-block
        < [_p_rev]  ───────────  Focus cell  ───────────  [_n_ext] >
  ──────────────────────────────────────────────────────────────────────────
   Resize^^               Merge^^          Justify (Key Combo)^^^^
  ───────^^────────────  ──────^^───────  ────────────────────^^^^──────────────────
     [_H_] + | - [_L_]         [_w_]          1. tidy [c]ell / [R]ow  /  [C]olumn
    - [_K_]  |            [_a_]   [_d_]                    ↓
  ---------+               [_s_]          2.   by [l]eft,  [c]enter, [r]ight
    + [_J_]                                    or [t]op,   [m]iddle, [b]ottom
  ──────────────────────────────────────────────────────────────────────────
     Split:     [_|_] /  [_-_]               [_k_]
     Undo/Redo: [_u_] / [_C-r_]        [_h_]   [_j_]   [_l_]")
  :bindings
  ("n" table-forward-cell)
  ("p" table-backward-cell)
  
  ("k" previous-line)
  ("j" next-line)
  ("h" backward-char)
  ("l" forward-char)
  
  ("|" table-split-cell-horizontally)
  ("-" table-split-cell-vertically)
  
  ("H" (table-narrow-cell 1))
  ("L" (table-widen-cell 1))
  ("K" (table-shorten-cell 1))
  ("J" (table-heighten-cell 1))
  
  ("a" (table-span-cell 'left))
  ("d" (table-span-cell 'right))
  ("w" (table-span-cell 'above))
  ("s" (table-span-cell 'below))
  
  ("cl" (table-justify-cell 'left))
  ("cc" (table-justify-cell 'center))
  ("cr" (table-justify-cell 'right))
  ("ct" (table-justify-cell 'top))
  ("cm" (table-justify-cell 'middle))
  ("cb" (table-justify-cell 'bottom))
  ("cn" (table-justify-cell 'none))
  
  ("Cl" (table-justify-column 'left))
  ("Cc" (table-justify-column 'center))
  ("Cr" (table-justify-column 'right))
  ("Ct" (table-justify-column 'top))
  ("Cm" (table-justify-column 'middle))
  ("Cb" (table-justify-column 'bottom))
  ("Cn" (table-justify-column 'none))
  
  ("Rl" (table-justify-row 'left))
  ("Rc" (table-justify-row 'center))
  ("Rr" (table-justify-row 'right))
  ("Rt" (table-justify-row 'top))
  ("Rm" (table-justify-row 'middle))
  ("Rb" (table-justify-row 'bottom))
  ("Rn" (table-justify-row 'none))
  
  ("RET" (message "quit transient-state; you may exit from src-block with ,c(save)/,k(abort).") :exit t)
  ("q" (when org-edit? (org-edit-src-exit) (message "table edited."))             :exit t)
  ("Q" (when org-edit? (org-edit-src-abort) (message "change in table aborted.")) :exit t)
  ("u" undo-tree-undo)
  ("C-r" undo-tree-redo)
  
  )

(defun table-manipulation/init-table ()
  (use-package table
    :config
    (progn
      (spacemacs/declare-prefix "xT" "Table.el")
      (spacemacs/set-leader-keys
        "xT." 'spacemacs/table-manipulation-transient-state/body
        "xTc" 'table-capture
        "xTC" 'orgtbl-to-table.el
        "xTd" 'table-release
        "xTe" 'table-generate-source
        "xTi" 'table-query-dimension
        "xTn" 'table-insert
        "xTr" 'table-recognize-table
        "xTR" 'table-recognize
        "xTu" 'table-unrecognize-table
        "xTU" 'table-unrecognize
        ))
    ))

;;; packages.el ends here
