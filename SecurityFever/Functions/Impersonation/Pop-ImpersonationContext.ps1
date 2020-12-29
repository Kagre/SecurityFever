<#
    .SYNOPSIS
        Leave the current impersonation context.

    .DESCRIPTION
        If the current session was impersonated with Push-ImpersonationContext,
        this command will leave the impersonation context.

    .INPUTS
        None.

    .OUTPUTS
        None.

    .EXAMPLE
        PS C:\> Pop-ImpersonationContext
        Leave the current impersonation context.

    .NOTES
        Author     : Claudio Spizzi
        License    : MIT License

    .LINK
        https://github.com/claudiospizzi/SecurityFever
#>
function Pop-ImpersonationContext
{
    [CmdletBinding()]
    param ()

    Initialize-ImpersonationContext

    if ($Script:ImpersonationContext.Count -gt 0)
    {
        # Get the latest impersonation context
        $popImpersonationContext = $Script:ImpersonationContext.Pop()

        # Don't assume that the working path is still accessable
        Set-Location $env:SystemDrive\
        
        # Undo the impersonation
        $popImpersonationContext.Undo()

        # Reset the PSReadline history save style
        if ($null -ne (Get-Module -Name 'PSReadline') -and $Script:ImpersonationContext.Count -eq 0)
        {
            Set-PSReadlineOption -HistorySaveStyle $Script:PSReadlineHistorySaveStyle -ErrorAction SilentlyContinue
        }
        
        popd -StackName 'ImpersonateStack'
    }
}
