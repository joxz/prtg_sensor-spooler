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

Add-Printer -cimsession $session -name "MyDummyPrinter" -Drivername "Microsoft XPS Document Writer v4" -portname "NUL:"
Set-Printer -cimsession $session -Name "MyDummyPrinter" -Shared $True -Published $True -ShareName "MyDummyPrinter"
```
