# DNS-AD-Sync
A short script that allows Linux devices to sync IPs with Active Directory DNS.

# Prerequisites
The are a few prerequisites required that will not be covered here:
- An Active directory domain must be configured with DNS.
- A zone for the devices with a user who has access to modify the zone.
- For now the script uses Infisical for storing the password of the user. (It is possible that alternatives are added)
  - A machine Identity is required. For now, only the universal auth and token auth will be implemented. (Room for expension)

# Dependencies
- Infisical
- curl
- krb5-user