$device = $env:prtg_host
param([string]$printer = "mydummyprinter")
function out-TestPage {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$false)]
        [string]$printer = "mydummyprinter",
        
        [Parameter(Mandatory=$true)]
        [string]$device
    )

    # setup cim session
    $session = new-cimsession -computername $device

    # print testpage
    Invoke-CimMethod -MethodName PrintTestPage -cimsession $session -InputObject (
        Get-CimInstance win32_printer -Filter “name LIKE '$($printer)'”
    )
}

write-output "<?xml version="1.0" encoding="utf-8" ?>"
write-output "<prtg>"

try {
    $result = out-TestPage -device $device -printer $printer

    if ($result.ReturnValue -eq "0") {
        write-output "<result>"
        write-output "<channel>Print Job Test status</channel>"
        write-output ("<value>{0}</value>" -f $result.ReturnValue)
        write-output "<ValueLookup>prtg.standardlookups.aws.status</ValueLookup>"
        write-output "</result>"
    }
}

catch [system.exception] {
    write-output  "<error>1</error>"
    write-output  "<text>$_</text>"
}

write-output "</prtg>"