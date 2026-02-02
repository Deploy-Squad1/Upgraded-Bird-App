# Steps to develop VMs:
1. Install Vagrant https://developer.hashicorp.com/vagrant/install .
   To check installation use: `vagrant --version`.


2. Create project **folder**, open it and use `vagrant init`. This will create Vagrantfile in your folder automatically.

3. Generate SSH key pair for VM authentication:
```bash
   ssh-keygen -t rsa -b 4096 -f ~/.ssh/id_rsa
```
   This creates:
   - `~/.ssh/id_rsa` (private key - keep secure)
   - `~/.ssh/id_rsa.pub` (public key - will be copied to VMs)

4. Change Vagrantfile to the example provided in this folder (it contains such information: which provider to use (VmWare, VirtualBox, UTM), base images (boxes), static IPs, ports for SSH connection)

5. Only after configuring Vagrantfile use `vagrant up` (or `vagrant up --provider=virtualbox` if you want to use specific provider)

6. Use `vagrant box list` to check all active boxes

7. For connection to VM use `vagrant ssh <vmname>`

8. Default user&pass: **vagrant**

# Helpful information:
- Suspend the machine to temporarily pause your work `vagrant suspend` (It sets VMs to sleep mode). When you are ready to resume, use `vagrant resume` to restore the environment to its previous state.

- Halt the environment to shut down the machine gracefully with `vagrant halt`. The next time you start your environment with `vagrant up`, Vagrant will start the machine in a clean, powered-off state. This is useful for conserving resources when you are not actively using the environment.

- Destroy all VMs and clean up resources with `vagrant destroy`. This removes all VMs but keeps your Vagrantfile.

- Check the status of your VMs with `vagrant status`.
