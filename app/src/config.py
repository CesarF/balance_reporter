"""
Configuration file, contains all the constants values
used by the application
"""

import os

FILE_PATH = os.environ.get("FILE_PATH", "./data/txns.csv")
EMAIL_SENDER = os.environ["EMAIL_SENDER"]
EMAIL_RECIPIENT = os.environ["EMAIL_RECIPIENT"]
EMAIL_SUBJECT = os.environ.get("EMAIL_SUBJECT", "Your financial report from Stori")
HTML_TEMPLATE = """
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Financial Report</title>
    <style>
        h1 {{
            font-size: 24px;
        }}
        p {{
            font-size: 18px;
        }}
        table {{
            border-collapse: collapse;
            width: 250px;
        }}
        th, td {{
            border: 1px solid black;
            padding: 8px;
            text-align: left;
        }}
        th {{
            background-color: #f2f2f2;
        }}
        img {{
            width: 250px;
        }}
    </style>
</head>
<body>
    <img src="https://blog.storicard.com/wp-content/uploads/2019/07/Stori-horizontal-11.jpg" alt="Company Logo">
    <h1>Welcome to Your Financial Report</h1>
    <p>Total balance is <strong>${total_balance}</strong></p>
    <p>Average debit amount: <strong>$-{average_debit}</strong></p>
    <p>Average credit amount: <strong>${average_credit}</strong></p>
    <h2>Number of Transactions</h2>
    <table>
        <tr>
            <th>Month</th>
            <th>Number of Transactions</th>
        </tr>
        {rows}
    </table>
</body>
</html>
"""
