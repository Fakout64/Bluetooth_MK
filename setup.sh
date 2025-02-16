#!/bin/bash
sudo apt-get update -y
sudo apt-get install -y --ignore-missing git tmux bluez bluez-tools bluez-firmware
sudo apt-get install -y --ignore-missing python3 python3-dev python3-pip python3-dbus python3-pyudev python3-evdev python3-gi

sudo apt-get install -y libbluetooth-dev
sudo PIP_BREAK_SYSTEM_PACKAGES=1 pip3 install git+https://github.com/pybluez/pybluez.git#egg=pybluez

sudo cp dbus/org.thanhle.btkbservice.conf /etc/dbus-1/system.d
sudo systemctl restart dbus.service

# Changes start
SERVICE_FILE="/lib/systemd/system/bluetooth.service"

# Check if --noplugin=input is already present
if grep -q 'ExecStart=.*--noplugin=input' "$SERVICE_FILE"; then
    echo "--noplugin=input is already present in ExecStart."
else
    echo "Adding --noplugin=input to ExecStart..."

    # Backup the original file
    sudo cp "$SERVICE_FILE" "$SERVICE_FILE.bak"

    # Modify ExecStart to include --noplugin=input
    sudo sed -i '/^ExecStart=/ s/$/ --noplugin=input/' "$SERVICE_FILE"

    echo "Updated Bluetooth service file."
fi

sudo systemctl daemon-reload
sudo systemctl restart bluetooth
echo "Restarted bluetooth service"

#!/bin/bash

# Detect the current user
USER=$(whoami)

# Define service file path
SERVICE_FILE="/etc/systemd/system/init_bt_mk.service"

# Create systemd service file with the correct user
sudo bash -c "cat > $SERVICE_FILE" <<EOL
[Unit]
Description=Initalize Bluetooth service for mouse and keyboard
After=multi-user.target

[Service]
Type=oneshot
User=$USER
WorkingDirectory=/home/$USER/Bluetooth_MK
ExecStart=sudo ./boot.sh
RemainAfterExit=yes

[Install]
WantedBy=default.target
EOL
sudo chmod +x ./boot.sh
# Reload systemd, enable, and start the service
sudo systemctl daemon-reload
sudo systemctl enable init_bt_mk
sudo systemctl start init_bt_mk

echo "Service installed and started for user: $USER"
# Changes end
