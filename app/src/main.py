from base.commands.base_command import BaseCommand


def _main(event, command:BaseCommand) -> dict:
    """
    Main function
    """
    return command(event)


def aws(event, _) -> dict:
    """
    
    """
    from domain.commands.balance_command import BalanceProcessorCommand
    from domain.adapters.file.aws_file_handler import AWSFileHandler
    from domain.adapters.email.aws_email_handler import AWSEmailHandler
    from domain.adapters.db.aws_db_handler import AWSDBHandler

    command = BalanceProcessorCommand(
        db_handler = AWSDBHandler(),
        file_handler = AWSFileHandler(),
        email_handler = AWSEmailHandler()
    )

    _main(event, command)


def local(event, _) -> dict:
    """
    
    """
    from domain.commands.balance_command import BalanceProcessorCommand
    from domain.adapters.file.local_file_handler import LocalFileHandler
    from domain.adapters.email.aws_email_handler import AWSEmailHandler
    from domain.adapters.db.local_db_handler import LocalDBHandler

    command = BalanceProcessorCommand(
        db_handler = LocalDBHandler(),
        file_handler = LocalFileHandler(),
        email_handler = AWSEmailHandler()
    )

    _main(event, command)

