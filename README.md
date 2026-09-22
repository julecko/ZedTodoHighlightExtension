# TodoHighlighZed

A [Zed](https://zed.dev) extension that highlights code-tag comments —
`TODO`, `FIXME`, `NOTE`, `HACK`, `BUG`, and friends — using your theme's
existing colors. No language server, no background process: it's a
Tree-sitter grammar for comment tags, injected into the comment nodes of
whatever language you're editing.

## Keyword groups

| Group | Keywords | Theme scope |
| --- | --- | --- |
| To-do | `TODO`, `TODOS`, `TO-DO` | `constant.comment.todo` |
| Info | `NOTE`, `INFO`, `XXX` | `string.comment.info` |
| Error | `FIXME`, `FIX`, `BUG`, `ERROR` | `property.comment.error` |
| Warn | `HACK`, `WARNING`, `WARN`, `OPTIMIZE`, `REVIEW`, `DEPRECATED`, `IMPORTANT` | `keyword.comment.warn` |

A tag followed by `(someone)` (e.g. `TODO(julkoklein): ...`) also highlights
the parenthesized name and the rest of the line, using the `.user` and
`.text` variants of the scope above. These fall back to the base scope
(`constant`, `string`, `property`, `keyword`) in any theme, so it looks
reasonable out of the box, and can be customized (see below).

Edit `languages/comment/highlights.scm` to add, remove, or regroup keywords.

## Installing locally

1. Open Zed's command palette and run `zed: install dev extension`.
2. Select this directory (`/home/magician/Desktop/Projects/TodoHighlighZed`).
3. Zed clones the pinned `tree-sitter-comment` grammar and compiles it —
   this can take a few seconds the first time. Reload the window
   (`zed: reload extensions` or just restart Zed) if highlighting doesn't
   appear immediately.

## Compatibility: why this might not "just work" everywhere

This extension only *defines* the `comment` tag grammar and how to color it.
For it to show up in, say, a Rust file, Rust's own grammar needs to inject
the `comment` language into its `(comment)` nodes. Many of Zed's built-in
languages already do this upstream (Rust, Python, JavaScript/TypeScript, Go,
C/C++, Bash, HTML, CSS, JSON, YAML, TOML, Lua, Ruby, and more) — for those,
installing this extension is enough.

If a language you use doesn't highlight tags yet, you can add the injection
yourself:

1. Find that language extension's installed directory:
   - Linux: `~/.local/share/zed/extensions/installed/<language>/`
   - macOS: `~/Library/Application Support/Zed/extensions/installed/<language>/`
   - Windows: `%APPDATA%\Zed\extensions\installed\<language>\`
2. Open (or create) `languages/<language>/injections.scm` there.
3. Add, matching whichever capture name (`@content` or `@injection.content`)
   the file already uses — never mix both in one file:

   ```scheme
   ((comment) @injection.content
     (#set! injection.language "comment"))
   ```

   Replace `(comment)` with that grammar's actual comment node name if it
   differs.
4. Reload Zed.

This edit lives in Zed's extensions cache, so it's undone whenever that
language extension updates — worth upstreaming as a PR if you rely on it.

## Customizing colors

Add a `theme_overrides` block to your Zed `settings.json` (command palette →
`zed: open settings`), keyed by your active theme's name:

```jsonc
{
  "theme_overrides": {
    "One Dark": {
      "syntax": {
        "constant.comment.todo": { "color": "#4078f2", "font_weight": "bold" },
        "string.comment.info": { "color": "#50a14f" },
        "property.comment.error": { "color": "#e45649", "font_weight": "bold" },
        "keyword.comment.warn": { "color": "#c18401" }
      }
    }
  }
}
```

Add `.prefix`, `.bracket`, `.user`, or `.text` to any of those keys (e.g.
`constant.comment.todo.user`) to style just the comment marker, the
parentheses, the `(name)`, or the trailing text independently.

## Note on `semantic_tokens`

If `semantic_tokens` is set to `"full"` in your settings, Zed uses only
semantic tokens and this Tree-sitter-based highlighting won't apply. Leave
it at the default `"off"`, or if it's `"combined"` and an LSP's semantic
tokens are overriding comment colors, disable that token type:

```jsonc
{
  "global_lsp_settings": {
    "semantic_token_rules": [{ "token_type": "comment" }]
  }
}
```

## Conflicts with other extensions

This extension defines a hidden `comment` language, same as the popular
[Comments Highlighter](https://zed.dev/extensions/comment) extension. Don't
install both — they'll fight over the same language id. Uninstall one
before installing the other.

## Publishing

Before submitting this to the [Zed extensions registry](https://github.com/zed-industries/extensions),
push this project to a real Git repository and update the `repository` and
`authors` fields in `extension.toml` to match.

## Credits

Built on [tree-sitter-comment](https://github.com/thedadams/tree-sitter-comment),
a fork by Donnie Adams of [stsewd/tree-sitter-comment](https://github.com/stsewd/tree-sitter-comment).
