echo "                                                                           "
# 1. THE LOOKS (Fastfetch)
if (Get-Command fastfetch -ErrorAction SilentlyContinue) {
    fastfetch -c "$env:USERPROFILE\.config\fastfetch\config.jsonc"
}
# 2. THE Starship path
$Env:STARSHIP_CONFIG = "C:\Users\Dhruv\.config\starship\starship.toml"

# 3. THE PROMPT (Starship)
Invoke-Expression (&starship init powershell)

# 4. THE BETTER CD (Eza)
function eza { & eza.exe -l --icons --git $args } 

# 5. THE PS line customized (Hyprland Theme)
Set-PSReadLineOption -Colors @{
    Command            = "#00d1ff" # Blue
    Parameter          = "#bb9af7" # Purple
    Operator           = "#52adff" # Cyan
    Variable           = "#f5f5f5" # Whiteish
    String             = "#00edff" # Arch Blue
    InlinePrediction   = "#565f89" # Dim Grey

}

# 5. THE PS line Tab menu
Set-PSReadLineKeyHandler -Key Tab -Function MenuComplete
echo "                                                                           "
# 1. THE LOOKS (Fastfetch)
if (Get-Command fastfetch -ErrorAction SilentlyContinue) {
    fastfetch -c "$env:USERPROFILE\.config\fastfetch/config.jsonc"
}

# 2. THE PROMPT (Starship)
Invoke-Expression (&starship init powershell)

# 3. THE BETTER CD (Eza)
function eza { & eza.exe -l --icons --git $args } 

# 4. THE PS line customized (Nix OS Theme)
Set-PSReadLineOption -Colors @{
    Command            = "#7aa2f7" # Blue
    Parameter          = "#bb9af7" # Purple
    Operator           = "#89ddff" # Cyan
    Variable           = "#c0caf5" # Whiteish
    String             = "#7FB7FF" # Nix Blue
    InlinePrediction   = "#565f89" # Dim Grey

}

# 5. THE PS line Tab menu
Set-PSReadLineKeyHandler -Key Tab -Function MenuComplete

