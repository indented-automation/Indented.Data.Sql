function New-SqlConnectionString {
    # .SYNOPSIS
    #   Create a new SQL connection string using the SqlConnectionStringBuilder.
    # .DESCRIPTION
    # 
    # .INPUTS
    #   Dynamic
    # .OUTPUTS
    #   System.String
    # .NOTES
    #   Author: Chris Dent
    #
    #   Change log:
    #     06/01/2017 - Chris Dent - Created.

    [CmdletBinding()]
    param( )

    dynamicparam {
        $dynamicParams = New-Object System.Management.Automation.RuntimeDefinedParameterDictionary
        
        foreach ($property in [System.Data.SqlClient.SqlConnectionStringBuilder].GetProperties()) {
            if ($property.CanWrite -and $property.Name -notin 'BrowsableConnectionString', 'Item') {
                $attributes = New-Object System.Collections.ObjectModel.Collection[System.Attribute]

                $attribute = New-Object System.Management.Automation.ParameterAttribute
                $attribute.ParameterSetName = '__AllParameterSets'

                $attributes.Add($attribute)

                $dynamicParam = New-Object System.Management.Automation.RuntimeDefinedParameter(
                    $property.Name,
                    $property.PropertyType,
                    $attributes
                )
                $dynamicParams.Add($property.Name, $DynamicParam)
            }
        }

        return $dynamicParams
    }

    end {
        $builder = New-Object System.Data.SqlClient.SqlConnectionStringBuilder
        foreach ($key in $builder.Keys) {
            $parameterName = $key.Replace(' ', '')
            if ($psboundparameters.containsKey($parametername)) {
                $builder[$key] = $psboundparameters[$parameterName]
            }
        }
        return $builder.ToString()
    }
}