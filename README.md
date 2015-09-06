# student-account-expirations

Quick set of scripts to check a list of student accounts for
expiration. Makes use of a Perl module (ISIS_Feed.pm) that is
privately held; contact the author if it is needed.

## Prep

    - A server that receives (or has access to) an ISIS feed and a
      copy of ISIS_Feed.pm are needed.
    - A Windows computer that has PowerShell with the Active Directory
      extensions is needed.
    - Update extend-expiration.ps1 and check-expiry.pl for the desired
      expiration date.

## Use

1. Given a list of expiring accounts, make sure that it contains a
   column for account names labeled "sAMAccountName" (case
   insensitive) and export it as a CSV called "expirations.csv".

2. From a Windows machine, search Active Directory for the accounts'
   URIDs (student IDs) so that the enrollment system can be checked.
   ```
   powershell -file find-urid.ps1
   ```

3. Transfer the output file (expiring-urids.csv) to the server with
   enrollment data.

4. Search the enrollment data for the students' IDs.
   ```
   ./check-expiry.pl
   ```

5. Transfer the new output file (expiring-urid-counts.csv) back to the
   Windows machine.

6. Based on the enrollment data, extend account expiration dates in
   AD:
   ```
   powershell -file extend-expiration.ps1
   ```

7. Review the output log file (son-student-expirations.txt).
