# powershell -file extend-expiration.ps1
#
Import-Csv expiring-urid-counts.csv | ForEach-Object {
  if ($_.urid -eq "") {
    "$($_.samaccountname) URID doesn't exist, allowing to expire"
  }
  elseif ($_.course_count -eq 0) {
    "$($_.samaccountname) has no courses, allowing to expire"
  }
  else {
    $new_date = "09/07/2016 00:00:00"
    $courses = "courses"
    if ($_.course_count -eq 1) {
      $courses = "course"
    }
    "$($_.samaccountname) has $($_.course_count) $courses, extending to $new_date"
    Get-ADUser $($_.samaccountname) |
    Set-ADUser -AccountExpirationDate $new_date
  }
} | Out-File son-student-expirations.txt
