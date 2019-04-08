[![Build Status](https://dev.azure.com/john-doe1/prtg_sensor-spooler/_apis/build/status/joxz.prtg_sensor-spooler?branchName=master)](https://dev.azure.com/john-doe1/prtg_sensor-spooler/_build/latest?definitionId=1&branchName=master)

# prtg_sensor-spooler

Checks the Windows spooler service by printing a test page to a NUL printer.

When you send jobs to a NUL printer, files leave the spool as if they are being printed, but are deleted instead.

For this sensor to work, a dummy printer has to be installed and shared on the print server:

```powershell
$cred = Get-Credential
$SessionParams = @{}
$SessionParams.ComputerName = "printsrv01"

# if no WinRM enabled on the target server use DCOM
$SessionParams.SessionOption = (New-CimSessionOption -Protocol DCOM)

$session = New-CimSession @SessionParams -credential $cred

Add-Printerport -Name "NUL:"
Add-Printer -cimsession $session -name "MyDummyPrinter" -Drivername "Microsoft XPS Document Writer v4" -portname "NUL:"
```

## Environment Variables

`prtg_host` - set by PRTG when using `Set placeholders as environment variables` in the sensor settings

`cimprotocol` - sets the protocol to use with the `New-Cimsession` cmdlet (`DCOM`, `WSMAN`; defaults to `WSMAN`) 

## Parameters

`printer` - sets the printer name (default: `MyDummyPrinter`)