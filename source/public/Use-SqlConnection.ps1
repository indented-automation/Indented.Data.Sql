function Use-SqlConnection {
    [CmdletBinding(DefaultParameterSetName = 'FromConnectionString')]
    param(
        [System.Data.SqlClient.SqlConnection]$Connection
    )

    $Script:UseConnection = $Connection
}