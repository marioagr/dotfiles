# See: https://learn.microsoft.com/en-us/windows/terminal/tutorials/new-tab-same-directory#powershell-powershellexe-or-pwshexe
function prompt {
    $loc = $executionContext.SessionState.Path.CurrentLocation;

    $out = ""
    if ($loc.Provider.Name -eq "FileSystem") {
        $out += "$([char]27)]9;9;`"$($loc.ProviderPath)`"$([char]27)\"
    }
    $out += "PS $loc$('>' * ($nestedPromptLevel + 1)) ";
    return $out
}

# Common
function opc { opencode @args }
function lzg { lazygit @args }

