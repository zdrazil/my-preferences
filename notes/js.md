js, ts repl

yarn build --watch navigator=./src/constants.ts
Watch --color node dist/

function output() {
    for (var o of arguments) { 
        console.log('>');
        console.dir(o, { colors: true, depth: null  }); 
    }
};

output(
    MIN_BIRTH_DATE,
    MEWS_ICONS_FONT_FAMILY,
    AVATAR_RATIO,
);
