<!--
i have to use html in markdown because: https://github.com/imathis/octopress/issues/488. :(
-->
# webhook-post-receive #

a simple app to receive github/bitbucket webhook, `git pull` in your working directory, and restart your app. it's not for production server, only for development one.

## how to use ##
<ol>
<li>You have a app which uses git, name it `example-app`</li>

<li>You a dev server, where you have an `example-user` unix user, who runs the app.</li>

<li>I use for running my apps [supervisord](http://supervisord.org/).
Here's the config.

<pre><code>
    /etc/supervisor/conf.d/exampleapp.conf
</code></pre>
<pre><code>
    [program:exampleapp]
    command: coffee server.coffee
    user: exampleuser
    directory: /home/exampleuser/example-app
</code></pre>
</li>
<li>Give access to `supervisorctl` for `exampleuser`

<pre><code>
    sudo visudo
</code></pre>
<pre><code>
     # User alias specification
     exampleuser ALL=(root)NOPASSWD:/usr/bin/supervisorctl restart exampleapp
</code></pre>
</li>
<li>So here's your config for app:
<pre><code>
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
</code></pre>
</li>
<li>Start this app, via `coffee app.coffee` or use supervisord:

<pre><code>
    sudo nano /etc/supervisor/conf.d/webhook.conf
</code></pre>

<pre><code>
    [program:webhook]
    command: coffee app.coffee
    user: root
    directory: /home/[youruser]/webhook-post-receive
</code></pre>
<pre><code>
    sudo supervisorctl start webhook
</code></pre>
</li>
<li>Setup a webhook to `http://[your-host]:3500`</li>

<li>8. Be happy:)</li>