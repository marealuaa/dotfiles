pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root

    property string device:  ""
    property string cpu:     ""
    property string gpu:     ""
    property string user:    ""
    property string pkgs:    "..."
    property string uptime:  "..."
    property real   cpuLoad: 0.0
    property real   ramLoad: 0.0
    property var    disks:   []

    // ── One-shot static info ──────────────────────────────────────────────

    Process {
        command: ["bash", "-c", "hostnamectl 2>/dev/null | grep 'Hardware Model' | awk -F ': ' '{print $2}'"]
        running: true
        stdout: StdioCollector { onStreamFinished: root.device = this.text.trim() || "Unknown Device" }
    }
    Process {
        command: ["bash", "-c",
            "lscpu | grep 'Model name' | head -1 | awk -F': ' '{print $2}'" +
            " | sed -E 's/\\(R\\)|\\(TM\\)|\\(\\)| CPU//g' | sed 's/^[[:space:]]*//'"]
        running: true
        stdout: StdioCollector { onStreamFinished: root.cpu = this.text.trim() }
    }
    Process {
        command: ["bash", "-c",
            "lspci 2>/dev/null | grep -Ei 'vga|3d|display' | head -1" +
            " | awk -F': ' '{print $2}' | sed -E 's/\\(.*\\)//' | sed 's/[[:space:]]*$//'"]
        running: true
        stdout: StdioCollector { onStreamFinished: root.gpu = this.text.trim() }
    }
    Process {
        command: ["whoami"]
        running: true
        stdout: StdioCollector { onStreamFinished: root.user = this.text.trim() }
    }

    // ── Package count (NixOS) ─────────────────────────────────────────────

    Process {
        id: pkgsProc
        command: ["bash", "-c", "nix-store -q --requisites /run/current-system 2>/dev/null | wc -l"]
        running: true
        stdout: StdioCollector { onStreamFinished: root.pkgs = this.text.trim() }
    }
    Timer { interval: Theme.pkgPoll; running: true; repeat: true; onTriggered: pkgsProc.running = true }

    // ── Uptime ────────────────────────────────────────────────────────────

    Process {
        id: uptimeProc
        command: ["bash", "-c", "uptime -p | sed 's/^up //' | cut -d',' -f1-2"]
        running: true
        stdout: StdioCollector { onStreamFinished: root.uptime = this.text.trim() }
    }
    Timer { interval: Theme.uptimePoll; running: true; repeat: true; onTriggered: uptimeProc.running = true }

    // ── CPU load (via /proc/stat — fast, no blocking) ─────────────────────

    // We read /proc/stat twice 500ms apart and compute the delta
    property var _cpuPrev: null

    Process {
        id: cpuProc
        command: ["bash", "-c", "awk '/^cpu /{print $2,$3,$4,$5,$6,$7,$8}' /proc/stat"]
        running: true
        stdout: StdioCollector {
            onStreamFinished: {
                var parts = this.text.trim().split(" ").map(Number)
                if (parts.length < 7) return
                var idle  = parts[3] + parts[4]   // idle + iowait
                var total = parts.reduce(function(a, b) { return a + b }, 0)
                if (root._cpuPrev !== null) {
                    var dTotal = total - root._cpuPrev.total
                    var dIdle  = idle  - root._cpuPrev.idle
                    root.cpuLoad = dTotal > 0 ? Math.max(0, (dTotal - dIdle) / dTotal) : 0
                }
                root._cpuPrev = { total: total, idle: idle }
            }
        }
    }
    Timer { interval: Theme.cpuPoll; running: true; repeat: true; onTriggered: cpuProc.running = true }

    // ── RAM load ──────────────────────────────────────────────────────────

    Process {
        id: ramProc
        command: ["bash", "-c", "free | awk '/^Mem:/{printf \"%.4f\", $3/$2}'"]
        running: true
        stdout: StdioCollector { onStreamFinished: root.ramLoad = parseFloat(this.text.trim()) || 0 }
    }
    Timer { interval: Theme.ramPoll; running: true; repeat: true; onTriggered: ramProc.running = true }

    // ── Disk usage ────────────────────────────────────────────────────────

    Process {
        id: diskProc
        command: ["bash", "-c", "df -h | awk 'NR>1 && $1~/^\\// {print $1\"|\"$2\"|\"$3\"|\"$5}'"]
        running: true
        stdout: StdioCollector {
            onStreamFinished: {
                var lines = this.text.trim().split("\n").filter(function(l) { return l.length > 0 })
                root.disks = lines.map(function(l) {
                    var p = l.split("|")
                    return p.length === 4
                        ? { partition: p[0], size: p[1], used: p[2], usedPct: parseFloat(p[3]) / 100 }
                        : null
                }).filter(Boolean)
            }
        }
    }
    Timer { interval: Theme.diskPoll; running: true; repeat: true; onTriggered: diskProc.running = true }
}
