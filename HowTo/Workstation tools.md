In conjunction with PUB400, it was required to use a set of tools. They are described below including their setup. They are all free, or licensed in suc a way that one can install and use them for free.

# IBM i Access Client Solution
This IBM software (iACS) provides essential tools to connect to an IBM i. The main modules I use with PUB400 are the 5250 Emulator, Database Schemas, Database Run SQL Scripts. The license is linked to the server and PUB400 has an unlimited license. So we can install it without issue.

Download site: [IBM i Access - Client Solutions](https://www.ibm.com/support/pages/ibm-i-access-client-solutions); a free IBM Id is required at download time.
Normally there is an alternative which to download it from PUB400's /QIBM/ProdData/Access/ACS/Base/ directory but the access is not allowed.

Setup main items:
- system name: pub400.com
- use SSL: Yes
- password prompting: Prompt for user profile and password every time
- IP address lookup frequency: always
- SSH Connections port: 2222
- SSH authentication mechanism: SSH Key: privatekey.openssh (checkout [Using an ssh keys pair to login.md](https://github.com/MarcoDeSenas/IBMi-topics-thanks-to-pub400/blob/3edf8bb5fb8f5da847c13ddce5d850a24e18e9d8/HowTo/Using%20an%20ssh%20keys%20pair%20to%20login.md) for details about the way to create this key); note that this works for Open Source Package Management (well, that would work if we were allowed to access on PUB400), but does not for SSH Terminal

# Visual Studio Code
In progress...

# putty
In progress...

# FileZilla Client
In progress...

# SSHFS-Win
In progress...

# SSHFS-Win Manager
In progress...
