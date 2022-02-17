# CoreOS Config for Lucy

lucy is machine that runs Plex and controls WiFi APs, in my home.

### Bootstrapping

Download latest Fedora LiveCD and boot into the live system. Once in user land:

```sh
mkdir -p ~/.ssh && chmod 700 ~/.ssh
curl -o ~/.ssh/authorized_keys -L https://github.com/hurricanhrndz.keys
chmod 600 ~/.ssh/authorized_keys
sudo systemctl start sshd
```

Back on the client system, produce the ignition file.

```sh
terraform init
terraform apply
scp output/coreos-lucy.ign liveuser@localhost-live:~/config.ign
scp bootstrap.sh liveuser@localhost-live:~/bootstrap.sh
```

Now ssh to the host running the LiveCD, and apply the ignition config.

```sh
ssh liveuser@localhost-live
./bootstrap.sh
```
