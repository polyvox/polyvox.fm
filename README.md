## Setup

You're going to need some tools to work with the project. So, here's what we've
got, so far:

### Mac OS X development

* VirtualBox
* Vagrant
* vagrant-scp

So, to get that, here's a little thing for you to run.

```
# You have to have installed brew-cask.
# Check out http://caskroom.io
brew cask install virtualbox
brew cask install vagrant

# Install the vagrant-scp plugin
# We will eventually remove this as a dependency
vagrant plugin install vagrant-scp
```

## SECRETS!

You have to know the password for the production database. So, if you're
not in that inner circle, you can still build locally, but your push
will fail. Sorry.

## Building

Now that you can build for Ubuntu servers, all you have to do is run

```
./build-ubuntu.sh
```

That first time can take a little while. So, patience as Vagrant provisions
the VM. Unless you destroy it, later, it'll go much faster the *n+1* time.

## DEPLOYING THE APPLICATION SERVER

Now that you've got something built, you can use the `deploy.sh` script
to get it to the server.

```
./deploy.sh <version>
```

So, if you're deploying version 0.5.1, you'd type

```
./deploy.sh 0.5.1
```

## DEPLOYING THE DATABASE

Yeah, still trying to figure this one out. It's not easy with the
Phoenix tool stack, as you well know. But, hey, that's why we're
programmers, right?

More to come...
