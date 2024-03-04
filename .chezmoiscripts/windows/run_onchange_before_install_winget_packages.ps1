winget pin add "Microsoft Edge Update"
winget pin add --id Microsoft.Edge
winget pin add --id Microsoft.EdgeWebView2Runtime
winget pin add --id Microsoft.Office
winget pin add --id Microsoft.OneDrive

# From winget source
winget install --no-upgrade --id GnuPG.Gpg4win
winget install --no-upgrade --id HermannSchinagl.LinkShellExtension
winget install --no-upgrade --id Microsoft.PowerShell
winget install --no-upgrade --id Microsoft.PowerToys
winget install --no-upgrade --id Microsoft.VisualStudio.2022.Professional
winget install --no-upgrade --id Microsoft.VisualStudioCode
winget install --no-upgrade --id Mozilla.Firefox.DeveloperEdition
winget install --no-upgrade --id nathancorvussolis.corvusskk

# From msstore
winget install --no-upgrade --name DevToys
winget install --no-upgrade --name --exact Ubuntu
winget install --no-upgrade --name 'Microsoft PC Manager'
