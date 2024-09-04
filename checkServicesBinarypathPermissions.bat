@echo off
:: Turns off command echoing so the script output is cleaner

for /f "tokens=2 delims=:" %%i in ('sc query state= all ^| findstr "SERVICE_NAME"') do (
    :: This loop extracts each service name on the system.
    :: 'sc query state= all' lists all services.
    :: 'findstr "SERVICE_NAME"' filters the output to just the lines containing "SERVICE_NAME".
    :: The service name is the second token (hence, tokens=2) when delimited by a colon (delims=:).
    
    set servicename=%%i
    :: Sets the variable servicename to the extracted service name.
    
    set servicename=!servicename:~1!
    :: Removes the leading space from the service name (trims it).
    
    for /f "tokens=3 delims= " %%j in ('sc qc !servicename! ^| findstr /i "BINARY_PATH_NAME"') do (
        :: This inner loop extracts the binary path name of the service.
        :: 'sc qc !servicename!' queries the configuration of the service.
        :: 'findstr /i "BINARY_PATH_NAME"' filters the output to just the line with the binary path.
        :: The binary path is the third token (tokens=3) when delimited by spaces (delims= ).

        echo ======================================================================
        :: Prints a separator line to make the output more readable.
        
        echo Service Name: !servicename!
        :: Prints the name of the service being analyzed.
        
        echo Binary Path: %%j
        :: Prints the binary path of the service.

        icacls "%%j"
        :: Runs the icacls command on the binary path to display permissions.
    )
)
pause
:: Pauses the script at the end so the user can read the output before the window closes.
