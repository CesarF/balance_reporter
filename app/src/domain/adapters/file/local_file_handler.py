"""
Implementation of a file handler to interact with
local files
"""
from typing import List, Tuple

from base.ports.file_handler import FileHandler


class LocalFileHandler(FileHandler):
    """
    Local file manager implementation
    """

    def load_file(self, file_path: str) -> List[Tuple]:
        """
        Extracts the data from a file in a mounted folder and
        return a list of tuples with all the information
        in the file
        """
        file_path
        raise NotImplementedError()
