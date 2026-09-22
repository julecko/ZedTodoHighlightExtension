(tag
  (name) @name
  (
      "(" @context
      (user) @context
      ")" @context
  )?
  .
  (text)? @context
  (#match? @name "^(TODO|TODOS|TO-DO|NOTE|INFO|XXX|FIXME|FIX|BUG|ERROR|HACK|WARNING|WARN|OPTIMIZE|REVIEW|DEPRECATED|IMPORTANT)$")
  ) @item
