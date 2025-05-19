;;; llm-cody.el --- llm module for integrating with Sourcegraph Cody's Open AI service -*- lexical-binding: t; package-lint-main-file: "llm.el"; byte-compile-docstring-max-column: 200-*-
;;
;; Copyright (C) 2025 Xiaoyu Zhong
;;
;; Author: Xiaoyu Zhong <bittopaz@gmail.com>
;; Homepage: https://github.com/bittopaz/llm-cody
;;
;; This file is not part of GNU Emacs.
;;
;;; Commentary:
;; This file implements the llm functionality defined in llm.el, for Sourcegraph Cody's
;; service.

;;; Code:

(require 'llm)
(require 'llm-openai)
(require 'cl-lib)

(cl-defstruct (llm-cody (:include llm-openai-compatible)))

(cl-defmethod llm-nonfree-message-info ((_ llm-cody))
  "Return Sourcegraph Cody Enterprise Terms of Use."
  "https://sourcegraph.com/terms/cody-notice")

(cl-defmethod llm-provider-chat-url ((provider llm-cody))
  (format "%s/.api/llm/chat/completions"
          (llm-cody-url provider)))

(cl-defmethod llm-provider-headers ((provider llm-cody))
  `(("Authorization" . ,(format "token %s" (llm-cody-key provider)))
    ("X-Requested-With" . "emacs-client 0.0.1")))

(cl-defmethod llm-capabilities ((_ llm-cody))
  (list 'model-list))

(cl-defmethod llm-name ((provider llm-cody))
  (format "Sourcegraph Cody %s" (llm-cody-chat-model provider)))

(provide 'llm-cody)
;;; llm-cody.el ends here
