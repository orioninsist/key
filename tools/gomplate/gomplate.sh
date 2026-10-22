#!/usr/bin/env bash

gomplate() {
  local content template output

  content=$(find content -maxdepth 1 -type f -name '*.json' -printf '%f\n' | sort | fzf --prompt='Content > ') || return
  template=$(find templates -maxdepth 1 -type f -name '*.tmpl' -printf '%f\n' | sort | fzf --prompt='Template > ') || return

  [[ -n "$content" && -n "$template" ]] || return 1

  output="output/${content%.json}.md"

  docker run --rm \
    -v "$PWD:/work:Z" \
    -w /work \
    hairyhenderson/gomplate \
    --datasource "content=file:///work/content/$content" \
    --file "templates/$template" \
    --out "$output" && printf '✓ %s\n' "$output"
}
