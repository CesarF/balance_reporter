"""
Resources to implement a file handler
"""
import csv
from abc import ABC, abstractmethod
from datetime import datetime
from decimal import Decimal
from typing import List, Tuple


class FileHandler(ABC):
    """
    Represents a handler to manipulate files
    from an specific source
    """

    @abstractmethod
    def load_file(self, file_path: str) -> List[Tuple]:
        raise NotImplementedError()

    def extract_data(self, csv_file: any) -> List[Tuple]:
        """
        Extracts the data from a file
        """
        data = []
        csv_reader = csv.reader(csv_file)
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
            data.append((int(str_id), txdate, Decimal(str_amount[1:]), is_credit))
        return data
