# LilithSec

The LilithSec household is a family of security daemons, each named for a
figure out of Mesopotamian myth, each doing one part of the work of watching a
network and acting on what it sees. They run apart but were built to run
together.

- **[Lilith](https://github.com/LilithSec/Lilith)** — the matriarch and alert
  keeper. Follows the EVE logs of the sensors and detonation reports from the
  sandbox, writes every alert into her annals (PostgreSQL), and lets you search,
  examine, and escalate.
- **[Lilu](https://github.com/LilithSec/App-Lilu)** — her lesser kinsman. A
  cut-down, ingest-only Lilith for sensor boxes: carries alerts into her book,
  nothing more.
- **[Baphomet](https://github.com/VVelox/Baphomet)** — the accuser. A log
  watcher in the fail2ban family that counts the offenses of each IP and sends
  ban requests below.
- **[Ereshkigal](https://github.com/LilithSec/Ereshkigal)** — the punisher.
  Receives ban requests and does the actual firewalling.
- **[Lamashtu](https://github.com/LilithSec/Lamashtu)** — she remembers. A
  packet-capture manager that hoards everything crossing the wire in rotating
  pcaps.
- **[Virani](https://github.com/LilithSec/Virani)** — she reads. PCAP retrieval:
  given a window and a filter, serves the flow behind an alert out of what
  Lamashtu kept.
- **[Nisaba](https://github.com/VVelox/Plugtools)** — the scribe. LDAP user,
  group, and netgroup manager; the record keeper of who exists and what marks of
  trust they carry.

New here? Start with **[The Pantheon](pantheon.md)** for how they fit together,
then dive into whichever daemon you need.
