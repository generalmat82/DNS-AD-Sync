First Pseudocode.

This Pseudocode is very high level. Going in very low amount of details.
# Pseudocode
1. Wait until an IP change is detected.
2. Verify the IP change actually happened.
3. Obtain a list of all current IP.
4. Obtain AD credentials.
5. Update all DNS records for device.
6. end

# FlowChart
```mermaid
flowchart TB
    n1["IP change detected"] --> n2["Did IPs<br>really change?"]
    n2 -- Yes --> n3["Generate list of current IP"]
    n3 --> n4["Get AD credentials"]
    n4 --> n5["Update DNS records"]
    n5 --> n6["END"]
    n2 -- No --> n6

    n1@{ shape: terminal}
    n2@{ shape: decision}
    n6@{ shape: terminal}
```