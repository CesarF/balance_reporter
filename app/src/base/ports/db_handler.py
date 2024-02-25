"""
Resources to implement a database handler
"""
from abc import ABC, abstractmethod

from base.entities.root_entity import Entity


class DBHandler(ABC):
    """
    Represents a handler to manage database connections
    and operations
    """

    @abstractmethod
    def save(self, entity: Entity) -> Entity:
        raise NotImplementedError()
