"""
Implementation of a file handler to interact with
local files
"""
import logging
from typing import List, Tuple

from base.ports.file_handler import FileHandler
from errors import FileException

logger = logging.getLogger(__name__)


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
        try:
            with open(file_path, newline="") as csv_file:
                return self.extract_data(csv_file)
        except Exception as err:
            logger.error(err, exc_info=True)
            raise FileException()
