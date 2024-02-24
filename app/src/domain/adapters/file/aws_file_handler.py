from base.ports.file_handler import FileHandler
from typing import List, Tuple


class AWSFileHandler(FileHandler):

    def load_file(self, file_path:str) -> List[Tuple]:
        raise NotImplementedError()