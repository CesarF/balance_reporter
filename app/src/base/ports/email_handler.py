from abc import ABC, abstractmethod
from base.entities.root_entity import Entity


class EmailHandler(ABC):
    """
    Represents a handler to send emails
    """

    @abstractmethod
    def send_email(self, entity:Entity) -> bool:
        raise NotImplementedError()
