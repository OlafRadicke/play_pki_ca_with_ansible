Ansible playbook as PKI with CA and RA
======================================

This is a example for ansible as CA in a PKI.

That is the CA tree, that is created by the Ansible-Playbook:

![docs/pki-tree.png](docs/pki-tree.png)

That is the work flow of the certification:

![docs/pki-tree.png](docs/pki-flow.png)


Azure pre setup
---------------

The configuration of the Azure setup is in the file group_vars/azure_deploy.yml.
For creating VMs in Azure cloud, you can use the playbook setup_azure.yml. Enter:

```bash
ansible-playbook -i hosts.yml setup_azure.yml
```

If your secrets encryptet than you can enter:

```bash
ansible-playbook  \
  --vault-password-file ~/.ssh/vault-password \
  -i hosts.yml \
  ./setup_azure.yml
```


For removing the azure setup enter:

```bash
ansible-playbook  \
  --vault-password-file ~/.ssh/vault-password \
  -i hosts.yml \
  ./destroy_azure.yml
```

Run the main playbook
---------------------

*Preparation:* Edit the host_vars file and change the IPs of the
VMs (in group_vars/pki.yml). And maybe the ansible user in the file pki.yml in
the group_vars.

For gedding the IPs of the VMs from Azure enter:
To obtain the IPs of the VMs from Azure, enter:

```bash
az network public-ip list --output table
Name                           ResourceGroup    Location            Zones    Address         AddressVersion    AllocationMethod    IdleTimeoutInMinutes    ProvisioningState
-----------------------------  ---------------  ------------------  -------  --------------  ----------------  ------------------  ----------------------  -------------------
demo-pki-policy-ca-service-ip  demo-pki         germanywestcentral           20.52.35.205    IPv4              Dynamic             30                      Succeeded
demo-pki-root-ca-ip            demo-pki         germanywestcentral           51.116.185.237  IPv4              Dynamic             30                      Succeeded
```


For run this example enter:

```bash
ansible-playbook -i ./hosts.yml  ./site.yml
```


Known issue
-----------

The playbook is switched off selinux. But for an effect,  ths need a restart
of the virtual machine.

Helpful tools
-------------

* [kleopatra](https://docs.kde.org/stable5/en/pim/kleopatra//)
* [Xca](https://hohnstaedt.de/xca/)

Helpful docs
------------

* [](https://www.golinuxcloud.com/openssl-create-certificate-chain-linux/)

TODOs
-----

### Check sign commits

```yml
- name: Convert the format of the certificate to pem format
  shell: |
    openssl x509 \
    -in {{ pki_publication_dir }}/{{ root_ca.common_name }}.crt \
    -out {{ pki_publication_dir }}/{{ root_ca.common_name }}.crt.pem \
    -outform PEM
```