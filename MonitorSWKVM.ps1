# Small script to act as a psuedo KVM for my monitors. Utilizes "ControlMyMonitor" from Nirsoft https://www.nirsoft.net/utils/control_my_monitor.html
# Andrew Lund
# 01-17-24

$dir = "C:\Program Files\controlmymonitor"
$exeName = "ControlMyMonitor.exe"
$exePath = "$dir\$exeName"
$inputSelectCommand = "60"

$portraitMonitorID = "\\.\DISPLAY1\Monitor0"
$mainMonitorID = "\\.\DISPLAY3\Monitor0"
$rightMonitorID = "\\.\DISPLAY2\Monitor0"

# Portrait, Main, Right Monitor in that order (InputSelect Value)
$laptopValues = @("18","18","18")
# Portrait, Main, Right Monitor in that order (InputSelect Value)
$desktopValues = @("15","15","16")

# If 15 we are using desktop, if 18 we are using laptop
$getCurrentInput = (Start-Process -FilePath "$exePath" -ArgumentList @("/GetValue", "`"$portraitMonitorID`"", "$inputSelectCommand") -Wait -PassThru).ExitCode


if ($getCurrentInput -eq $laptopValues[0]) # Are we on laptop?
    {
        $inputCodes = $desktopValues
    }
Else
    {
        $inputCodes = $laptopValues
    }

# Send codes
Start-Process -FilePath "$exePath" -WorkingDirectory "$dir" -ArgumentList @(
"/SetValue", "`"$portraitMonitorID`"", "$inputSelectCommand", "$($inputCodes[0])", # Portrait Monitor
"/SetValue", "`"$mainMonitorID`"", "$inputSelectCommand", "$($inputCodes[1])", # Main Monitor
"/SetValue", "`"$rightMonitorID`"", "$inputSelectCommand", "$($inputCodes[2])" # Right Monitor
) -wait
