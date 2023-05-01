# $XDG_CONFIG_HOME/git

## Configuration

### 手動で設定する

以下の設定を有効にする。

```sh
git config --global include.path '~/.config/git/config'
git config --global commit.template '~/.config/git/git_commit_msg.txt'
```

### difftool/merge tool の設定

Windows 環境の場合、vimdiff と p4merge のパスを設定しておく。

※ vimdiff のパスを指定するのはデフォルトだと msysgit 側の vim が起動してしまうため。

```powershell
$VimPath = (Get-Command -Type Application -Name vim.exe | Select-Object -First 1).Source
git config --global difftool.vimdiff.path $VimPath
git config --global mergetool.vimdiff.path $VimPath
```

```sh
git config --global difftool.p4merge.path "path/to/p4merge.exe"
git config --global mergetool.p4merge.path "path/to/p4merge.exe"
```

## メモ

### ディレクトリにより Author を切り替える

`~/.gitconfig` によく使う方のユーザー情報を書く。

```ini
[user]
    name = <ユーザー名1>
    email = <メールアドレス1>
```

`~/.gitconfig-(work|public)` に特定フォルダ以下でのみ有効にしたいユーザー情報を書く。

```ini
[user]
    name = <ユーザー名2>
    email = <メールアドレス2>
```

`~/.gitconfig` に以下のような `includeIf` を追加する。

```ini
[includeIf "gitdir/i:C:/Users/user/Repos/github-enterprise/"]
    path = ~/.gitconfig-work
```

※ Windows の場合、`gitdir/i` で大文字小文字を無視した方が楽。

#### `includeIf` の条件部について

`gitdir` では、以下のように指定する。

- 子階層を含みたい場合、 `*` または `**` を使った glob を指定する
- パス末尾を `/` で終えた場合、`/**` を指定したと見なされる

-> 詳しくは [git-config のリファレンス](https://git-scm.com/docs/git-config#_conditional_includes)

### diff / merge に p4merge を使う

Windows で使う場合、`config-windows` を include した後以下を追記する。

```ini
[merge]
  guitool = p4merge
[diff]
  guitool = p4merge
```

Visual Studio 2019 の diff ツールを使う場合、 `vs2019` を指定する。
