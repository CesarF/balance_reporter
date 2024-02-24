from base.ports.email_handler import EmailHandler
from domain.models.account import Account



class AWSEmailHandler(EmailHandler):

    def send_email(self, entity:Account) -> bool:
        raise NotImplementedError()