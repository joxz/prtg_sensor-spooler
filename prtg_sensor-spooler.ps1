param([string]$printer = "MyDummyPrinter")
$device = $env:prtg_host
$cimprotocol = $env:cimprotocol

function Out-TestPage {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$false)]
        [string]$printer = "MyDummyPrinter",

        [Parameter(Mandatory=$true)]
        [string]$device
    )

    # setup cim session
    if (!$cimprotocol) {
        $cimprotocol = "WSMAN"
    }

    $SessionParams = @{}
    $SessionParams.ComputerName = $device
    $SessionParams.SessionOption = (New-CimSessionOption -Protocol $cimprotocol)
    $session = New-CimSession @SessionParams

    # print testpage
    $prt = Get-CimInstance Win32_Printer -filter ("Name LIKE '{0}'" -f $printer)

    Invoke-CimMethod -MethodName PrintTestPage -CimSession $session -InputObject $prt
}

write-output "<?xml version="1.0" encoding="utf-8" ?>"
write-output "<prtg>"

try {
    $result = Out-TestPage -device $device -printer $printer

    if ($result.ReturnValue -eq 0) {
        write-output "<result>"
        write-output "<channel>dummy printer test page status</channel>"
        write-output ("<value>{0}</value>" -f $result.ReturnValue)
        write-output "<ValueLookup>prtg.standardlookups.aws.status</ValueLookup>"
        write-output "</result>"
        exit 0
    }
}
catch [system.exception] {
    write-output  "<error>1</error>"
    write-output  "<text>$_</text>"
    exit 1
}

write-output "</prtg>"