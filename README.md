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

Finally run:

    ruby sync.rb
    
Using default settings it should output names of imported todos.