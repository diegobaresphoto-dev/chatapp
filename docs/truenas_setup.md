# TrueNAS Core VM Setup for E2EE Chat App

Since TrueNAS Core (FreeBSD-based) does not support Docker natively, the application must run inside a Linux Virtual Machine.

## 1. Create a Dataset for VM Storage
In the TrueNAS Core Web UI:
- Go to **Storage -> Pools**.
- Create a new Dataset (e.g., `tank/vms/chat-app`).
- (Optional) Create a Dataset for backups: `tank/backups/chat-app-data`.

## 2. Create the Virtual Machine
- Go to **Virtual Machines -> Add**.
- **Guest Operating System**: Linux.
- **Name**: `ChatApp-Backend`.
- **System Clock**: Local.
- **Boot Method**: UEFI (preferred).
- **Memory**: At least 4GiB (8GiB recommended for ZFS + Docker overhead).
- **Cores**: 2 or 4.
- **Disk**: 40GiB+ (ZVol based). 
- **Network Interface**: Select your main bridge/nic.
- **Installation Media**: Use an Ubuntu 22.04 LTS or Debian 12 ISO.

## 3. Install Docker & Docker Compose
Once the VM is installed and you have SSH access:
```bash
# Install Docker
sudo apt-get update
sudo apt-get install ca-certificates curl gnupg
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg

# Add Repo
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
```

## 4. Mount ZFS Data (Optional but Recommended)
If you want the Docker volumes to live directly on TrueNAS ZFS (for better snapshots/backups):
1. Enable **NFS Service** on TrueNAS.
2. Create an **NFS Share** for your data dataset.
3. In the Linux VM, mount the NFS share:
   ```bash
   sudo apt install nfs-common
   sudo mount <TRUENAS_IP>:/mnt/tank/chat-app-data /mnt/data
   ```

## 5. Deployment
Clone the repo into the VM and run:
```bash
cd infra
docker compose up -d
```
