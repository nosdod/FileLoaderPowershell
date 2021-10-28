# FileLoaderPowershell

To view the script for development
Run gui.ps1 from within Visual Studio Code configured with the Powershell plugin

To run the UI
Open a Windows Powershel session, navigate to the directory containing gui.ps1
Run it with .\gui.ps1

The UI expects to find a REST server at http://localhost:3000 with the following endpoints
/entropy-status
/send-new

You can find the server application that provides these endpoints at https://github.com/nosdod/FileLoaderNodeServer
