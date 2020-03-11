#!/bin/sh -xe

cp etc/init.d/iodined /etc/init.d/iodined

ln -s /etc/init.d/iodined /etc/rc0.d/K01iodined
ln -s /etc/init.d/iodined /etc/rc1.d/S01iodined
ln -s /etc/init.d/iodined /etc/rc2.d/S01iodined
ln -s /etc/init.d/iodined /etc/rc3.d/S01iodined
ln -s /etc/init.d/iodined /etc/rc4.d/S01iodined
ln -s /etc/init.d/iodined /etc/rc5.d/S01iodined
ln -s /etc/init.d/iodined /etc/rc6.d/K01iodined
