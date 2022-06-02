# docker-bug-test
A simple test of some odd behavior exhibited by Docker / Docker compose paired with git checkout and volumes.

## Issue: 
When using `git checkout -- <file>` the file on the inside of the container loses its hardlink, breaking things unexpectedly.
 - This is most prominent when working with a configuration that is passed in, like Drupal's `composer.json` which may need to be refreshed from a repository.
 - Interestingly, in the original repository I was testing this in moving the file does *not* make it lose its link when moved back, while with this test script it does.
 - Running `git checkout -- <file>` from a shell outside the container inside a folder that is passed through into the container does not produce this behavior.
 - A workaround to fix the link is to restart the container with `docker compose restart` or similar.
 - This seems to be related to, but not the same as [this issue in moby's repository](https://github.com/docker/for-win/issues/5530).

## Question:
Is there a more elegant way to refresh the hardlink without restarting the container?

### Usage: 
`git clone` this repository.
Run `test.sh`

This was first noticed on a M1 Mac with Docker Desktop, and I replicated it on my Fedora 36 workstation.

Output of my Docker info:
```
Client:
 Context:    default
 Debug Mode: false
 Plugins:
  app: Docker App (Docker Inc., v0.9.1-beta3)
  buildx: Docker Buildx (Docker Inc., v0.8.2-docker)
  compose: Docker Compose (Docker Inc., v2.5.0)
  sbom: View the packaged-based Software Bill Of Materials (SBOM) for an image (Anchore Inc., 0.6.0)
  scan: Docker Scan (Docker Inc., v0.17.0)

Server:
 Containers: 0
  Running: 0
  Paused: 0
  Stopped: 0
 Images: 3
 Server Version: 20.10.16
 Storage Driver: btrfs
  Build Version: Btrfs v5.16.2
  Library Version: 102
 Logging Driver: json-file
 Cgroup Driver: systemd
 Cgroup Version: 2
 Plugins:
  Volume: local
  Network: bridge host ipvlan macvlan null overlay
  Log: awslogs fluentd gcplogs gelf journald json-file local logentries splunk syslog
 Swarm: inactive
 Runtimes: io.containerd.runc.v2 io.containerd.runtime.v1.linux runc
 Default Runtime: runc
 Init Binary: docker-init
 containerd version: 212e8b6fa2f44b9c21b2798135fc6fb7c53efc16
 runc version: v1.1.1-0-g52de29d
 init version: de40ad0
 Security Options:
  seccomp
   Profile: default
  cgroupns
 Kernel Version: 5.17.9-300.fc36.x86_64
 Operating System: Fedora Linux 36 (Workstation Edition)
 OSType: linux
 Architecture: x86_64
 CPUs: 16
 Total Memory: 14.54GiB
 Name: <redacted>
 ID: <redacted>
 Docker Root Dir: /var/lib/docker
 Debug Mode: false
 Registry: https://index.docker.io/v1/
 Labels:
 Experimental: false
 Insecure Registries:
  127.0.0.0/8
 Live Restore Enabled: false

```
