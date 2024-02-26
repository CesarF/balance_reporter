"""
Resources to implement a command
"""
from abc import ABC, abstractmethod
from typing import Any


class BaseCommand(ABC):
    """
    Represents a base command
    """

    @abstractmethod
    def __call__(self) -> Any:
        raise NotImplementedError()
