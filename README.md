# DNS-AD-Sync
A short script that allows Linux devices to sync IPs with Active Directory DNS.

# Usage of AI in this project
AI was only used for the creation of the service file and to know how the IP change would be detected.

# Prerequisites
The are a few prerequisites required that will not be covered here:
- An Active directory domain must be configured with DNS.
- A zone for the devices with a user who has access to modify the zone.

# Dependencies
- Infisical
- curl
- krb5-user