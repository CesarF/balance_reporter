import pytest
from faker import Faker

from domain.adapters.file.local_file_handler import LocalFileHandler
from errors import FileException

fake = Faker()


def test_load_file(temp_filepath, file_data):
    """
    Validate the file loads correctly
    """

    handler = LocalFileHandler()
    result = handler.load_file(temp_filepath)

    assert result == file_data


def test_load_file__not_found():
    """
    Validates the behavior if the file is not found
    """

    handler = LocalFileHandler()

    with pytest.raises(
        FileException,
        match=("File could not be processed."),
    ):
        handler.load_file(fake.file_path())
