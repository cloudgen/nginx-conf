#!/usr/bin/env python3
"""Run argv under a PTY. Wait for MENU_WAIT, then feed MENU_INPUT."""
import os
import pty
import select
import signal
import sys
import time

raw = os.environ.get("MENU_INPUT", "99\n")
if not raw.endswith("\n"):
    raw += "\n"
typed_lines = [ln if ln.endswith("\n") else ln + "\n" for ln in raw.splitlines(True)]
wait_for = os.environ.get("MENU_WAIT", "Choice").encode()
if len(sys.argv) < 2:
    sys.stderr.write("usage: pty_feed.py CMD [ARGS...]\n")
    sys.exit(2)

pid, fd = pty.fork()
if pid == 0:
    os.execvp(sys.argv[1], sys.argv[1:])

chunks = []
feed_i = 0
seen_prompts = 0
deadline = time.time() + 8.0
try:
    while True:
        remaining = deadline - time.time()
        if remaining <= 0:
            break
        ready, _, _ = select.select([fd], [], [], min(0.4, max(remaining, 0.05)))
        if not ready:
            if feed_i >= len(typed_lines) and chunks:
                # allow one more read cycle then stop if child quiet
                try:
                    wpid, _status = os.waitpid(pid, os.WNOHANG)
                except ChildProcessError:
                    wpid = pid
                if wpid == pid:
                    break
            continue
        try:
            data = os.read(fd, 4096)
        except OSError:
            break
        if not data:
            break
        chunks.append(data)
        blob = b"".join(chunks)
        prompts = blob.count(wait_for)
        while feed_i < len(typed_lines) and prompts > seen_prompts:
            try:
                os.write(fd, typed_lines[feed_i].encode())
            except OSError:
                break
            feed_i += 1
            seen_prompts += 1
finally:
    try:
        os.close(fd)
    except OSError:
        pass
    for sig in (signal.SIGTERM, signal.SIGKILL):
        try:
            os.kill(pid, sig)
        except OSError:
            break
        for _ in range(20):
            try:
                wpid, _status = os.waitpid(pid, os.WNOHANG)
            except ChildProcessError:
                wpid = pid
            if wpid == pid:
                break
            time.sleep(0.05)
        else:
            continue
        break

sys.stdout.buffer.write(b"".join(chunks))
