winget pin add "Microsoft Edge Update"
winget pin add --id Microsoft.Edge
winget pin add --id Microsoft.EdgeWebView2Runtime
winget pin add --id Microsoft.Office
winget pin add --id Microsoft.OneDrive
winget pin add --id Microsoft.Teams
winget pin add --id Microsoft.Teams.Classic
winget pin add --id SlackTechnologies.Slack

# From winget source
winget install --no-upgrade --source winget --id Microsoft.PowerShell
winget install --no-upgrade --source winget --id Microsoft.WindowsTerminal.Preview
winget install --no-upgrade --source winget --id Microsoft.PowerToys
winget install --no-upgrade --source winget --id Microsoft.VisualStudio.2022.Professional
winget install --no-upgrade --source winget --id Microsoft.VisualStudioCode

winget install --no-upgrade --source winget --id 7zip.7zip
winget install --no-upgrade --source winget --id Ditto.Ditto
winget install --no-upgrade --source winget --id Git.MinGit.Busybox
winget install --no-upgrade --source winget --id GnuPG.Gpg4win
winget install --no-upgrade --source winget --id Greenshot.Greenshot
winget install --no-upgrade --source winget --id HermannSchinagl.LinkShellExtension
winget install --no-upgrade --source winget --id Mozilla.Firefox.DeveloperEdition
winget install --no-upgrade --source winget --id Obsidian.Obsidian
winget install --no-upgrade --source winget --id WerWolv.ImHex
winget install --no-upgrade --source winget --id nathancorvussolis.corvusskk
winget install --no-upgrade --source winget --id vim.vim.nightly

winget install --no-upgrade --source winget --id BurntSushi.ripgrep.MSVC
winget install --no-upgrade --source winget --id Dystroy.broot
winget install --no-upgrade --source winget --id Helix.Helix
winget install --no-upgrade --source winget --id JesseDuffield.lazygit
winget install --no-upgrade --source winget --id Rustlang.Rustup
winget install --no-upgrade --source winget --id ajeetdsouza.zoxide
winget install --no-upgrade --source winget --id ducaale.xh
winget install --no-upgrade --source winget --id eza-community.eza
winget install --no-upgrade --source winget --id junegunn.fzf
winget install --no-upgrade --source winget --id pnpm.pnpm
winget install --no-upgrade --source winget --id sharkdp.bat

# From msstore
winget install --no-upgrade --source msstore --name 'Microsoft PC Manager'
winget install --no-upgrade --source msstore --name 'Microsoft To Do'
winget install --no-upgrade --source msstore --name --exact Ubuntu
winget install --no-upgrade --source msstore --name DevToys
