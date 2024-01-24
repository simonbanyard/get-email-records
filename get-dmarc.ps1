# FILEPATH: get-dmarc.ps1

param (
    [string]$Domain,
    [string]$DomainList,
    [string]$OutputPath = ".\DMARC_Records.csv" # Default output path, if not specified
)

# Function to check and retrieve the SPF record for a single domain
function Get-DMARCRecord([string]$domain) {
    $domain = "_dmarc." + $domain
    $record = Resolve-DnsName -Name $domain -Type TXT -ErrorAction SilentlyContinue

    # Create an object to store the domain and its corresponding record
    $obj = New-Object PSObject -Property @{
        Domain     = $domain
        DMARC_Record = $null
    }
    
    if ($record) {
        $obj.DMARC_Record = $record.Strings -join " "
    } else {
        $obj.DMARC_Record = "No DMARC record found"
    }

    # Output the object
    $obj
}

$results = @() # Array to store the results

# Check if individual domain is specified, if so, retrieve its SPF record
if ($Domain) {
    $results += Get-DMARCRecord -domain $Domain
}
# Otherwise, if a domain list file path is provided, read the domains from the file and retrieve their SPF records
elseif ($DomainList) {
    if (Test-Path -Path $DomainList) {
        $domains = Get-Content -Path $DomainList
        foreach ($domain in $domains) {
            $results += Get-DMARCRecord -domain $domain
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
Write-Host "DMARC records have been exported to $OutputPath"
