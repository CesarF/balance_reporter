"""
Implementation of a database handler for AWS
"""
from base.ports.db_handler import DBHandler
from domain.models.account import Account


class AWSDBHandler(DBHandler):
    """
    Represents a handler to manage database connections
    and operations
    """

    def save(self, entity: Account) -> Account:
        entity
        raise NotImplementedError()
