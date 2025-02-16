#!/bin/bash

if [ -f "bluetooth.service.bk" ] ; then
    sudo cp  bluetooth.service.bk /lib/systemd/system/bluetooth.service
    sudo systemctl daemon-reload
    sudo /etc/init.d/bluetooth start
fi
sudo systemctl stop init_bt_mk
sudo systemctl disable init_bt_mk
sudo rm /lib/systemd/system/init_bt_mk.service
