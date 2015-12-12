## Setup

You're going to need some tools to work with the project. So, here's what we've
got, so far:

### Mac OS X development

* Vagrant
* vagrant-scp

So, to get that, here's a little thing for you to run.

```
# You have to have installed brew-cask.
# Check out http://caskroom.io
brew cask install vagrant

vagrant plugin install vagrant-scp
```

## Building

Now that you can build for Ubuntu servers, all you have to do is run

```
./build-ubuntu.sh
```
