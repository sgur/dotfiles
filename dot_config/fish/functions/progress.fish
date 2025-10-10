# state:
# - 0 非表示
# - 1 通常
# - 2 エラー
# - 3 不確定
# value: progress (%)
function progress --description "Set progress bar in Terminal"
    # 第1引数をstate、第2引数をvalueに設定
    set -l state $argv[1]
    set -l value $argv[2]

    if set -q TMUX
        # tmux内にいる場合: passthroughシーケンスでラップする
        # 開始: \ePtmux;\e
        # 本体: \e]9;4;... (Windows Terminalのシーケンス)
        # 終了: \e\\
        printf "\ePtmux;\e\e]9;4;%s;%s\a\e\\" "$state" "$value"
    else
        # tmuxを使っていない場合:直接シーケンスを送る
        printf "\e]9;4;%s;%s\a" "$state" "$value"
    end
end
