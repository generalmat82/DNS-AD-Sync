You must have a keytab file so that you do not need to enter a password when connecting to the AD user.

This is done by via the ktutil tool.
```bash
ktutil
addent -password -p <user> -k -f
wkt <user>.keytab
quit
```
After the `addent` command, you will be prompted to enter a password.