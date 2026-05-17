#!/usr/bin/env python3

"""
wallpaper-daemon  –  file1
--------------------------
Manages swww behind the curtains:
  • scans a wallpaper directory
  • rotates on a configurable timer
  • keeps XDG_RUNTIME_DIR/wallpaper symlink pointing at the current image
  • listens on XDG_RUNTIME_DIR/wallpaper.sock for JSON IPC commands
"""

from __future__ import annotations

import asyncio
from collections.abc import Callable, Awaitable
import json
import logging
import os
import random
import subprocess
import sys
from dataclasses import dataclass, field
from pathlib import Path
from typing import Any

_RUNTIME = Path(os.environ.get("XDG_RUNTIME_DIR", "/tmp"))
SOCKET_PATH = _RUNTIME / "wallpaper.sock"
SYMLINK_PATH = _RUNTIME / "wallpaper"  # → /path/to/current/image

IMAGE_EXTS = {".jpg", ".jpeg", ".png", ".webp", ".gif"}

log = logging.getLogger("wallpaper-daemon")


@dataclass
class Config:
    wallpaper_dir: Path = Path.home() / "Pictures" / "wallpapers"
    interval: float = 300.0
    shuffle: bool = True


@dataclass
class State:
    wallpapers: list[Path] = field(default_factory=list)
    index: int = 0
    paused: bool = False

    @property
    def current(self) -> Path | None:
        return self.wallpapers[self.index] if self.wallpapers else None


def _awww_set(path: Path) -> None:
    subprocess.Popen(
        [
            "awww",
            "img",
            "-a",
            "-t",
            "random",
            str(path),
        ],
        stdout=subprocess.DEVNULL,
        stderr=subprocess.DEVNULL,
    )


def _update_symlink(path: Path) -> None:
    if SYMLINK_PATH.is_symlink() or SYMLINK_PATH.exists():
        SYMLINK_PATH.unlink()
    SYMLINK_PATH.symlink_to(path)


def _load_wallpapers(cfg: Config) -> list[Path]:
    d = cfg.wallpaper_dir
    if not d.is_dir():
        log.warning("wallpaper_dir %s does not exist", d)
        return []
    files = [p for p in sorted(d.iterdir()) if p.suffix.lower() in IMAGE_EXTS]
    if cfg.shuffle:
        random.shuffle(files)
    return files


def _handle_command(
    cmd: dict[str, Any],
    state: State,
    cfg: Config,
    timer: _Timer,
) -> dict[str, Any]:
    match cmd.get("action"):
        case "next":
            state.index = random.randint(0, len(state.wallpapers))
            _apply_current(state)
            timer.reset()
            return {"ok": True, "current": str(state.current)}

        case "pause":
            state.paused = True
            timer.pause()
            return {"ok": True, "paused": True}

        case "resume":
            state.paused = False
            timer.resume()
            return {"ok": True, "paused": False}

        case "set":
            path = Path(cmd.get("path", ""))
            if not path.is_file():
                return {"ok": False, "error": "file not found"}
            state.wallpapers.insert(state.index + 1, path)
            state.index += 1
            _apply_current(state)
            timer.reset()
            return {"ok": True, "current": str(state.current)}

        case "reload":
            state.wallpapers = _load_wallpapers(cfg)
            state.index = 0
            _apply_current(state)
            return {"ok": True, "count": len(state.wallpapers)}

        case "status":
            return {
                "ok": True,
                "current": str(state.current),
                "index": state.index,
                "total": len(state.wallpapers),
                "paused": state.paused,
                "interval": cfg.interval,
                "remaining": timer.remaining(),
            }

        case _:
            return {"ok": False, "error": f"unknown action: {cmd.get('action')!r}"}


def _apply_current(state: State) -> None:
    if state.current:
        _awww_set(state.current)
        _update_symlink(state.current)
        log.info("wallpaper → %s", state.current.name)


