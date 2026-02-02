To launch the playbooks, ensure that the following conditions are met:

Ansible is installed using
`pipx install --include-deps ansible`

Inside this folder there must be:
1. **git_key** file, containing a private key needed to access the GitHub repository by SSH.
2. **id_rsa** file, containing a private key needed to SSH into the managed machines. 

To configure the machines, run
`ansible-playbook playbook.yml`

The playbook.yml contains all the plays needed for each machine. I left separate playbooks for each VM group for debug purposes.
