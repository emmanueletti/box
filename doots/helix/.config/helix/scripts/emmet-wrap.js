#!/usr/bin/env node
// Wrap the selected text in an emmet abbreviation, mirroring VSCode's
// "Emmet: Wrap with Abbreviation" command.
//
//   select content -> `|` -> emmet-wrap 'ul>li.item*'
//
// The abbreviation is ARGV[0]. The selection arrives on stdin and is passed to
// emmet as `options.text`, so `*` repetition distributes one selected line per
// generated element (same as VSCode).

import { createRequire } from "node:module";
import { dirname, join } from "node:path";

const abbr = process.argv[2];
if (!abbr || !abbr.trim()) {
  process.stderr.write("emmet-wrap: missing abbreviation argument\n");
  process.exit(1);
}

// Resolve the globally-installed `emmet` package from the running node's
// lib/node_modules, so the script works regardless of CWD.
const globalModules = join(dirname(process.execPath), "..", "lib", "node_modules");
const requireGlobal = createRequire(join(globalModules, "index.js"));

let expand;
try {
  const mod = await import(requireGlobal.resolve("emmet"));
  // emmet ships CJS; the ESM interop double-nests the default export.
  expand = mod.default.default ?? mod.default;
} catch {
  process.stderr.write("emmet-wrap: `emmet` not found. Run: npm i -g emmet\n");
  process.exit(1);
}

let input = "";
for await (const chunk of process.stdin) input += chunk;

// Split selection into lines so repeat abbreviations (`li*`) get one line each.
// A single-line selection stays a plain string.
const trimmed = input.replace(/\n$/, "");
const lines = trimmed.split("\n");
const text = lines.length > 1 ? lines : trimmed;

try {
  process.stdout.write(expand(abbr, { text, options: { "output.field": () => "" } }));
} catch (err) {
  process.stderr.write(`emmet-wrap: ${err.message}\n`);
  process.exit(1);
}
