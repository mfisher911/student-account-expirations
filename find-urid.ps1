# powershell -file find-urid.ps1
# URID comes back as a multivalued attribute, so select the first value
#
# http://blogs.technet.com/b/heyscriptingguy/archive/2013/07/22/export-user-names-and-proxy-addresses-to-csv-file.aspx
#
# some people don't have a URID; from manual inspection, their names
# also weren't in the ISIS feed, so they are presumably long-graduated
# or withdrawn

Import-Csv expirations.csv | ForEach-Object {
  Get-ADUser $_.samaccountname -Properties URID |
  select samaccountname,@{ L = 'URID'; E = { $_.urid[0] } }
} | Export-Csv expiring-urids.csv
