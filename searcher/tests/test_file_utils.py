import os
import shutil
import pytest
from unittest.mock import patch, Mock
from searcher.file_utils import (
    create_directory_if_not_exist,
    ensure_directories_present,
    archive_artefacts
)
from searcher.shared import (
    ARTEFACTS_DIR,
    ARCHIVE_DIR
)
from datetime import datetime


CWD = os.getcwd()
TEST_DIR_ONE_PATH = 'searcher/tests/magical_mystery_directory'
TEST_DIR_ONE_PATH_ABSOLUTE = os.path.join(CWD, TEST_DIR_ONE_PATH)
TEST_DIR_TWO_PATH = 'searcher/tests/some_other_magical_mystery_directory'
TEST_DIR_TWO_PATH_ABSOLUTE = os.path.join(CWD, TEST_DIR_TWO_PATH)
TEST_DIRS = [TEST_DIR_ONE_PATH_ABSOLUTE, TEST_DIR_TWO_PATH_ABSOLUTE]


@pytest.fixture(autouse=True)
def tear_down():
    yield
    for test_dir in TEST_DIRS:
        if os.path.exists(test_dir):
            shutil.rmtree(path=test_dir)


def tests_create_directory_if_not_exist():
    # given
    cwd = os.path.abspath(os.path.curdir)
    assert os.path.exists(cwd), "something went incredibly wrong"
    test_dir_path = 'searcher/tests/magical_mystery_directory'
    test_dir_path_absolute = os.path.join(cwd, test_dir_path)
    if os.path.exists(test_dir_path_absolute):
        shutil.rmtree(test_dir_path_absolute)
    assert not os.path.exists(test_dir_path_absolute), "something has gone incredibly wrong"
    # when
    create_directory_if_not_exist(directory=test_dir_path_absolute)
    # then
    assert os.path.exists(test_dir_path_absolute)
    # and when
    create_directory_if_not_exist(directory=test_dir_path_absolute)
    # then there's no error and...
    assert os.path.exists(test_dir_path_absolute)


def test_ensure_directories_present():
    # when
    ensure_directories_present(directories=TEST_DIRS)
    # then
    assert os.path.exists(path=TEST_DIR_ONE_PATH_ABSOLUTE), "Creating a directory structure did not work"
    assert os.path.exists(path=TEST_DIR_TWO_PATH_ABSOLUTE), "Creating a directory structure did not work"


@patch("searcher.file_utils.utc_now")
def test_archive_artefacts(utc_now: Mock):
    # given
    pretend_time = datetime(year=1970,
                            month=1,
                            day=2,
                            hour=12,
                            minute=34,
                            second=56,
                            microsecond=789012)
    iso_time = pretend_time.isoformat()
    utc_now.return_value = pretend_time
    if not os.path.exists(ARTEFACTS_DIR):
        os.mkdir(ARTEFACTS_DIR)
    test_file_file_path = f"{ARTEFACTS_DIR}/test_file"
    if not os.path.exists(test_file_file_path):
        os.mkdir(test_file_file_path)
    assert os.path.exists(test_file_file_path),\
        "An error has occurred in setting up the test"
    # when
    archive_artefacts()
    # then
    expected_file_path = f"{ARCHIVE_DIR}/{iso_time}"
    assert os.path.exists(expected_file_path),\
        "file was not correctly archived"
    shutil.rmtree(path=expected_file_path)
