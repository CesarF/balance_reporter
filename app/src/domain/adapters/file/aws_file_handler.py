"""
Implementation of a file handler to interact with
AWS s3 buckets and objects
"""
from typing import List, Tuple

from base.ports.file_handler import FileHandler


class AWSFileHandler(FileHandler):
    """
    AWS S3 manager implementation
    """

    def load_file(self, file_path: str) -> List[Tuple]:
        """
        Extracts the data from a file in s3 bucket and
        return a list of tuples with all the information
        in the file
        """
        file_path
        raise NotImplementedError()
