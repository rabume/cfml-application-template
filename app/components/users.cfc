component name="users" {
    public query function getAll() {
        local.getUsers = queryExecute(
            options = {
                datasource = application.databaseName
            },
            sql = "
                SELECT * FROM users;
            "
        );

        return local.getUsers;
    }
}