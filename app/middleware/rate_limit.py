from __future__ import annotations

import threading
import time


class FixedWindowRateLimiter:
    def __init__(self) -> None:
        self._lock = threading.Lock()
        self._buckets: dict[str, tuple[int, int]] = {}

    def hit_with_retry(self, key: str, limit: int, window_seconds: int = 60) -> tuple[bool, int]:
        now = int(time.time())
        window_start = now - (now % window_seconds)
        retry_after = max(1, (window_start + window_seconds) - now)
        with self._lock:
            start, count = self._buckets.get(key, (window_start, 0))
            if start != window_start:
                start, count = window_start, 0
                retry_after = window_seconds
            if count >= limit:
                return False, retry_after
            self._buckets[key] = (start, count + 1)
            return True, 0

    def hit(self, key: str, limit: int, window_seconds: int = 60) -> bool:
        allowed, _ = self.hit_with_retry(key, limit=limit, window_seconds=window_seconds)
        return allowed
