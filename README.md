
**teambox-things-sync** lets you sync your Things todos to and from Teambox Collaboration Software.

It fetches todos from remote teambox app (project, task name, due date, task list name) and updates completed ones in both ways. Project (named like the one in teambox) will be created in Things if necessary. By default only tasks assigned to you are imported.

Installation
-------------------------------------------------------------------------------

For now you can install only from source:
    
    git clone git://github.com/fastred/teambox-things-sync.git
    cd teambox-things-sync
    bundle install

Then create a file $HOME/.teambox with these values:

    username: your_teambox_username_or_email
    password: password
    site_url: http://your-teambox-app.com (optional, default set to http://teambox.com)

    
Usage
-------------------------------------------------------------------------------

Now you can run:

    ruby sync.rb

You should see output with names of imported tasks.

If it worked you can add it to your crontab:

    1,31 * * * * cd /path/to/teambox-things-sync/ && ruby sync.rb

Legal
-------------------------------------------------------------------------------

Things is a trademark of Cultured Code GmbH & Co. KG.