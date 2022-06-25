#!/usr/bin/env node
// @ts-check

import { pipe } from "fp-ts/lib/function.js";

const main = async () => {
  const chunks = [];

  process.stdin.on("data", (data) => {
    chunks.push(data);
  });

  process.stdin.on("end", () => {
    // const result = pipe(Buffer.concat(chunks), parseFile({ author, bookName }));
    console.log("Hello World");
  });
};

void main();
