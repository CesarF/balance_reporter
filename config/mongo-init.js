db.createUser(
    {
        user: "accounts",
        pwd: "accountspwd",
        roles: [
            {
                role: "readWrite",
                db: "accounts"
            }
        ]
    }
);
