# The Pantheon

The LilithSec daemons each depend on none of the others to run, but they were
designed as one household. This page is the map of how they interlink — the one
piece of documentation that belongs to no single repo.

## The cast, in one line each

| Daemon | In the world above |
|---|---|
| **[Lilith](https://github.com/LilithSec/Lilith)** | Ingests sensor alerts into PostgreSQL; search CLI + web frontend; auto-escalation |
| **[Lilu](https://github.com/LilithSec/App-Lilu)** | Ingest-only Lilith for sensor boxes; writes Lilith's tables |
| **[Baphomet](https://github.com/VVelox/Baphomet)** | Log watcher (fail2ban family); counts offenses; sends ban requests |
| **[Ereshkigal](https://github.com/LilithSec/Ereshkigal)** | Receives ban requests and firewalls the condemned |
| **[Lamashtu](https://github.com/LilithSec/Lamashtu)** | Packet-capture manager; hoards rotating pcaps (full packet capture) |
| **[Virani](https://github.com/LilithSec/Virani)** | PCAP retrieval; serves the flow behind an alert out of Lamashtu's hoard |
| **[Nisaba](https://github.com/VVelox/Plugtools)** | LDAP user/group/netgroup manager; the household's identity and trust store |
| **[Allani](https://github.com/LilithSec/Allani)** | Syslog store (Logstash + Elasticsearch replacement); lays every log line to rest in PostgreSQL |

## How the work flows

Three threads run through the household — knowing, packets, and enforcement —
with Nisaba's identity store underneath them all and Allani's log store, the
dark earth, receiving everything that falls.

```mermaid
flowchart TB
  sensors["Suricata / Sagan<br/>CAPEv2 sandbox"]
  wire(["network traffic"])
  logs["log files"]
  syslog(["host &amp; daemon logs<br/>syslog-ng · JSON"])

  subgraph know["Knowing — the annals"]
    direction LR
    Lilu["Lilu"]
    Lilith["Lilith"]
    Allani["Allani"]
    DB[("PostgreSQL")]
    Lilu --> DB
    Lilith --> DB
    Allani --> DB
  end

  subgraph pkt["Packets — capture &amp; retrieval"]
    direction LR
    Lamashtu["Lamashtu"]
    Virani["Virani"]
    PCAP[("pcap hoard")]
    Lamashtu --> PCAP
    Virani --> PCAP
  end

  subgraph enf["Enforcement"]
    direction LR
    Baphomet["Baphomet"]
    Ereshkigal["Ereshkigal"]
    FW["firewall"]
    Baphomet -->|ban request| Ereshkigal --> FW
  end

  Nisaba["Nisaba<br/>LDAP identity &amp; trust"]

  sensors -->|EVE + detonations| Lilith
  sensors -->|EVE| Lilu
  syslog -->|JSON via syslog-ng| Allani
  wire --> Lamashtu
  logs --> Baphomet
  Lilith -.->|fetch flow behind an alert| Virani

  Nisaba -.-> Lilith
  Nisaba -.-> Baphomet
  Nisaba -.-> Ereshkigal

  classDef daemon fill:#3b2a52,stroke:#b98fe0,stroke-width:1px,color:#f4f4f4;
  classDef store fill:#1f2d3d,stroke:#6fb1d6,color:#eaeaea;
  class Lilu,Lilith,Allani,Lamashtu,Virani,Baphomet,Ereshkigal,Nisaba daemon;
  class DB,PCAP store;
```

## The three threads

**Detection → the annals.** [Suricata](https://suricata.io/) and
[Sagan](https://github.com/quadrantsec/sagan) raise the cries; the sandbox
([CAPEv2](https://github.com/kevoreilly/CAPEv2)) adds detonation reports.
[Lilith](https://github.com/LilithSec/Lilith) gathers all of it into PostgreSQL
and consults it. On sensor boxes that hold no court of their own,
[Lilu](https://github.com/LilithSec/App-Lilu) does just the carrying — writing
the *same* tables into a Lilith database with a far smaller dependency chain —
while a central Lilith does the searching and escalating over everything the
sensors brought in.

**An alert → its packets.** [Lamashtu](https://github.com/LilithSec/Lamashtu)
hoards a copy of everything crossing the wire. When you want the packets
*behind* a particular alert, [Lilith](https://github.com/LilithSec/Lilith) sends
[Virani](https://github.com/LilithSec/Virani) — Virani reads the window out of
Lamashtu's hoard and hands back the flow. Lamashtu remembers; Virani reads what
she kept.

**A log line → a ban.** [Baphomet](https://github.com/VVelox/Baphomet) watches
logs the way fail2ban does, counts each IP's offenses, and when one crosses the
line sends a ban request to
[Ereshkigal](https://github.com/LilithSec/Ereshkigal), who does the actual
firewalling. Baphomet accuses; Ereshkigal punishes.

**Underneath all of it,** [Nisaba](https://github.com/VVelox/Plugtools) keeps
the rolls — the LDAP `posixAccount`, `posixGroup`, and `nisNetgroup` entries and
the trust marks (passwords, SSH keys, TOTP, passkeys) that the household
authenticates against. Before anything is judged, granted, or taken away,
someone must keep the record of who exists and what house they belong to. That
is Nisaba's work.

**Every log line → the dark earth.** Where Lilith keeps only the noteworthy
dead — the alerts whose deaths looked suspicious — everything that happens above
eventually dies and becomes a log line, and every log line descends to
[Allani](https://github.com/LilithSec/Allani), Lady of the Dark Earth and kin to
Ereshkigal. In place of the Logstash + Elasticsearch pattern, she is a syslog
store: [syslog-ng](https://www.syslog-ng.com/) delivers each message to her gate
as JSON, and she lays it to rest in PostgreSQL — the interesting fields as
columns, the whole record as `jsonb` beside them — in the same earth where
Lilith's annals already lie. Lilith knows what was suspicious; Lamashtu keeps
what crossed the wire; Allani keeps what the daemons said, all of it.
