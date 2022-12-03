component name="application" {

    this.name = "cfml_application_template"
    cfsetting(requesttimeout=10, showdebugoutput=false);

    function OnApplicationStart() output=false {
        application.databaseName = server.system.environment.dbName ?: "database";

        application.greet = new components.greet();
        application.users = new components.users();
        application.mail = new components.mail();

        application.environment = server.system.environment.BOX_SERVER_PROFILE;

        return this;
    }

    function OnSessionStart() output=false {
        // Your logic

        return;
    }

    function onRequest(targetPage) {
        if(structKeyExists(url, "reinit") && application.environment == "development"){
            if(url.reinit == 1){
                this.OnSessionStart();
            }

            if(url.reinit == 2){
                this.OnApplicationStart();
            }

            if(url.reinit == 3){
                this.OnSessionStart();
                this.OnApplicationStart();
            }
        }
        
        include arguments.targetPage;
    }

    function onError(struct exception, string eventName) {
        if (server.system.environment.BOX_SERVER_PROFILE == "development") {
            writeOutput(arguments.exception);
        } 
        else {
            // Logic for error handeling in production
        }
    } 

    // Database
    application.databaseName = server.system.environment.dbName ?: "database";
    local.databaseUsername = server.system.environment.dbUsername ?: "user";
    local.databasePassword = server.system.environment.dbPassword ?: "defaultpass";
    local.databasePort = server.system.environment.dbPort ?: "3306";
    local.databaseTZ = server.system.environment.dbTZ ?: "Europe/Zurich";

    this.datasources[application.databaseName] = {
          class: 'com.mysql.cj.jdbc.Driver'
        , bundleName: 'com.mysql.cj'
        , bundleVersion: '8.0.19'
        , connectionString: 'jdbc:mysql://mysql:' & local.databasePort & '/' & application.databaseName & '?useUnicode=true&characterEncoding=UTF-8&allowMultiQueries=true&serverTimezone=' & local.databaseTZ
        , username: local.databaseUsername
        , password: local.databasePassword
        , connectionLimit:100 
        , liveTimeout:60
        , alwaysSetTimeout:true
        , validate:true
    };

    // Mailserver
    local.mailServerHost = server.system.environment.mailServerHost ?: "mailslurper";
    local.mailServerPort = server.system.environment.mailServerPort ?: 2500;
    local.mailServerUser = server.system.environment.mailServerUser ?: "";
    local.mailServerPass = server.system.environment.mailServerPass ?: "";
    local.mailServerSSL = server.system.environment.mailServerSSL ?: false;
    local.mailServerTLS = server.system.environment.mailServerTLS ?: false;

    this.mailservers = [ {
        host: local.mailServerHost
        ,port: local.mailServerPort
        ,username: local.mailServerUser
        ,password: local.mailServerPass
        ,ssl: local.mailServerSSL
        ,tls: local.mailServerTLS
    } ];

}