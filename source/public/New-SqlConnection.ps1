function New-SqlConnection {
    # .SYNOPSIS
    #   Create a new SQL connection.
    # .DESCRIPTION
    #   Create a new SQL connection.
    # .INPUTS
    #   System.Management.Automation.PSCredential
    #   System.String
    # .OUTPUTS
    #   System.Data.SqlClient.SqlConnection
    # .NOTES
    #   Author: Chris Dent
    #
    #   Change log:
    #     06/01/2017 - Chris Dent - Created.
    
    [CmdletBinding(DefaultParameterSetName = 'FromServer')]
    [OutputType([System.Data.SqlClient.SqlConnection])]
    param(
        # The database (initial catalog) to connect to.
        [Parameter(Mandatory = $true, Position = 1, ParameterSetName = 'FromServer')]
        [String]$Database,

        # The server to connect to. By default '(local)' is used for the connection.
        [Parameter(ParameterSetName = 'FromServer')]
        [String]$Server = '(local)',

        # If a credential is specified the username and password will be used for the connection. If not, Integrated Security will be set to SSPI.
        [PSCredential]$Credential,

        # A pre-defined connection string.
        [Parameter(Mandatory = $true, ParameterSetName = 'FromConnectionString')]
        [String]$ConnectionString
    )

    if ($pscmdlet.ParameterSetName -eq 'FromServer') {
        $params = @{
            InitialCatalog     = $Database
            Datasource         = $Server
            IntegratedSecurity = 'SSPI'
        }
        if ($psboundparameters.ContainsKey('Credential')) {
            $params.IntegratedSecurity = 'False'
        }
        $ConnectionString = New-SqlConnectionString @params
    }

    $connection = New-Object System.Data.SqlClient.SqlConnection($ConnectionString)
    if ($psboundparameters.ContainsKey('Credential')) {
        $connection.Credential = New-Object System.Data.SqlClient.SqlCredential(
            $Credential.UserName,
            $Credential.Password
        )
    }

    return $connection
}