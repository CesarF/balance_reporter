"""
All the custom errors
"""


class CustomBaseException(Exception):
    """
    Base exception
    Attributes:
        message -- Error message
    """

    def __init__(self, message):
        self.message = message
        super().__init__(self.message)

    def __str__(self):
        return self.message


class FileException(CustomBaseException):
    """
    Used for file errors
    """

    def __init__(self, message="File could not be processed."):
        super().__init__(message)


class DatabaseException(CustomBaseException):
    """
    Used for database errors
    """

    def __init__(self, message="Database connection failed."):
        super().__init__(message)
