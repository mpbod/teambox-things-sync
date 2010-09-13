
**teambox-things-sync** lets you sync your Things todos to and from Teambox Collaboration Software.

It fetches todos from remote teambox app (project, task name, due date, task list name) and updates completed ones in both ways. Project (named like the one in teambox) will be created in Things if necessary.

Installation
-------------------------------------------------------------------------------

For now you can install only from source:
    
    git clone git://github.com/fastred/teambox-things-sync.git
    cd teambox-things-sync
    bundle install

Then create a file $HOME/.teambox with these values:

    username: your_teambox_username_or_email
    password: password
    site_url: http://path-to-your-teambox.com (optional, default: http://teambox.com)

    
Usage
-------------------------------------------------------------------------------

Finally run:

    ruby sync.rb

While using default settings it should output names of imported todos.

Legal
-------------------------------------------------------------------------------

Things is a trademark of Cultured Code GmbH & Co. KG.