from abc import ABC, abstractmethod
from typing import List, Tuple


class FileHandler(ABC):
    """
    Represents a handler to manipulate files
    from an specific source
    """

    @abstractmethod
    def load_file(self, file_path:str) -> List[Tuple]:
        raise NotImplementedError()
