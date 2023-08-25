(lang dune 3.8)

(name cocksizebot)

(generate_opam_files true)

(source
 (github DolphinChips/cocksizebot))

(authors "DolphinChips")

(maintainers "DolphinChips")

(license MIT)

(package
 (name cocksizebot)
 (synopsis "A Telegram bot")
 (description "A very cool Telegram bot")
 (depends ocaml dune redis-lwt lwt yojson cohttp-lwt-unix calendar uri cmdliner))

; See the complete stanza docs at https://dune.readthedocs.io/en/stable/dune-files.html#dune-project
