module.exports = {
  root: true,
  env: {
    node: true,
    es2021: true,
  },
  extends: [
    "eslint:recommended",
    "plugin:@typescript-eslint/recommended",
    "plugin:@typescript-eslint/recommended-requiring-type-checking",
    "plugin:unicorn/recommended",
    "plugin:fp-ts/recommended",
    "plugin:fp-ts/recommended-requiring-type-checking",
    "prettier",
  ],
  parser: "@typescript-eslint/parser",
  parserOptions: {
    ecmaVersion: "latest",
    sourceType: "module",
    project: "./tsconfig.json",
  },
  plugins: ["@typescript-eslint", "simple-import-sort", "fp-ts"],
  rules: {
    "simple-import-sort/imports": "warn",
    "simple-import-sort/exports": "warn",
    "arrow-body-style": "warn",
    "unicorn/prevent-abbreviations": "off",
    "unicorn/no-array-for-each": "off",
    "unicorn/no-array-callback-reference": "off",
    "unicorn/no-useless-undefined": "off",
    "unicorn/consistent-function-scoping": [
      "warn",
      { checkArrowFunctions: false },
    ],
  },
};
