import os
from searcher.json_reader import list_json_files, get_json_object
from unittest.mock import patch
import pytest

@patch("searcher.json_reader.PATHS_TO_IGNORE",['ignored_directory'])
def tests_list_json_files_happy_path():
    parent_dir = 'searcher/tests/json_reader_test_directory'
    json_files = list_json_files(parent_directory=parent_dir)
    absolute_path = os.path.abspath(parent_dir)
    assert f"{absolute_path}/ignored_directory/should_not_appear.json" not in json_files, "file found when directory should have been ignored"
    assert f"{absolute_path}/should_not_appear.txt" not in json_files, "file found when it is of incorrect type"
    assert f"{absolute_path}/should_appear.json" in json_files, "file not found when it should be"


@patch("searcher.json_reader.PATHS_TO_IGNORE",['ignored_directory'])
def tests_list_json_files_sad_path():
    parent_dir = 'searcher/does_not_exist/extra_nonsense_for_good_measure_asdj'
    json_files = list_json_files(parent_directory=parent_dir)
    assert len(json_files) == 0, "directory doesn't exist, so no files should have been returned"


def tests_get_json_object_happy_path():
    object_to_grab = "searcher/tests/json_reader_test_directory/should_appear.json"
    my_object = get_json_object(file_path=object_to_grab)
    assert isinstance(my_object, dict), "returned something that wasn't in the JSON"
    assert my_object['me'] == 'I am a JSON object', "returned something that wasn't in the JSON"


def tests_get_json_object_sad_path():
    object_to_grab = "searcher/tests/json_reader_test_directory/does_not_exist_adfkjhsdafuyaeksdaj.json"
    with pytest.raises(FileNotFoundError):
        _ = get_json_object(file_path=object_to_grab)
