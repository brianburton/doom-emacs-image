;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
;; (setq user-full-name "John Doe"
;;       user-mail-address "john@doe.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom:
;;
;; - `doom-font' -- the primary font to use
;; - `doom-variable-pitch-font' -- a non-monospace font (where applicable)
;; - `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;; - `doom-symbol-font' -- for symbols
;; - `doom-serif-font' -- for the `fixed-pitch-serif' face
;;
;; See 'C-h v doom-font' for documentation and more examples of what they
;; accept. For example:
;;
;;(setq doom-font (font-spec :family "Fira Code" :size 12 :weight 'semi-light)
;;      doom-variable-pitch-font (font-spec :family "Fira Sans" :size 13))
;;
;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom issues!

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-gruvbox)

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")


;; Whenever you reconfigure a package, make sure to wrap your config in an
;; `with-eval-after-load' block, otherwise Doom's defaults may override your
;; settings. E.g.
;;
;;   (with-eval-after-load 'PACKAGE
;;     (setq x y))
;;
;; The exceptions to this rule:
;;
;;   - Setting file/directory variables (like `org-directory')
;;   - Setting variables which explicitly tell you to set them before their
;;     package is loaded (see 'C-h v VARIABLE' to look them up).
;;   - Setting doom variables (which start with 'doom-' or '+').
;;
;; Here are some additional functions/macros that will help you configure Doom.
;;
;; - `load!' for loading external *.el files relative to this one
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;; Alternatively, use `C-h o' to look up a symbol (functions, variables, faces,
;; etc).
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.

(add-hook 'java-mode-hook #'eglot-ensure)
(after! eglot
  (add-to-list 'eglot-server-programs '(java-mode . ("jdtls")))
  (add-hook 'java-mode-hook #'eglot-ensure))
(after! projectile
  (add-to-list 'projectile-globally-ignored-files ".project"))
(setq display-line-numbers-type 'relative)

;; Disable all icon rendering in terminal
(setq doom-modeline-icon nil
      doom-modeline-major-mode-icon nil
      doom-modeline-buffer-path-style 'truncate-upto-project

      ;; Treemacs
      treemacs-no-icons t
      treemacs-is-never-other-window nil)

;; Force ASCII fallbacks
(setq all-the-icons-disable-fonts t)

;;; https://www.orgroam.com/manual.html
(setq org-roam-directory (file-truename "~/org-roam"))
(after! org
  (org-roam-db-autosync-mode 1))

;;; My very own key map!
(map! :leader
  (:prefix ("z" . "my-custom-keymap")
    "t" #'org-roam-dailies-goto-today))

;;; BEGIN clipetty settings
;;;
;;; Send kill ring contents to system keyboard.
(defun my/clipetty-send-last-kill ()
  "Send the most recent kill ring entry to the system clipboard via OSC 52."
  (interactive)
  (if-let ((text (substring-no-properties (car kill-ring))))
      (progn
        (clipetty--emit (clipetty--osc text t))
        (message "Sent to clipboard"))
    (message "Kill ring is empty")))

;;; <SPC-Y> triggers the function to copy the kill ring.
(map! :leader
      :desc "Send kill ring to clipboard"
      "z y" #'my/clipetty-send-last-kill)

;;; Magic that prevents kill ring from being sent automatically.
(add-hook! 'doom-first-buffer-hook
  (global-clipetty-mode -1)
  (setq select-enable-clipboard nil)
  (when (bound-and-true-p xclip-mode)
    (xclip-mode -1)))

;;;
;;; END clipetty settings

;;;(setq completion-styles '(orderless basic))


;;; BEGIN search org-roam files
;;;

(defun my/consult-ripgrep-org-roam ()
  "Run consult-ripgrep in org-roam directory."
  (interactive)
  (let ((default-directory org-roam-directory))
    (consult-ripgrep)))

(map! :leader
      :desc "Ripgrep org-roam"
      "z r" #'my/consult-ripgrep-org-roam)

;;;
;;; END search org-roam files
