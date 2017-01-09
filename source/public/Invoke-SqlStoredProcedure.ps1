function Invoke-SqlStoredProcedure {
    # .SYNOPSIS
    #   Invoke an SQL stored procedure.
    # .DESCRIPTION
    #   Invoke the specified stored procedure. If return values are specified a 
    # .INPUTS
    #   Name
    # .OUTPUTS
    #   System.Object
    # .NOTES
    #   Author: Chris Dent
    #
    #   Change log:
    #     06/01/2017 - Chris Dent - Created.

    [CmdletBinding()]
    [OutputType([System.Object])]
    param(
        [Parameter(Mandatory = $true)]
        [String]$Name,

        [System.Data.SqlClient.SqlConnection]$Connection = $Script:UseConnection,

        [Hashtable]$ReturnValue,

        [Switch]$Close
    )

    try {
        if ($Connection.State -eq 'Closed') {
            $Connection.Open()
        }

        $command = New-Object System.Data.SqlClient.SqlCommand($Name, $Connection)
        $command.CommandType = 'StoredProcedure'

        foreach ($valueName in $ReturnValue.Keys) {
            $null = $command.Parameters.Add($valueName, $ReturnValue[$valueName])
            $command.Parameters[$valueName].Direction = 'ReturnValue'
        }

        Write-Verbose ('Executing {0}' -f $Name)

        $rowsAffected = $command.ExecuteNonQuery()

        Write-Verbose ('{0} rows affected.' -f $rowsAffected)

        if ($ReturnValue.Count -eq 1) {
            $command.Parameters[[String]$ReturnValue.Keys].Value
        } elseif ($ReturnValue.Count -gt 1) {
            $psObject = New-Object PSObject
            foreach ($valueName in $ReturnValue.Keys) {
                $psObject | Add-Member $valueName $command.Parameters[$valueName].Value
            }
            $psObject
        }
    } catch {
        $pscmdlet.ThrowTerminatingError($_)
    } finally {
        if ($Close -and $Connection.State -eq 'Opened') {
            $Connection.Close()
        }
    }
}