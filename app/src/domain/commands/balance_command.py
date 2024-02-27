"""
Resources related with the command implementation
to process the credit and debit transactions
of an account
"""
import logging
from typing import Any
from uuid import uuid4

from base.commands.base_command import BaseCommand
from base.ports.db_handler import DBHandler
from base.ports.email_handler import EmailHandler
from base.ports.file_handler import FileHandler
from config import EMAIL_RECIPIENT, EMAIL_SUBJECT, FILE_PATH
from domain.models.account import Account
from domain.models.transaction import Transaction

logger = logging.getLogger(__name__)


class BalanceProcessorCommand(BaseCommand):
    """
    Command class to process transactions data
    """

    def __init__(
        self,
        db_handler: DBHandler,
        file_handler: FileHandler,
        email_handler: EmailHandler,
    ) -> None:
        super().__init__()
        self._db_handler = db_handler
        self._file_handler = file_handler
        self._email_handler = email_handler

    def __call__(self) -> Any:
        # get file
        txlist = self._file_handler.load_file(FILE_PATH)
        logger.info("File has been uploaded")
        logger.debug(str(txlist))

        account = Account(id=str(uuid4()))

        # process file
        for tx in txlist:
            id, txdate, amount, is_credit = tx
            transaction = Transaction(
                id=id, txdate=txdate, amount=amount, is_credit=is_credit
            )
            account.add_transaction(transaction)

        logger.info("Account information has been set...")

        # store data in database
        self._db_handler.save(account)
        logger.info("Information has been recorded in the database...")

        # send email
        resp = self._email_handler.send_email(
            account.create_message(), recipient=EMAIL_RECIPIENT, subject=EMAIL_SUBJECT
        )

        return {f"Message sent to {EMAIL_RECIPIENT}": resp}
