"""Exercise the real server entry point and a one-frame animation request."""
import os
from pathlib import Path
import signal
import socket
import subprocess
import tempfile
import time
import urllib.error
import urllib.request

root = Path(__file__).resolve().parents[1]
with socket.socket() as probe:
    probe.bind(("127.0.0.1", int(os.environ.get("ELASTIC_TEST_PORT", "0"))))
    port = probe.getsockname()[1]
base = f"http://127.0.0.1:{port}"
opener = urllib.request.build_opener(urllib.request.ProxyHandler({}))
with tempfile.TemporaryDirectory() as work, tempfile.TemporaryFile(mode="w+") as log:
    env = dict(os.environ, PORT=str(port), GENIE_HOST="127.0.0.1", GKSwstype="100")
    # Deliberately start outside the app directory to check path handling.
    process = subprocess.Popen([str(root / "bin/server")], cwd=work, env=env,
                               stdout=log, stderr=subprocess.STDOUT,
                               start_new_session=True)
    try:
        deadline = time.monotonic() + 600
        while True:
            if process.poll() is not None:
                raise RuntimeError(f"Server exited early: {process.returncode}")
            try:
                with opener.open(base + "/robots.txt", timeout=2) as response:
                    if response.status == 200:
                        break
            except (urllib.error.URLError, TimeoutError):
                pass
            if time.monotonic() >= deadline:
                raise TimeoutError("Server did not become ready within 600 seconds")
            time.sleep(1)
        with opener.open(base + "/?maxT=1&num_particles=1", timeout=180) as response:
            body = response.read().decode()
            assert response.status == 200
            assert "Elastic Collision" in body, body[:500]
            assert "data:image/gif;base64," in body, body[:500]
        print("Server startup and one-frame GIF HTTP smoke test passed")
    finally:
        os.killpg(process.pid, signal.SIGTERM) if process.poll() is None else None
        try:
            process.wait(timeout=10)
        except subprocess.TimeoutExpired:
            os.killpg(process.pid, signal.SIGKILL)
            process.wait()
        log.seek(0)
        print(log.read())
