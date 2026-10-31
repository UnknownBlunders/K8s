#!/usr/bin/env python3
"""Sync Cloudflare's published IP ranges into the router firewall address lists.

Fetches https://www.cloudflare.com/ips-v4 and /ips-v6, compares them with the
`cloudflare` address lists in the firewall Terraform, and rewrites the lists in
place if they differ. A markdown summary of the changes is written to the path
given by --summary so it can be used as a PR body.
"""

import argparse
import ipaddress
import re
import sys
import urllib.request

SOURCES = {
    "ipv4": ("https://www.cloudflare.com/ips-v4", "Cloudflare's ipv4 ranges"),
    "ipv6": ("https://www.cloudflare.com/ips-v6", "Cloudflare's ipv6 ranges"),
}


def fetch_ranges(url, version):
    req = urllib.request.Request(url, headers={"User-Agent": "cloudflare-ip-sync"})
    with urllib.request.urlopen(req, timeout=30) as resp:
        body = resp.read().decode()

    ranges = [line.strip() for line in body.splitlines() if line.strip()]
    if not ranges:
        sys.exit(f"Refusing to continue: {url} returned no ranges")

    for cidr in ranges:
        net = ipaddress.ip_network(cidr, strict=True)  # raises on garbage
        if net.version != (4 if version == "ipv4" else 6):
            sys.exit(f"Refusing to continue: {cidr} from {url} is not {version}")
    return ranges


def block_pattern(comment):
    return re.compile(
        r'(comment\s*=\s*"' + re.escape(comment) + r'"\s*\n\s*addresses\s*=\s*\[\n)'
        r"(.*?)"
        r"(\s*\n([ \t]*)\])",
        re.DOTALL,
    )


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("file", help="Terraform file containing the address lists")
    parser.add_argument("--summary", required=True, help="Where to write the markdown summary")
    args = parser.parse_args()

    with open(args.file) as f:
        content = f.read()

    summary = []
    changed = False

    for version, (url, comment) in SOURCES.items():
        pattern = block_pattern(comment)
        match = pattern.search(content)
        if not match:
            sys.exit(f'Could not find the address list with comment "{comment}" in {args.file}')

        current = re.findall(r'"([^"]+)"', match.group(2))
        latest = fetch_ranges(url, version)

        added = [r for r in latest if r not in current]
        removed = [r for r in current if r not in latest]
        if not added and not removed:
            print(f"{version}: up to date ({len(current)} ranges)")
            continue

        changed = True
        print(f"{version}: +{len(added)} / -{len(removed)}")
        summary.append(f"### {version}\n")
        summary += [f"- Added `{r}`" for r in added]
        summary += [f"- Removed `{r}`" for r in removed]
        summary.append("")

        closing_indent = match.group(4)
        entry_indent = closing_indent + "  "
        new_entries = "\n".join(f'{entry_indent}"{r}",' for r in latest)
        content = (
            content[: match.start(2)]
            + new_entries
            + f"\n{closing_indent}]"
            + content[match.end(3) :]
        )

    if changed:
        with open(args.file, "w") as f:
            f.write(content)

    with open(args.summary, "w") as f:
        f.write("\n".join(summary))


if __name__ == "__main__":
    main()
