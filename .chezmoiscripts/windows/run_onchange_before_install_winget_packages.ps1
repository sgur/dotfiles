winget pin add "Microsoft Edge Update"
winget pin add --id Microsoft.Edge
winget pin add --id Microsoft.EdgeWebView2Runtime
winget pin add --id Microsoft.Office
winget pin add --id Microsoft.OneDrive
winget pin add --id SlackTechnologies.Slack

# From winget source
winget install --no-upgrade --source winget --id GnuPG.Gpg4win
winget install --no-upgrade --source winget --id HermannSchinagl.LinkShellExtension
winget install --no-upgrade --source winget --id Microsoft.PowerShell
winget install --no-upgrade --source winget --id Microsoft.PowerToys
winget install --no-upgrade --source winget --id Microsoft.VisualStudio.2022.Professional
winget install --no-upgrade --source winget --id Microsoft.VisualStudioCode
winget install --no-upgrade --source winget --id Mozilla.Firefox.DeveloperEdition
winget install --no-upgrade --source winget --id nathancorvussolis.corvusskk

# From msstore
winget install --no-upgrade --source msstore --name 'Microsoft PC Manager'
winget install --no-upgrade --source msstore --name 'Microsoft To Do'
winget install --no-upgrade --source msstore --name --exact Ubuntu
winget install --no-upgrade --source msstore --name DevToys
