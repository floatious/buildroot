setenv bootargs root=PARTLABEL=rootfs clkin_hz=(25000000) earlycon clk_ignore_unused earlyprintk console=ttyS2,1500000n8 rootwait
fatload mmc 1:1 ${loadaddr} image.itb
bootm ${loadaddr}
