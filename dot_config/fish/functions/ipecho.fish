# ipecho.net/plain に curl してグローバルIPアドレスを表示する
function ipecho
    curl --silent ipecho.net/plain; and echo
end
