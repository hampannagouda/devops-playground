# 🚀 Linux Expert Roadmap for Beginners

> Goal: Become confident in Linux administration, production troubleshooting, cloud environments, DevOps, and SRE practices.

---

# 📌 Phase 1: Linux Fundamentals

Learn how to navigate and manage files and directories.

## Commands

```bash
pwd
ls
cd
mkdir
rm
cp
mv
touch
find
locate
```

## Practice

```bash
find /var/log -name "*.log"
```

*# Directory Structure

```text
/
├*─ home
├── etc
├── var
├── usr
├──*boot
├── opt
├── tmp
└── proc
*`*

### Must Know

- Absolute paths
* Relative paths
- Hidden files
- F*le extensions
- Symbolic links

--*

# 📌 Phase 2: File Permissions &*Users

Most Linux issues involve p*rmissions.

## User Management

``*bash
whoami
id
groups
useradd
pass*d
su
sudo
```

## Permissions

Exa*ple:

```text
-r*xr-xr-x
```

Meaning:

```text
Own*r  -> rwx
Group  -> r-x
Others*->*r-x
```

## Commands

```bash
chmo*
chown*chgrp
```

Examples:

```bash
chmo* 755 script.sh

chown ubuntu:ubunt* file.txt
```

---

# 📌 Phase 3: *rocess Management

Learn how Linux*runs programs.

## Commands

```ba*h
ps
top
htop
pgrep
pkill
kill
kil*all
jobs
bg
fg
nohup
```

## Examp*es

```bash
ps -ef

ps aux

top
``*

Kill*a process:

```bash
kill -9 1234
`*`

## Process States

- Running
- *leeping
- St*pped
- Zombie

---

# 📌 Phase 4: *ystem Monitoring

Monitor resource*usage.

## Commands

*``bash
free -h
df -h
du -sh
uptime*vmstat
iostat
sar
```

## Examples*
Check*memory:

```bash
free -h
```

Chec* storage:

```bash
df -h
```

Chec* directory sizes:

```*ash
du -sh *
```

---

# 📌 Phase *: Networking

Essential for cloud *nd production servers.

## Command*

```bash
ping
curl
wget
ssh
scp
n*tstat
ss
dig
nslookup
traceroute
`*`

## Useful Examples

View listen*ng ports:

```bash
ss -tulnp
``*

Test service:

```bash
curl http*//localhost:5000
```

Port owner:
**``bash
sudo lsof -i :5000
```

---*
# 📌 Phase 6: Package Management
*Ubuntu package*manager*

## Commands

```bash
sudo apt up*ate

sudo apt upgrade

sudo apt in*tall nginx
```

## More Commands

*``bash
apt-cache search
apt remove*apt purge
apt autoremove
```

---
*# 📌 Phase 7: Log Analysis

Logs a*e the first place to look during i*cidents.

## Common Log Directory
*```text
/var/log
```

## Important*Logs

```text
/var/log/syslog
/var*log/auth.log
/var/log/kern.log
```*
## Commands

```bash
tail -f app.*og

grep ERROR app.log

journalctl*```

Examples:

```bash
journalctl*-xe

journalctl -u nginx
```

---
*# 📌 Phase 8: Systemd

Manage serv*ces in production.

## Commands

`*`bash
systemctl status nginx

syst*mctl start nginx

systemctl stop n*inx

systemctl restart nginx

syst*mctl enable nginx
```

## Logs

``*bash
journalctl -u nginx
```

---
*# 📌 Phase 9: Shell Scripting

Aut*mate repetitive work.

## Example *cript

```bash
#!/bin/bash

disk=$*df -h / | awk 'NR==2 {print $5}')
*echo "Disk Usage: $disk"
```

## L*arn

- Variables
- Conditions
- Lo*ps
- Functions
- Arrays
- Exit Cod*s

---

# 📌 Phase 10: Production *roubleshooting

## Application Dow*

```bash
systemctl status app
```*
## High CPU

```bash
top
```

## *isk Full

```bash
df -h
```

## Me*ory Issue

```bash
free -h
```

##*Service Failure

```bash
journalct* -xe
```

## Port Problem

```bash*ss -tulnp
```

---

# 📌 Phase 11:*Linux + Cloud

## SSH

```bash
ssh*ubuntu@SERVER_IP
```

## AWS Secur*ty Groups

| Port | Service |
|---*----|---------|
| 22 | SSH |
| 80 * HTTP |
| 443 | HTTPS |

---

# 📌*Docker Essentials

## Commands

``*bash
docker pull nginx

docker run*-d -p 80:80 nginx

docker ps

dock*r images

docker logs CONTAINER_ID*
docker exec -it CONTAINER_ID bash*
docker stop CONTAINER_ID
```

---*
# 📌 Daily Practice Plan

## 15 M*nutes

Linux Commands

```bash
fin*
grep
awk
sed
```

## 15 Minutes

*ystem Monitoring

```bash
top
free*-h
df -h
```

## 15 Minutes

Netwo*king

```bash
curl
ssh
ping
ss
```*
## 15 Minutes

Docker

```bash
do*ker run
docker logs
docker exec*```

---

# 📚 Learning Projects

*# Beginner

✅ Create users and gro*ps

✅ Configure SSH

✅ Write shell*scripts

✅ Host a simple website o* Nginx

---

## Intermediate

✅ De*loy Docker containers

✅ Create cu*tom systemd services

✅ Automate b*ckups

✅ Analyze logs

---

## Adv*nced

✅ Kubernetes

✅ Ansible

✅ T*rraform

✅ Linux Security

✅ Prome*heus

✅ Grafana

✅ Observability

* Performance Tuning

---

# 🎯 30-*ay Learning Goal

Focus on:

1. Li*ux Commands
2. Permissions
3. Proc*sses
4. Logs
5. Systemd
6. Network*ng
7. Docker

Mastering these topi*s will help you solve approximatel* **80% of real-world Linux product*on issues**.

---

# 💡 Final Advi*e

When learning Linux:

✅ Use Lin*x every day

✅ Break things and fi* them

✅ Read logs first

✅ Automa*e repetitive work

✅ Learn*troubleshooting, not just commands*
✅ Practice on AWS EC2 instances

* Document everything in GitHub

> *The best Linux administrators are *ot the ones who memorize commands;*they are the ones who*know where to look when*things*break."

Happy Learning! 🚀