# User spaces Management

This set of tools provides ways to handle user spaces content from a program. It gets some inspiration from the famous TAATOOL suite of utilities, and more specifically, the [user spaces category](https://www.taatool.com/document/C_usrspc.html). These tools are intended to help managing the content of a user space filled up with the output of List APIs, such as QUSLJOB.

Two kinds of tools are expected in this topic.

The first one provides functions within a service program to create a user space, retrieve its information and attributes and retrieve its entries. They are intended to be used from a program. Let's start to name those functions:

1. UserSpaceCrt() to create a user space
2. UserSpaceRtvInf() to retrieve the information and attributes of a user space
3. UserSpaceRtvEnt() to retrieve the content of an entry of a user space

The second one provides CL commands to fulfill the same objectives. They are intended to be used from a CL(LE) program. They are using the functions as described above. Let's name those commands.

1. USRSPCCRT to create a user space
2. USRSPCRTVI to retrieve the information and attributes of a user space
3. USRSPCRTVE to retrieve an entry of a user space
