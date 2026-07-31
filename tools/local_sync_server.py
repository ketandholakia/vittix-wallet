#!/usr/bin/env python3
import argparse
import json
import os
from http.server import BaseHTTPRequestHandler, ThreadingHTTPServer
from pathlib import Path
from urllib.parse import urlparse


SYNC_API_VERSION = 1
DEFAULT_STATE = {
    "accounts": [],
    "categories": [],
    "transactions": [],
    "budgets": [],
    "recurring_transactions": [],
    "loans": [],
    "peer_debts": [],
    "wallets": [],
    "wallet_members": [],
    "wallet_invitations": [],
    "wallet_activities": [],
    "wallet_notifications": [],
    "wallet_notification_preferences": [],
    "wallet_goals": [],
    "wallet_goal_contributions": [],
    "wallet_allowances": [],
    "wallet_allowance_payments": [],
    "wallet_goal_schedules": [],
    "wallet_bills": [],
    "wallet_expense_splits": [],
    "wallet_settlements": [],
    "deletions": [],
}


def _parse_ms(value):
    if value is None:
        return 0
    if isinstance(value, (int, float)):
        return int(value)
    if isinstance(value, str):
        try:
            return int(value)
        except ValueError:
            return 0
    return 0


def _load_state(path: Path):
    if not path.exists():
        return dict(DEFAULT_STATE)
    with path.open("r", encoding="utf-8") as fh:
        data = json.load(fh)
    state = dict(DEFAULT_STATE)
    state.update({k: v for k, v in data.items() if k in state})
    return state


def _save_state(path: Path, state):
    path.parent.mkdir(parents=True, exist_ok=True)
    with path.open("w", encoding="utf-8") as fh:
        json.dump(state, fh, ensure_ascii=True, indent=2)


class SyncHandler(BaseHTTPRequestHandler):
    server_version = "LocalSyncServer/1.0"

    def _send_json(self, code, payload):
        data = json.dumps(payload).encode("utf-8")
        self.send_response(code)
        self.send_header("Content-Type", "application/json")
        self.send_header("Content-Length", str(len(data)))
        self.end_headers()
        self.wfile.write(data)

    def do_GET(self):
        if urlparse(self.path).path == "/sync/health":
            self._send_json(200, {"ok": True, "syncApiVersion": SYNC_API_VERSION})
            return
        self._send_json(404, {"error": "not found"})

    def do_POST(self):
        if urlparse(self.path).path != "/sync":
            self._send_json(404, {"error": "not found"})
            return

        length = int(self.headers.get("Content-Length", "0"))
        body = self.rfile.read(length).decode("utf-8")
        try:
            payload = json.loads(body)
        except json.JSONDecodeError as exc:
            self._send_json(400, {"error": f"invalid json: {exc}"})
            return

        sync_version = int(payload.get("syncApiVersion", 0))
        if sync_version != SYNC_API_VERSION:
            self._send_json(400, {"error": f"unsupported syncApiVersion {sync_version}"})
            return

        wallet_id = payload.get("walletId")
        if wallet_id is None:
            self._send_json(400, {"error": "walletId is required"})
            return

        state = _load_state(self.server.state_file)
        changes = payload.get("changes", {})
        deletions = payload.get("deletions", [])

        for deletion in deletions:
            uuid = deletion.get("uuid")
            table = deletion.get("tableName")
            if not uuid or table not in state:
                continue
            state[table] = [row for row in state[table] if row.get("uuid") != uuid]
            if not any(item.get("uuid") == uuid for item in state["deletions"]):
                state["deletions"].append(deletion)

        for table, rows in changes.items():
            if table not in state:
                continue
            if not isinstance(rows, list):
                continue
            for row in rows:
                if not isinstance(row, dict):
                    continue
                identity = row.get("uuid", row.get("id"))
                if identity is None:
                    continue
                updated_at = _parse_ms(row.get("updatedAt"))
                existing_index = next(
                    (
                        i
                        for i, item in enumerate(state[table])
                        if item.get("uuid") == identity or item.get("id") == identity
                    ),
                    -1,
                )
                if existing_index == -1:
                    state[table].append(row)
                else:
                    existing = state[table][existing_index]
                    if updated_at >= _parse_ms(existing.get("updatedAt")):
                        state[table][existing_index] = row

        _save_state(self.server.state_file, state)
        now = 0
        self._send_json(
            200,
            {
                "syncApiVersion": SYNC_API_VERSION,
                "serverTime": now,
                "changes": {table: [] for table in state.keys() if table != "deletions"},
                "deletions": [],
                "conflicts": [],
                "warnings": [],
            },
        )

    def log_message(self, fmt, *args):
        if self.server.verbose:
            super().log_message(fmt, *args)


def main():
    parser = argparse.ArgumentParser(description="Local LAN sync server for Vittix Expense Tracker")
    parser.add_argument("--host", default="0.0.0.0")
    parser.add_argument("--port", type=int, default=8080)
    parser.add_argument("--state-file", default="local_sync_state.json")
    parser.add_argument("--verbose", action="store_true")
    args = parser.parse_args()

    server = ThreadingHTTPServer((args.host, args.port), SyncHandler)
    server.state_file = Path(args.state_file)
    server.verbose = args.verbose
    print(f"Local sync server listening on http://{args.host}:{args.port}")
    print(f"Health: http://{args.host}:{args.port}/sync/health")
    try:
        server.serve_forever()
    except KeyboardInterrupt:
        pass


if __name__ == "__main__":
    main()
