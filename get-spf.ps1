# FILEPATH: get-spf.ps1

param (
    [string]$Domain,
    [string]$DomainList,
    [string]$OutputPath = ".\spf_records.csv" # Default output path, if not specified
)

# Function to check and retrieve the SPF record for a single domain
function Get-SPFRecord([string]$domain) {
    $record = (Resolve-DnsName -Name $domain -Type TXT -ErrorAction SilentlyContinue).strings | Select-String "v=spf"

    # Create an object to store the domain and its corresponding SPF record
    $obj = New-Object PSObject -Property @{
        Domain     = $domain
        SPF_Record = $null
    }

    if ($record) {
        $obj.SPF_Record = $record
    } else {
        $obj.SPF_Record = "No SPF record found"
    }

    # Output the object
    return $obj
}

$results = @() # Array to store the results

# Check if individual domain is specified, if so, retrieve its SPF record
if ($Domain) {
    $results += Get-SPFRecord -domain $Domain
}
# Otherwise, if a domain list file path is provided, read the domains from the file and retrieve their SPF records
elseif ($DomainList) {
    if (Test-Path -Path $DomainList) {
        $domains = Get-Content -Path $DomainList
        foreach ($domain in $domains) {
            $results += Get-SPFRecord -domain $domain
        }
    } else {
        Write-Host "The specified domain list file does not exist."
        return
    }
} else {
    Write-Host "No domain or domain list file provided."
    return
}

# Export results to a file at the specified output path
$results | Export-CSV -Path $OutputPath -NoTypeInformation -Force
Write-Host "SPF records have been exported to $OutputPath"
