if type -q yarn; and type -q node
    if test (string sub --start=1 --length=1 (yarn --version)) -lt 3
        pushd ~/
        set -l yarn_path (yarn global bin)
        mkdir -p $yarn_path
        fish_add_path -P $yarn_path
        popd
    end
end
