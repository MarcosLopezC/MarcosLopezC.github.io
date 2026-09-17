If you use full disk encryption on Linux, you can take advantage of your system’s TPM2 (Trusted Platform Module) to automatically unlock your encrypted volume at boot, eliminating the need to manually enter your password each time the system starts.
In this article, I’ll show you how to set it up in Fedora (although the process is almost the same for other distributions).

## Verify TPM2 Availability

First, check if a TPM2 module is present.
Run either command:

```bash
cat /sys/class/tpm/tpm0/device/description
cat /sys/class/tpm/tpm0/tpm_version_major
```

If available, you’ll see something like:

```
TPM 2.0 Device
```

## Identify Your LUKS Partition

List your block devices to locate the LUKS partition:

```bash
lsblk
```

Example output:

```
NAME                                          MAJ:MIN RM   SIZE RO TYPE  MOUNTPOINTS
nvme0n1                                       259:5    0 931.5G  0 disk  
├─nvme0n1p1                                   259:6    0   600M  0 part  /boot/efi
├─nvme0n1p2                                   259:7    0     1G  0 part  /boot
└─nvme0n1p3                                   259:8    0 929.9G  0 part  
  └─luks-5fa3c730-9a12-4974-a772-67febc921c4c 253:0    0 929.9G  0 crypt /home
                                                                         /
```

Here, `/dev/nvme0n1p3` is the LUKS partition.

## Enroll the Device

Enroll your partition to the TPM2:

```bash
sudo systemd-cryptenroll --wipe-slot tpm2 --tpm2-device auto /dev/nvme0n1p3
```

## Configure `/etc/crypttab`

Edit your `/etc/crypttab` file to add the option `tpm2-device=auto`.

For example, change:

```
luks-5fa3c730-9a12-4974-a772-67febc921c4c UUID=5fa3c730-9a12-4974-a772-67febc921c4c none discard
```

to:

```
luks-5fa3c730-9a12-4974-a772-67febc921c4c UUID=5fa3c730-9a12-4974-a772-67febc921c4c none tpm2-device=auto,discard
```

## Update Initramfs

On Fedora, rebuild your _initramfs_ to apply the changes:

```bash
sudo dracut -f
```

## Using PCRs for Extra Security _(Optional)_

PCRs (Platform Configuration Registers) allow for advanced integrity checks.
To enroll with PCRs:

```bash
sudo systemd-cryptenroll --wipe-slot tpm2 --tpm2-device auto --tpm2-pcrs "0+1+2+3+4+5+7+9" /dev/nvme0n1p3
```

Update `/etc/crypttab` accordingly:

```
luks-5fa3c730-9a12-4974-a772-67febc921c4c UUID=5fa3c730-9a12-4974-a772-67febc921c4c none tpm2-device=auto,tpm2-pcrs=0+1+2+3+4+5+7+9,discard
```

Using PCRs `0+1+2+3+4+5+7+9` means the disk will only unlock if specific system measurements match, protecting against tampering.

PCR 0–7 cover various boot measurements: firmware, bootloader, kernel, initramfs, and other early boot components.

PCR 9 is platform-specific. On my system it measures all the boot files, including the kernel.

For details about each PCR, see the [Linux TPM PCR Registry](https://uapi-group.org/specifications/specs/linux_tpm_pcr_registry/).

## Conclusion

That’s it.
Your system should now unlock itself automatically every time you boot up, without needing to enter your disk encryption password.
If any of the TPM measurements fail or change, you’ll simply be prompted to enter your password by hand; you won’t be locked out of your system.
