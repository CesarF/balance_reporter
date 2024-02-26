"""
Implementation of a file handler to interact with
local files
"""
import csv
import logging
from datetime import datetime
from decimal import Decimal
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
        data = []
        try:
            with open(file_path, newline="") as archivo_csv:
                csv_reader = csv.reader(archivo_csv)
                print(csv_reader)
                # TODO header must be validated
                next(csv_reader)  # skip header
                for row in csv_reader:
                    str_id, str_txdate, str_amount = row
                    if str_amount[0] not in ["-", "+"]:
                        raise Exception("Invalid character in transaction amount")
                    is_credit = str_amount[0] == "+"
                    # TODO: data corresponds to current year
                    txdate = datetime.strptime(str_txdate, "%m/%d").replace(
                        year=datetime.now().year
                    )
                    data.append(
                        (int(str_id), txdate, Decimal(str_amount[1:]), is_credit)
                    )
            return data
        except Exception as err:
            logger.error(err, exc_info=True)
            raise FileException()
