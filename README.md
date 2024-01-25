# DMARC, DKIM and SPF Record fetching scripts

## Usage Example

```powershell
PS > .\get-spf -Domain example.com -OutputPath C:\spf.csv
```

```powershell
PS > .\get-spf -DomainList .\domains.txt -OutputPath C:\spf.csv
```

## Example `DomainsList` file
The content of the file containing the domains to check should have a single domain on each line, as follows:
```
example.com
subdomain.example.com
example.net
example.org
...
```

## Flags

|Parameter|Description|Required|
|---------|-----------|--------|
|Domain|The domain to get the records for|Yes, if `DomainsPath` not specified|  
|DomainList|List of domain to get records for (See `domains.txt`)|Yes, if `Domains` not specified|
|OutputPath|Output path and file name. Defaults to `{recordType}_records.csv`|No|

## DKIM
In order to get the correct information for DKIM records, you will need to know what the selector for the record is. Generally, this can be found in the email header or from the service that is configured to sign messages with DKIM.

The scripts only work with Windows as they rely on commands that are not included with the Powershell Core distribution.
