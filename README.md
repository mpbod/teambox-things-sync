
**teambox-things-sync** lets you sync your [Things][things] todos to and from [Teambox][teambox].

It fetches todos from remote teambox app (project, task name, due date, task list name) and updates completed ones in both ways. Project (named like the one in teambox) will be created in Things if necessary. By default only tasks assigned to you are imported.

Installation
-------------------------------------------------------------------------------

Firstly, create a file $HOME/.teambox with these values:

    username: your_teambox_username_or_email
    password: password
    
    # and an optional: (default set to http://teambox.com)
    site_url: http://your-teambox-app.com

Then, install gem from rubygems:
    
    gem install teambox-things-sync

If you got error please add `sudo` before the command.

Usage
-------------------------------------------------------------------------------

Now you can run:

    teambox-things-sync

You should see output with names of imported tasks.

If it worked, you can add it to your crontab, e.g.:

    1,31 * * * * teambox-things-sync
    
Or if you're using RVM:
    
    1,31 * * * * rvm use rubyver@gemset && teambox-things-sync

Legal
-------------------------------------------------------------------------------

Things is a trademark of Cultured Code GmbH & Co. KG.

[things]: http://culturedcode.com/things/ "Things OS X Application"
[teambox]: http://teambox.com/ "Teambox - Collaboration Software"