# FILEPATH: get-dkim.ps1

param (
    [string]$Domain,
    [string]$DomainList,
    [string]$OutputPath = ".\DKIM_Records.csv" # Default output path, if not specified
)

# Function to check and retrieve the SPF record for a single domain
function Get-DKIMRecord([string]$domain) {
    $record = Resolve-DnsName -Name $domain -Type TXT -ErrorAction SilentlyContinue

    # Create an object to store the domain and its corresponding record
    $obj = New-Object PSObject -Property @{
        Domain     = $domain
        DKIM_Record = $null
    }
    
    if ($record) {
        $obj.DKIM_Record = $record.Strings -join " "
    } else {
        $obj.DKIM_Record = "No DKIM record found"
    }

    # Output the object
    $obj
}

$results = @() # Array to store the results

# Check if individual domain is specified, if so, retrieve its record
if ($Domain) {
    $results += Get-DKIMRecord -domain $Domain
}
# Otherwise, if a domain list file path is provided, read the domains from the file and retrieve their records
elseif ($DomainList) {
    if (Test-Path -Path $DomainList) {
        $domains = Get-Content -Path $DomainList
        foreach ($domain in $domains) {
            $results += Get-DKIMRecord -domain $domain
        }
    } else {
        Write-Host "The specified domain list file does not exist.\n"
        return
    }
} else {
    Write-Host "No domain or domain list file provided.\n"
    return
}

# Export results to a file at the specified output path
$results | Export-CSV -Path $OutputPath -NoTypeInformation -Force
Write-Host "DKIM records have been exported to $OutputPath"
