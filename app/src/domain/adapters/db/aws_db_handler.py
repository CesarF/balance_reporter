"""
Implementation of a database handler for AWS
"""
from abc import ABC, abstractmethod

from domain.models.account import Account


class AWSDBHandler(ABC):
    """
    Represents a handler to manage database connections
    and operations
    """

    @abstractmethod
    def save(self, entity: Account) -> Account:
        raise NotImplementedError()