class _Timer:
    """Async countdown that fires a callback; supports pause/resume/reset."""

    def __init__(
        self, interval: float, callback: Callable[[], Awaitable[None]]
    ) -> None:
        self._interval = interval
        self._callback = callback
        self._task: asyncio.Task | None = None
        self._paused = False
        self._elapsed = 0.0
        self._start = 0.0

    def start(self) -> None:
        self._task = asyncio.get_event_loop().create_task(self._run())

    def reset(self) -> None:
        if self._task:
            self._task.cancel()
        self._elapsed = 0.0
        self._task = asyncio.get_event_loop().create_task(self._run())

    def pause(self) -> None:
        self._paused = True
        self._elapsed += asyncio.get_event_loop().time() - self._start

    def resume(self) -> None:
        self._paused = False
        self._start = asyncio.get_event_loop().time()

    def remaining(self) -> float:
        if self._paused:
            return max(0.0, self._interval - self._elapsed)
        elapsed = self._elapsed + (asyncio.get_event_loop().time() - self._start)
        return max(0.0, self._interval - elapsed)

    async def _run(self) -> None:
        self._start = asyncio.get_event_loop().time()
        remaining = self._interval - self._elapsed
        try:
            while remaining > 0:
                if self._paused:
                    await asyncio.sleep(0.5)
                    continue
                await asyncio.sleep(min(remaining, 1.0))
                if not self._paused:
                    remaining = self.remaining()
            self._elapsed = 0.0
            await self._callback()
            self._task = asyncio.get_event_loop().create_task(self._run())
        except asyncio.CancelledError:
            pass


async def _serve(state: State, cfg: Config, timer: _Timer) -> None:
    if SOCKET_PATH.exists():
        SOCKET_PATH.unlink()

    async def _handle(
        reader: asyncio.StreamReader, writer: asyncio.StreamWriter
    ) -> None:
        try:
            raw = await reader.readline()
            cmd = json.loads(raw)
            reply = _handle_command(cmd, state, cfg, timer)
        except (json.JSONDecodeError, Exception) as exc:
            reply = {"ok": False, "error": str(exc)}
        writer.write(json.dumps(reply).encode() + b"\n")
        await writer.drain()
        writer.close()

    server = await asyncio.start_unix_server(_handle, path=str(SOCKET_PATH))
    log.info("listening on %s", SOCKET_PATH)
    async with server:
        await server.serve_forever()


def main() -> None:
    import argparse

    parser = argparse.ArgumentParser(description="wallpaper rotation daemon")
    parser.add_argument("--dir", type=Path, help="wallpaper directory")
    parser.add_argument("--interval", type=float, help="seconds between changes")
    parser.add_argument("--no-shuffle", action="store_true")
    parser.add_argument("--verbose", "-v", action="store_true")
    args = parser.parse_args()

    logging.basicConfig(
        level=logging.DEBUG if args.verbose else logging.INFO,
        format="%(name)s: %(message)s",
    )

    cfg = Config()
    if args.dir:
        cfg.wallpaper_dir = args.dir
    if args.interval:
        cfg.interval = args.interval
    if args.no_shuffle:
        cfg.shuffle = False

    state = State(wallpapers=_load_wallpapers(cfg))
    if not state.wallpapers:
        log.error("no wallpapers found in %s", cfg.wallpaper_dir)
        sys.exit(1)

    _apply_current(state)

    async def _on_tick() -> None:
        state.index = (state.index + 1) % len(state.wallpapers)
        _apply_current(state)

    async def _run() -> None:
        timer = _Timer(cfg.interval, _on_tick)
        timer.start()
        await _serve(state, cfg, timer)

    loop = asyncio.get_event_loop()

    def _shutdown(*_: Any) -> None:
        log.info("shutting down")
        if SOCKET_PATH.exists():
            SOCKET_PATH.unlink()
        loop.stop()

    loop.add_signal_handler(__import__("signal").SIGTERM, _shutdown)
    loop.add_signal_handler(__import__("signal").SIGINT, _shutdown)

    try:
        loop.run_until_complete(_run())
    finally:
        loop.close()


if __name__ == "__main__":
    main()
