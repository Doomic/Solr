# Solr
Install (and uninstall) script to setup a Windows Service
Created for Solr 6.6.0

# Install
First download Solr http://lucene.apache.org/solr/mirrors-solr-latest-redir.html

Unpack the downloaded file on your desired location (can't be moved after running the installation)<br />
<i>C:\ for example (or use your program files folder)</i>

Put the files of this repository in the root folder of solr.<br />
<i>Like C:\solr-6.6.0\</i>

run the INSTALL.bat file ("run as administrator" will prevent that you will have to accept multiple times that a program will be executed)

# About
The installation is build upon apache daemon (common-daemon).<br />
https://commons.apache.org/proper/commons-daemon/download_daemon.cgi

And the checks if the service is already installed / running are done by Sc.exe (microsoft)<br />
https://support.microsoft.com/en-us/help/251192/how-to-create-a-windows-service-by-using-sc-exe

# Disclaimer
Use the script at your own risk. This files are provided "as is" without express or implied warranty.
