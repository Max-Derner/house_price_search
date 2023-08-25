from datetime import datetime, timezone

ARTEFACTS_DIR = 'python_logs'
ARCHIVE_DIR = 'archived_python_logs'


def utc_now() -> datetime:
    return datetime.now(timezone.utc)
