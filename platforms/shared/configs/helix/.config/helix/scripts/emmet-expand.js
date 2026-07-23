#!/usr/bin/env node
// Expand an emmet abbreviation into markup, mirroring the LSP completion but
// driven by the selection rather than the completion menu.
//
//   select `ul>li*3` -> `|` -> emmet-expand
//
// The selection IS the abbreviation (read from stdin) and is replaced by the
// generated markup. Contrast with emmet-wrap, where the selection is content.

import { createRequire } from "node:module";
import { dirname, join } from "node:path";

const globalModules = join(dirname(process.execPath), "..", "lib", "node_modules");
const requireGlobal = createRequire(join(globalModules, "index.js"));

let expand;
try {
  const mod = await import(requireGlobal.resolve("emmet"));
  // emmet ships CJS; the ESM interop double-nests the default export.
  expand = mod.default.default ?? mod.default;
} catch {
  process.stderr.write("emmet-expand: `emmet` not found. Run: npm i -g emmet\n");
  process.exit(1);
}

let input = "";
for await (const chunk of process.stdin) input += chunk;

const abbr = input.replace(/\n$/, "").trim();
if (!abbr) {
  process.stderr.write("emmet-expand: empty selection (nothing to expand)\n");
  process.exit(1);
}

try {
  process.stdout.write(expand(abbr, { options: { "output.field": () => "" } }));
} catch (err) {
  process.stderr.write(`emmet-expand: ${err.message}\n`);
  process.exit(1);
}
