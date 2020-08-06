Ansible playbook as PKI with CA and RA
======================================

This is a example for ansible as CA in a PKI.

That is the CA tree, that is created by the Ansible-Playbook:

![docs/pki-tree.png](docs/pki-tree.png)

Run
---

*Preparation:* Edit the inventory file and change the IPs of the VMs.

For run this example enter:

```bash
ansible-playbook -i ./hosts  ./site.yml
```


Helpful tools
----------------

* [kleopatra](https://docs.kde.org/stable5/en/pim/kleopatra//)
* [Xca](https://hohnstaedt.de/xca/)