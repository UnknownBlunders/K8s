# Setting up a new device:

1. Reset it to absolutely blank:

Open a Mikrotik terminal and run:

```bash
/system reset-configuration no-defaults=yes
```

It'll take a minute to reboot.

2. Connect to the device via Winbox over Mac address

Connect directly to one of the devices interfaces. This may work if you're not directly connected, but it definitely won't be a routed connection. L2 only

The device should show up in the device list on the right side. Cick specifically on the mac address portion of the device listing. Enter the username "admin" and leave the password field blank. It'll ask you to reset the password when you login.

3. Provision the starting IP Address:

Open the Mikrotik terminal and run the following commands. Be sure to adjust the first to use the correct interface (the one you're connected to).

```bash
/ip address add address=192.168.88.1/24 interface=ether4
```

Set your device to have an IP on the 192.168.88.0/24 network.

4. Set the provider to connect to 192.168.88.1 via http, not https

I have this option commented out. Uncomment it and comment the "real" https url.

5. Apply the init configuration.

Each device should have a terraform file called init.tf.bak. This contains the first Terraform that should be run on the device. To ensure the terraform applies correctly, it must:
    
    1. Not disable non-tls services (www, api)
    2. Setup the core vlans and interfaces, including the "real" long term management IP
    3. Import the temporary management IP
    4. Leave the Management IP's interface on vlan 1
    5. Setup the TLS services (www-ssl, api-ssl)

Move or rename the actual terraform files so they don't get run.

Apply the initial config. You'll have to plan and apply twice. The second time just sets the tls cert to be trusted.

6. Rename or move the init config, re-enable the real config.

Be sure to plug in to the "real" management interface. If configuring just a switch, at this point you can connect it to the rest of the network via its ususal trunk port. You can remove the static IP you set for your local machine. If your not configuring a switch (say, you're configuring the core router) you may need to adjust the static IP to be on the real management network.

Change the terraform provider to use the tls service.

Rename or move the actual terraform files so they do run. Rename or move the init config so it doesn't run.

Plan and apply!

7. Firewalls

When appling config to a new router, I apply everything except the firewall first. Then, I comment out all the drop rules and apply. After that, I uncomment the drop rules, and apply. That seems to work well in testing so far.
