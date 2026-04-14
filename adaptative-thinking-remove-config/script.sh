<# : # Polyglot - fonctionne en Bash ET PowerShell

# ── PowerShell ────────────────────────────────────────────────────────────────

$VarName  = “CLAUDE_CODE_DISABLE_ADAPTIVE_THINKING”
$VarValue = “1”
[System.Environment]::SetEnvironmentVariable($VarName, $VarValue, “Process”)
[System.Environment]::SetEnvironmentVariable($VarName, $VarValue, “User”)
Write-Host “✓ [$VarName] defini (PowerShell, scope User)” -ForegroundColor Green
Write-Host “-> Redemarre Claude Code pour que le changement prenne effet.” -ForegroundColor Yellow
exit 0
#>

# ── Bash (macOS / Linux / Git Bash) ───────────────────────────────────────────

VAR_NAME=“CLAUDE_CODE_DISABLE_ADAPTIVE_THINKING”
VAR_VALUE=“1”

detect_profile() {
if echo “$SHELL” | grep -q “zsh” || [ -n “$ZSH_VERSION” ]; then
echo “$HOME/.zshrc”
elif [ -f “$HOME/.bash_profile” ]; then
echo “$HOME/.bash_profile”
else
echo “$HOME/.bashrc”
fi
}

PROFILE=$(detect_profile)

if grep -q “$VAR_NAME” “$PROFILE” 2>/dev/null; then
echo “✓ $VAR_NAME deja present dans $PROFILE”
else
printf “\n# Claude Code - disable adaptive thinking (fix regression mars 2026)\nexport %s=%s\n” “$VAR_NAME” “$VAR_VALUE” >> “$PROFILE”
echo “✓ Ajoute a $PROFILE”
fi

export CLAUDE_CODE_DISABLE_ADAPTIVE_THINKING=1
echo “✓ Variable activee pour la session courante”
echo “-> Redemarre Claude Code pour que le changement prenne effet.”