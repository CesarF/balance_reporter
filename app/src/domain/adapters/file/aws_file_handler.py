"""
Implementation of a file handler to interact with
AWS s3 buckets and objects
"""
import logging
from io import StringIO
from typing import List, Tuple

import boto3

from base.ports.file_handler import FileHandler
from errors import FileException

logger = logging.getLogger(__name__)


class AWSFileHandler(FileHandler):
    """
    AWS S3 manager implementation
    """

    def __init__(self):
        self.s3_client = boto3.client("s3")

    def load_file(self, file_path: str) -> List[Tuple]:
        """
        Extracts the data from a file in s3 bucket and
        return a list of tuples with all the information
        in the file
        """
        try:
            bucket, key = file_path.split("/", 1)

            response = self.s3_client.get_object(Bucket=bucket, Key=key)
            content = response["Body"].read().decode("utf-8")

            csv_data = StringIO(content)
            return self.extract_data(csv_data)
        except Exception as err:
            logger.error(err, exc_info=True)
            raise FileException()
