# Workstation tools used

In conjunction with PUB400, it was required to use a set of tools. They are described below including their setup. They are all free, or licensed in such a way that one can install and use them for free.

## IBM i Access Client Solution

This IBM software (iACS) provides essential tools to connect to an IBM i. The main modules I use with PUB400 are the 5250 Emulator, Database Schemas, Database Run SQL Scripts. The license is linked to the server and PUB400 has an unlimited license. So we can install it without issue.

Download site: [IBM i Access - Client Solutions](https://www.ibm.com/support/pages/ibm-i-access-client-solutions); a free IBM Id is required at download time.
Normally there is an alternative which to download it from PUB400's /QIBM/ProdData/Access/ACS/Base/ directory but the access is not allowed.

Setup main items:

- system name: pub400.com
- use SSL: Yes
- password prompting: Prompt for user profile and password every time
- IP address lookup frequency: always
- SSH Connections port: 2222
- SSH authentication mechanism for Open Source Package Management: SSH Key: privatekey.openssh (checkout [Using an ssh keys pair to login.md](https://github.com/MarcoDeSenas/IBMi-topics-thanks-to-pub400/blob/3edf8bb5fb8f5da847c13ddce5d850a24e18e9d8/HowTo/Using%20an%20ssh%20keys%20pair%20to%20login.md) for details about the way to create this key); unfortunately, we are not allowed to use this procedure on PUB400.
- SSH authentication mechanism for SSH Terminal: putty set as SSH client and private key provided through acsconfig.properties file
  - com.ibm.iaccess.PreferredSSHClient=Putty
  - com.ibm.iaccess.SSHClientOpts=-i privatekey.ppk

## Visual Studio Code

VSCode and **all IBM i related extensions** is used for all development activity applying on PUB400. There is no specific setting within all the various parameters of the software, however there are a couple of ones for the extensions got through the "IBM i Development Pack".

- Features
  - Quick Connect: selected
  - Enable SQL: selectd
  - Show description of libraries in User Library List view: not selected
  - Support EBCDIC streamfiles: selected
  - Errors to ignore: none
  - Auto Save for Actions: selected
- Source Code
  - Source ASP: none
  - Source File CCSID: *FILE
  - Enable Source Dates: not selected
  - Source date tracking mode: Edit Mode
  - Source Dates in Gutter: not selected
  - Read only mode: not selected
- Terminals (note: 5250 emulation from VSCode is not used)
  - 5250 encoding: default
  - 5250 Terminal Type: default
  - Set Device Name for 5250: not selected
  - Connection String for 5250: ssl:pub400.com 992
- Debugger
  - Debug port: 8005
  - Update production files: not selected (note: our libraries are PROD ones)
  - Debug trace: not selected
  - Debug securely: not selected
  - Certificate directory: /QIBM/ProdData/IBMiDebugService/bin/certs
- Temporary Data
  - Temporary library: DIMARCOB (note: this is important to set as VSCode will create temporary objects in this library, wnad will not properly work if it cannot proceed for any reason (do not forget that we cannot create libraries on PUB400))
  - Temporary IFS directory: /home/MYUSER/tmp
  - Clear temporary data automatically: selected
  - Sort IFS shortcuts automatically: selected

Download site: [Download Visual Studio Code](https://code.visualstudio.com/Download).

## putty

I use putty for any ssh access to PUB400 when there is no built-in feature in other tools (case of Visual Studio Code for instance). When dealing with IFS files it is sometimes easier to access it through ssh.

Download site: [PuTTY: a free SSH and Telnet client](https://www.chiark.greenend.org.uk/~sgtatham/putty/).

I have one pub400.com session set with the parameters below (other parameters keep the default value):

- Session
  - Host Name: pub400.com
  - Port: 2222
  - Connection Type: SSH
- Window/Appareance
  - Cursor Appareance: Block
  - Cursor Blinks: selected
- Connection/Data
  - Auto-login username: myprofile
- Connection/SSH
  - SSH protocol version: 2 selected
- Connection/SSH/Auth
  - Display pre-authentication banner: selected
  - Private key file for authentication: privatekey.ppk

In order to use any ssh connection to PUB400, the known_hosts file used by putty must be updated the first time such a connection is requested. Once done, the content of C:\Users\myuser\.ssh\knwon_hosts is similar to below:

```text
[pub400.com]:2222 ssh-ed25519 somekeyusedbypub400toensureitisreallypub400
```

## FileZilla Client

Files transfers to/from PUB400 can be easily done with FileZilla Client. I use a remote site with SFTP - SSH File Transfer Protocol and my private key to login.

Download site: [FileZilla®, the free FTP solution](https://filezilla-project.org/).

Below is and xml export of the FileZilla client remote sites configuration.

```xml
<Server>
    <Host>pub400.com</Host>
    <Port>2222</Port>
    <Protocol>1</Protocol>
    <Type>0</Type>
    <User>myuser</User>
    <Keyfile>privatekey.ppk</Keyfile>
    <Logontype>5</Logontype>
    <EncodingType>Custom</EncodingType>
    <CustomEncoding>CP-1252</CustomEncoding>
    <BypassProxy>0</BypassProxy>
    <Name>pub400</Name>
    <LocalDir>C:\Users\myuser\Downloads</LocalDir>
    <RemoteDir>1 0 4 home 7 MYUSER</RemoteDir>
    <SyncBrowsing>0</SyncBrowsing>
    <DirectoryComparison>0</DirectoryComparison>
</Server>
```

## SSHFS-Win

Despite this software is no longer updated, I use it to provide a file system access to PUB400's IFS through an encrypted connection which is sftp. This software provides the layer to emulate a file system access through sftp. All the settings are done with SSHFS-Win Manager.

Download site: [SSHFS-Win · SSHFS for Windows](https://github.com/winfsp/sshfs-win/blob/master/README.md).

## SSHFS-Win Manager

In conjunction with SSHFS-Win, SSHFS-Win Manager provides a graphical interface to set a file system access through sftp. It is quite simple to use as there are only two kinds of parameter to set:

Those related to the SSHFS-Win program:

- SSHFS BINARY: C:\Program Files\SSHFS-Win\bin\sshfs.exe
- PROCESS TIMEOUT: 15
- STARTUP WITH WINDOWS: ON
- DISPLAY SYSTEM TRAY MESSAGE ON CLOSE: ON
- SHOW DEBUG PANEL: OFF

Those related to the connection to the servers:

- BASIC/NAME: pub400
- BASIC/CONNECTION
  - IP/HOST: pub400.com
  - PORT: 2222
  - USER: myuser
  - AUTHENTICATION METHOD: Private key (file)
  - KEY FILE: privatekey.ppk
- BASIC/REMOTE
  -PATH: /home/MYUSER
- BASIC/LOCAL
  - DRIVE LETTER: P:
- ADVANCED/CONNECT ON STARTUP: ON
- ADVANCED/TRY TO RECONNECT ON CONNECTION LOST: ON
- CUSTOM COMMAND LINE PARAMS: OFF

With both those two SSHFS-Win programs, the workstation has a permanent encrypted and transparent access to my home directory on PUB400. Example below:

```text
P:\>dir
 Le volume dans le lecteur P s’appelle pub400
 Le numéro de série du volume est 8F63-2FAB

 Répertoire de P:\

19/08/2023  13:19               240 .Xauthority
19/08/2023  16:20            11 291 .bash_history
28/07/2022  16:47               198 .bash_profile
09/03/2023  17:15                24 .bashrc
20/07/2023  22:11    <DIR>          .iSeriesAccess
20/07/2023  22:13                64 .isql_history
20/07/2023  22:11                 0 .odbc.ini
30/07/2022  11:16                42 .profile
10/11/2022  15:07                40 .python_history
07/06/2023  18:50               436 .sh_history
07/06/2023  18:43    <DIR>          .ssh
16/06/2023  11:20                44 .vi_history
19/08/2023  16:20    <DIR>          .vscode
27/07/2023  17:01    <DIR>          projects
19/08/2023  13:18    <DIR>          tmp
              10 fichier(s)           94 299 octets
               5 Rép(s)  481 482 366 976 octets libres
```

Download site: [SSHFS-Win Manager](https://github.com/evsar3/sshfs-win-manager).
