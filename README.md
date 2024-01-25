# DMARC, DKIM and SPF Record fetching scripts

## Usage Example

```powershell
PS > .\get-spf -Domain example.com -OutputPath .\spf.csv
```
### Flags

|Parameter|Description|Required|
|---------|-----------|--------|
|Domain|The domain to get the records for|Yes, if ```DomainsPath``` not specified|  
|DomainList|List of domain to get records for (See ```domains.txt```)|Yes, if ```Domains``` not specified|
|OutputPath|Output path and file name. Defaults to ```{recordType}_records.csv```|No|
