#!/bin/sh

modprobe pci_epf_test
mount -t configfs none /sys/kernel/config
cd /sys/kernel/config/pci_ep/
mkdir functions/pci_epf_test/func1
echo 0x1d87 > functions/pci_epf_test/func1/vendorid
echo 0x3588 > functions/pci_epf_test/func1/deviceid
echo 32 > functions/pci_epf_test/func1/msi_interrupts
echo 32 > functions/pci_epf_test/func1/msix_interrupts
ln -s functions/pci_epf_test/func1 controllers/a40000000.pcie-ep/
echo 1 > controllers/a40000000.pcie-ep/start
