# Virani

Virani is the reader of the [LilithSec](../pantheon.md) pantheon.
[Lamashtu](https://github.com/LilithSec/Lamashtu) remembers — she hoards a copy
of everything that crosses the wire — and Virani reads what she kept: given a
time window and a filter, Virani serves back the flow PCAP behind an alert.

In the world above, Virani is **PCAP retrieval for a full-packet-capture setup**
writing to pcap files (for example, via `daemonlogger`). It runs as an HTTP
service (`mojo-virani`) that [Lilith](https://github.com/LilithSec/Lilith) calls when you ask to see the
packets behind an event.

!!! note "Interim documentation"
    Virani does not yet ship a `docs/` directory upstream, so this section is
    maintained here in the aggregator. Once
    [LilithSec/Virani](https://github.com/LilithSec/Virani) grows a `docs/`
    directory in the house style (`index`, `install`, `configuration`, `usage`,
    `architecture`), replace this page with an `!import` line in `mkdocs.yml`
    like the other components, and delete `docs/Virani/`.

## Concepts

- **Sets** — named capture sources. Each set has a `path` to the pcap files, a
  `regex` that recognizes and timestamps them, and a `strptime` for parsing that
  timestamp.
- **Allowed subnets** — Virani only answers requests from `allowed_subnets`.

## A minimal config

```toml
default_set = 'default'
allowed_subnets = ["192.168.14.0/23", "127.0.0.1/8"]

[sets.default]
path = '/var/log/daemonlogger'
regex = '(?<timestamp>\d\d\d\d\d\d+)(\.pcap|(?<subsec>\.\d+)\.pcap)$'
strptime = '%s'
```

With `daemonlogger` enabled (FreeBSD example):

```sh
daemonlogger_enable="YES"
daemonlogger_flags="-f /usr/local/etc/daemonlogger.bpf -d -l /var/log/daemonlogger -t 120"
```

## Reference

Until the upstream docs land, the module POD is the reference:

```sh
perldoc Virani
perldoc mojo-virani
```
