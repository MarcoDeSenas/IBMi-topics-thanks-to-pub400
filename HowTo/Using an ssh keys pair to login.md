# How to setup ssh keys exchange to login from a workstation to an IBM i system

Now that Open Source Software get more and more common on IBM i, using ssh protocol to connect to a system becomes almost a requirement. A lot of workstation tools make use of ssh, and as ssh includes tools like sftp, scp, more and more organizations require ssh based files transfers through sftp and scp.

Like other connecivity tools, ssh (including sftp and scp) requires a login based on a user id. Regarding authentication, the two main procedures use either a classical password or a private/public keys pair exchange. The keys exchange provides the big advantage to allow automation as there is no need for any end user action.

In place of describing how to create the keys pair, how to install the public one on IBM i, how to setup a couple of common ssh clients software, as there is no need to reinvent the wheel, there is this excellent document from Seiden Group [How to Configure and Use SSH on IBM i](https://www.seidengroup.com/how-to-configure-and-use-ssh-on-ibm-i/). It contains everything needed. It was applied for all the workstation software based on ssh which is used for building this repository.
