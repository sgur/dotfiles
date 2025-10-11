function chezmoi
    if test (count $argv) -ge 2; and test "$argv[1]" = git; and test "$argv[2]" = push
        chezmoi git remote get-url origin | cut -d/ -f4 | read -l repo_user

        echo "🔐 Switching GitHub account for chezmoi..."
        # 1. GitHubアカウントを切り替える
        gh auth switch --hostname github.com --user $repo_user

        # 2. 元の chezmoi git push コマンドを実行する
        if command chezmoi $argv
            echo "✅ push successful. Switching back."
        else
            echo "⚠️ push failed. Switching back anyway."
        end

        # 3. push の成否にかかわらず、GitHubアカウントを元に戻す
        gh auth switch --hostname github.com

    else
        # 'git push' 以外のコマンドの場合は、そのまま実行する
        command chezmoi $argv
    end
end
