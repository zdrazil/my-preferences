# vimwiki

## Migrate no extension to extension

[[some link]] -> [some link][some link.md]:

```sh
sed -i -e 's/\[\[\([^]]\+\)\]\]/[\1](\1.md)/g' **/*.md
```

[some text](some link.md) -> [some text][some link.md]:

```sh
sed -i -e 's/\[\([^]]\+\)\](\([^).]\+\))/[\1](\2.md)/g' \*_/_.md
```

https://github.com/vimwiki/vimwiki/pull/529#issuecomment-417749948
