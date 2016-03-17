# James' Macbook
This repository hosts the ansible playbook that I use to configure my
laptop to the desired state I want to keep it.


## Running the Playbook

First install the requirements.

```
ansible-galaxy install -r requirements.txt
```

Then run the playbook.


```
ansible-playbook -K -c local -i "localhost," main.yml

```


## The Layout
Installed homebrew packages can be found under `vars/main.yaml`.

The roles directory contains my role for configuring zsh to my
preferences.


## Disclaimer
Obviously run this at your own risk. By running this on your machine
you're saying that you totally trust me without reservation.
