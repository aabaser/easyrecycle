from __future__ import annotations

import threading
import time


class FixedWindowRateLimiter:
    def __init__(self) -> None:
        self._lock = threading.Lock()
        self._buckets: dict[str, tuple[int, int]] = {}

    def hit(self, key: str, limit: int, window_seconds: int = 60) -> bool:
        now = int(time.time())
        window_start = now - (now % window_seconds)
        with self._lock:
            start, count = self._buckets.get(key, (window_start, 0))
            if start != window_start:
                start, count = window_start, 0
            if count >= limit:
                return False
            self._buckets[key] = (start, count + 1)
            return True
