component name="mail" {
    public function send(string to, string from, string message) {
        try {
            cfmail(subject="Example Mail", to="#arguments.to#", from="#arguments.from#") {
                 writeOutput('<h1>Example Mail!</h1>');
            }
            return "Mail sent!"

        }catch(any) {
            return "Something went wrong!"
            
        }

    }
}