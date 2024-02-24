from abc import ABC, abstractmethod
from typing import NoReturn


class BaseCommand(ABC):
    """
    Represents a base command
    """

    @abstractmethod
    def __call__(self) -> NoReturn:
        raise NotImplementedError()
