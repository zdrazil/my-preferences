EXTENSIONS=(
  "abusaidm.html-snippets" \
  "ajhyndman.jslint" \
  "akfish.vscode-devdocs" \
  "alefragnani.bookmarks" \
  "alefragnani.project-manager" \
  "alexdima.copy-relative-path" \
  "auiworks.amvim" \
  "christian-kohler.npm-intellisense" \
  "christian-kohler.path-intellisense" \
  "codezombiech.gitignore" \
  "DavidAnson.vscode-markdownlint" \
  "dbaeumer.jshint" \
  "dbaeumer.vscode-eslint" \
  "deerawan.vscode-dash" \
  "donjayamanne.githistory" \
  "donjayamanne.jquerysnippets" \
  "donjayamanne.python" \
  "ecmel.vscode-html-css" \
  "EditorConfig.editorconfig" \
  "eg2.tslint" \
  "eg2.vscode-npm-script" \
  "felixfbecker.php-debug" \
  "felixfbecker.php-intellisense" \
  "formulahendry.auto-close-tag" \
  "formulahendry.auto-rename-tag" \
  "formulahendry.code-runner" \
  "hbenl.vscode-firefox-debug" \
  "HookyQR.beautify" \
  "humao.rest-client" \
  "joelday.docthis" \
  "Kasik96.swift" \
  "mkaufman.htmlhint" \
  "mrmlnc.vscode-autoprefixer" \
  "ms-vscode.cpptools" \
  "msjsdiag.debugger-for-chrome" \
  "PeterJausovec.vscode-docker" \
  "pprice.better-merge" \
  "redhat.java" \
  "rubbersheep.gi" \
  "shinnn.stylelint" \
  "shinnn.swiftlint" \
  "sidthesloth.html5-boilerplate" \
  "steve8708.align" \
  "Tyriar.lorem-ipsum" \
  "Tyriar.sort-lines" \
  "wayou.vscode-todo-highlight" \
  "weakish.complete-statement" \
  "xabikos.javascriptsnippets" \
  "xabikos.reactsnippets" \
  "Zignd.html-css-class-completion" 
)

for VARIANT in "code" \
               "code-insiders"
do
  if hash $VARIANT 2>/dev/null; then
    echo "Installing extensions for $VARIANT"
    for EXTENSION in ${EXTENSIONS[@]}
    do
      $VARIANT --install-extension $EXTENSION
    done
  fi
done


