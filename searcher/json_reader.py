import json
import os
from typing import List, Any
from searcher.logger import log

PATHS_TO_IGNORE = [
    '.git',
    '.vscode',
    'archived_python_logs',
    'searcher_venv',
    'tests',
]


def list_json_files(parent_directory: str = ".") -> List[str]:
    log.debug(f"ignoring: {PATHS_TO_IGNORE}")
    paths = os.walk(parent_directory)
    all_json_file_paths: List[str] = []
    all_inspected_paths: List[str] = []
    for directory_path, directories, files in paths:
        inspect_this_path = True
        for path_to_ignore in PATHS_TO_IGNORE:
            if f"/{path_to_ignore}/" in directory_path or directory_path.endswith(f"/{path_to_ignore}"):
                inspect_this_path = False
                log.info(f"ignoring {directory_path}")
                break
        if inspect_this_path:
            all_inspected_paths.append(directory_path)
            for file in files:
                if file.endswith('.json'):
                    full_path = os.path.abspath(os.path.join(directory_path, file))
                    all_json_file_paths.append(full_path)
    log.debug(f"inspected: {all_inspected_paths}")
    return all_json_file_paths


def get_json_object(file_path: str) -> Any:
    with open(file_path, mode='r') as text_io:
        json_object = json.load(text_io)
    return json_object


if __name__ == "__main__":
    log.info(list_json_files())
