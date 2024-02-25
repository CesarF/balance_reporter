"""
Implementation of a database handler for local resources
"""
from abc import ABC, abstractmethod

from domain.models.account import Account


class LocalDBHandler(ABC):
    """
    Represents a handler to manage database connections
    and operations
    """

    @abstractmethod
    def save(self, entity: Account) -> Account:
        raise NotImplementedError()
