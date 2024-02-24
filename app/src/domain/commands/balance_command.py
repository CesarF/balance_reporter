from base.commands.base_command import BaseCommand
from typing import NoReturn, Tuple
from base.ports.db_handler import DBHandler
from base.ports.email_handler import EmailHandler
from base.ports.file_handler import FileHandler
from config import FILE_PATH
from datetime import strptime
from domain.models.transaction import Transaction
from domain.models.account import Account
from decimal import Decimal
from uuid import uuid4



class BalanceProcessorCommand(BaseCommand):

    def __init__(self, db_handler:DBHandler, file_handler:FileHandler, email_handler:EmailHandler) -> None:
        super().__init__()
        self._db_handler = db_handler
        self._file_handler = file_handler
        self._email_handler = email_handler

    
    def _extract_data(row:Tuple) -> Tuple:
        try:
            str_id, str_txdate, str_amount = row
            if str_amount[0] not in ["-", "+"]:
                raise Exception("Invalid character in transaction amount")
            is_credit = str_amount[0] == "+"
            txdate = strptime(str_txdate, "%M/%d")
            return int(str_id), txdate, Decimal(str_amount[1:]), is_credit
        except Exception as err:
            raise Exception("Invalid file format")


    def __call__(self) -> NoReturn:
        # get file
        txlist = self._file_handler.load_file(FILE_PATH)

        account = Account(id=uuid4())

        # process file
        for tx in txlist:
            id, txdate, amount, is_credit = self._extract_data(tx)
            transaction = Transaction(id=id, txdate=txdate, amount=amount, is_credit=is_credit)
            account.add_transaction(transaction)

        # store data in database

        # send email
        self._email_handler.send_email_balance(account)
