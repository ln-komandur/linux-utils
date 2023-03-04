## Only for Dell Inspiron 3542 

### MDS CPU Vulnerability
1. `dmesg --level=warn` and check if there is a warning like below
```
[    0.146525] MDS CPU bug present and SMT on, data leak possible. See https://www.kernel.org/doc/html/latest/admin-guide/hw-vuln/mds.html for more details.
```
2. `sudo nano /etc/default/grub` and edit the line `GRUB_CMDLINE_LINUX_DEFAULT="quiet usbcore.autosuspend=-1 mds=full,nosmt"` to have `mds=full,nosmt`
3. `sudo update-grub`, reboot and check `dmesg --level=warn` if the MDS CPU bug warning is gone

### EFI Secure boot
1. `sudo efibootmgr -v` and check if `BootCurrent` shows `0000`, which in turnpoints to `SHIMX64.EFI`. If not change the boot order to SHIMX64.EFI in the BIOS Boot order. Refer [Secure Boot Error: Invalid signature detected. Check secure boot policy in setup](https://askubuntu.com/questions/871179/secure-boot-error-invalid-signature-detected-check-secure-boot-policy-in-setup), [Double Ubuntu entry in BIOS boot options](https://askubuntu.com/questions/840602/double-ubuntu-entry-in-bios-boot-options) 
 
 
```
BootCurrent: 0000
Timeout: 0 seconds
BootOrder: 0000,0001,000C,000B
Boot0000* ubuntu shimx64	HD(1,GPT,d0d091ea-ce94-4f15-8f27-4d9a11007a81,0x800,0xef000)/File(\EFI\UBUNTU\SHIMX64.EFI)
Boot0001* ubuntu grubx64	HD(1,GPT,d0d091ea-ce94-4f15-8f27-4d9a11007a81,0x800,0xef000)/File(\EFI\UBUNTU\GRUBX64.EFI)
Boot000B* Onboard NIC(IPV4)	PciRoot(0x0)/Pci(0x1c,0x3)/Pci(0x0,0x0)/MAC(b82a72c2b8f3,0)/IPv4(0.0.0.00.0.0.0,0,0)..BO
Boot000C* Onboard NIC(IPV6)	PciRoot(0x0)/Pci(0x1c,0x3)/Pci(0x0,0x0)/MAC(b82a72c2b8f3,0)/IPv6([::]:<->[::]:,0,0)..BO

```
It may be required to go over this step a couple of times if a red message on "Secure Boot Violation" appears soon after BIOS Flash like below

![Alt text](secure-boot-violation.jpg "Secure Boot Violation")
