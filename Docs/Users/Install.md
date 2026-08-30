# How to install
# 1.0 - Installing Dependencies
on Debian based systems you can use the following:
```bash
sudo apt install curl krb5-user
```
You will be prompted to enter a realm. Enter the domain name IN ALL CAPS of your AD.

# 2.0 - Setup and testing or AD connectivity
## 2.1 - User auth
First we need to ensure that we can authenticate to the user.

For that we can use the following:
```bash
kinit <user>
```
You should be prompted to enter a password and if all is correct running `klist` should return something similar to this:
```
Ticket cache: FILE:/tmp/krb5cc_1001
Default principal: <user>@<realm>

Valid starting       Expires              Service principal
08/29/2026 19:12:18  08/30/2026 05:12:18  krbtgt/<user>@<realm>
        renew until 08/30/2026 19:11:51
```

## 2.2 - DNS access
Now we can try to update the DNS.
With a session running run the following, filling in the correct values:
```
nsupdate <<EOF
gsstsig
server <domain controller>
realm <domain>
zone <zone affected>
update add <device FQDN> <TTL> <A for ipv4 or AAAA for ipv6> <ip address>
```
Make sure the `zone` value ends in a `.` (e.x. `devices.domain.com.`)

TTL can be any value in seconds, recommended default `86400`

Verify the DNS server to make sure it has updated.

You can now use `kdestroy` to end the session.


# 3.0 - Downloading repository.
We can now download the repository. Recommended location is in `/opt`
```bash
git clone https://github.com/generalmat82/DNS-AD-Sync.git
```

# 4.0 - Setup

## 4.1 - Basic setup
Now we can make the basic setup. This includes making the `.env` and copying the service file to the right location.
```bash
cd /opt/DNS-AD-sync/src
cp .env.example .env
sudo cp dns-ad-sync.service /etc/systemd/system/dns-ad-sync.service
sudo systemctl daemon-reload
```

## 4.2 - Keytab creation
So that we do not need to write a password each time to connect to our user, we can use a keytab file where the password is saved encrypted.

This is done by via the `ktutil` tool.
```bash
ktutil
addent -password -p <user> -k 0 -f
wkt <user>.keytab
quit
```
After the `addent` command, you will be prompted to enter a password.

You should now have a keytab file.

## 4.3 - env file setup
using a file editor of your choice (like `nano`) modify the `.env` file and enter the correct values.
```bash
nano .env
```

## 5.0 - Enable the service
Now we can finally start the service.
```bash
sudo systemctl enable --now dns-ad-sync.service
```

## 5.1 - Test
You can now test the system by running the following entering correct values then verify if the IP was added to the DNS server:
```bash
sudo ip a a <ip address>/24 dev <interface>
```
To remove the IP from the machine you can run:
```bash
sudo ip a del <ip address>/24 dev <interface>
```