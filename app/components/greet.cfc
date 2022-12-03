component name="greet" {
    public string function default(string path_info) {
        local.path = arguments.path_info == "" ? "/" : arguments.path_info
        return "Hello there, you are currently on the page: <span>#local.path#</span>"
    }
}