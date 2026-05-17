#!/usr/bin/env python3

"""
CLI controller that sends IPC commands to wallpaper-daemon via socket.

Usage:
  wallpaper next
  wallpaper pause
  wallpaper resume
  wallpaper set /path/to/image.jpg
  wallpaper reload
  wallpaper status
"""

from __future__ import annotations

import json
import os
import socket
import sys
from pathlib import Path
from typing import Any

SOCKET_PATH = Path(os.environ.get("XDG_RUNTIME_DIR", "/tmp")) / "wallpaper.sock"


def send_command(cmd: dict[str, Any]) -> dict[str, Any]:
    if not SOCKET_PATH.exists():
        print("error: wallpaper-daemon is not running", file=sys.stderr)
        sys.exit(1)

    with socket.socket(socket.AF_UNIX, socket.SOCK_STREAM) as s:
        s.connect(str(SOCKET_PATH))
        s.sendall(json.dumps(cmd).encode() + b"\n")
        raw = b""
        while not raw.endswith(b"\n"):
            chunk = s.recv(4096)
            if not chunk:
                break
            raw += chunk
        return json.loads(raw)


def _print_status(reply: dict[str, Any]) -> None:
    current = Path(reply["current"]).name if reply.get("current") else "none"
    paused = "paused" if reply.get("paused") else "running"
    mins, secs = divmod(int(reply.get("remaining", 0)), 60)
    print(
        f"  current : {current}\n"
        f"  state   : {paused}\n"
        f"  index   : {reply.get('index', '?')} / {reply.get('total', '?')}\n"
        f"  next in : {mins:02d}:{secs:02d}  (interval {reply.get('interval', '?')}s)"
    )


def main() -> None:
    import argparse

    parser = argparse.ArgumentParser(
        description="control wallpaper-daemon",
        formatter_class=argparse.RawDescriptionHelpFormatter,
    )
    sub = parser.add_subparsers(dest="action", required=True)

    sub.add_parser("next", help="next wallpaper")
    sub.add_parser("pause", help="pause auto-rotation")
    sub.add_parser("resume", help="resume auto-rotation")
    sub.add_parser("reload", help="rescan wallpaper directory")
    sub.add_parser("status", help="print current status")

    p_set = sub.add_parser("set", help="set a specific wallpaper")
    p_set.add_argument("path", type=str, help="path to image")

    args = parser.parse_args()
    cmd: dict[str, Any] = {"action": args.action}
    if args.action == "set":
        cmd["path"] = args.path

    reply = send_command(cmd)

    if not reply.get("ok"):
        print(f"error: {reply.get('error', 'unknown')}", file=sys.stderr)
        sys.exit(1)

    match args.action:
        case "status":
            _print_status(reply)
        case "reload":
            print(f"reloaded — {reply['count']} wallpapers found")
        case "set" | "next":
            print(Path(reply["current"]).name)
        case "pause":
            print("paused")
        case "resume":
            print("resumed")


if __name__ == "__main__":
    main()
