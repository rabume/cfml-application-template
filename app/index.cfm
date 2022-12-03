<cfpageencoding charset="utf-8">
<cfparam  name="url.sendMail" default="">

<!DOCTYPE html>
<html>

    <head>
        <link rel="stylesheet" href="/assets/css/main.css">
        <link href="https://fonts.googleapis.com/css2?family=Karla:wght@700&display=swap" rel="stylesheet">
        <title>CFML Application Template</title>
    </head>

    <body>
        <cfoutput>
            <h1>CFML Application Template</h1>
            <hr>
            <h2>#application.greet.default(cgi.path_info)#</h2>
            <br>
            <p>
                You can send an example by adding the url param "sendMail"<br>
                Example: <code>?sendMail=your@mail.dev</code>
            </p>
            <cfif url.sendMail != "">
                <cfset sendMail = application.mail.send(url.sendMail, "example@mail.dev", "Test Mail!")>
                <p>#sendMail#</p>
            </cfif>
            
            <br>
            <h2>Dump of user table:</h2>
            <div class="table-container">
                <table>
                    <tr>
                        <td>User</td>
                        <td>Mail</td>
                    </tr>
                    <cfset userQuery = application.users.getAll()>
                    <cfloop query="userQuery">
                        <tr>
                            <td>#userQuery.username#</td>
                            <td>#userQuery.email#</td>
                        </tr>
                    </cfloop>
                </table>
            </div>

        </cfoutput>
    </body>
</html>