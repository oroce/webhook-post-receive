
# webhook-post-receive #

a simple app to receive github/bitbucket webhook, `git pull` in your working directory, and restart your app. it's not for production server, only for development one.

## how to use ##

 1. You have a app which uses git, name it `example-app`

 2. You a dev server, where you have an `example-user` unix user, who runs the app.

 3. I use for running my apps [supervisord](http://supervisord.org/).
Here's the config.

`/etc/supervisor/conf.d/exampleapp.conf`

    [program:exampleapp]
    command: coffee server.coffee
    user: exampleuser
    directory: /home/exampleuser/example-app

 4. Give access to `supervisorctl` for `exampleuser`

`sudo visudo`

    # User alias specification
    exampleuser ALL=(root)NOPASSWD:/usr/bin/supervisorctl restart exampleapp

5. So here's your config for app:

    {
	"example-app": {
		"directory": "/home/exampleuser/example-app",
		"user": "exampleuser",
		"postCommand": "sudo /usr/bin/supervisorctl restart exampleapp"
	},
	"server": {
		"port": 3300
	}
    }

6. Start this app, via `coffee app.coffee` or use supervisord:
    `sudo nano /etc/supervisor/conf.d/webhook.conf`

    [program:webhook]
    command: coffee app.coffee
    user: root
    directory: /home/[youruser]/webhook-post-receive

    `sudo supervisorctl start webhook`

7. Setup a webhook to `http://[your-host]:3500`

8. Be happy:)