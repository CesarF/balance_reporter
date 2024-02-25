"""
Resources to implement a command
"""
from abc import ABC, abstractmethod
from typing import Dict, NoReturn


class BaseCommand(ABC):
    """
    Represents a base command
    """

    @abstractmethod
    def __call__(self, event: Dict) -> NoReturn:
        raise NotImplementedError()
