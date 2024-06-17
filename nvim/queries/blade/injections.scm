; Inject HTML/PHP
((text) @injection.content
    (#not-has-ancestor? @injection.content "envoy")
    (#set! injection.combined)
    (#set! injection.language php))

; Inject Envoy/Bash
; ((text) @injection.content
;     (#has-ancestor? @injection.content "envoy")
;     (#set! injection.combined)
;     (#set! injection.language bash))

; Inject php_only
((php_only) @injection.content
    (#set! injection.combined)
    (#set! injection.language php_only))

; Inject parameter
((parameter) @injection.content
    (#set! injection.language php_only))

