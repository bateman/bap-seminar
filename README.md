# bap-seminar
Material for the Best-Answer Prediction seminar.

To start with the setup, open the terminal and cd to a folder of choice; then, clone the current project:
```
$ git clone https://github.com/bateman/bap-seminar.git
$ cd bap-seminar
```

## Part 1 - Build a dataset using web scraping
To configure the system for Part 1, make sure to have Python 2.7 installed first. To check the default version of Python, open the terminal and run:
```
$ python --version
Python 2.7.10
```
You're also encouraged to set up a `virtualenv`. To install `vitualenv`, open the terminal and run:
```
$ pip install virtualenv
```
Now cd to `bap-seminar/python` and run the following to create a `virtualenv` and activate it:
```
$ virtualenv .venv
$ source .venv/bin/activate
```
Further info on `virtualenv` can be found [here](http://docs.python-guide.org/en/latest/dev/virtualenvs/).

Now that that a `virtualenv` is active, run the following command and wait until all the packages are downloaded and installed. All the changes won't affect the system, but will stay sandboxed within the active `virtualenv`.
```
$ pip install -r python/requirements_py2.txt
```

## Part 2 - Run a classification study with R
To configure the system for Part 2, make sure that R statistical package is installed. To check for R, open the terminal and run:
```
$ R --version
R version 3.3.1 (2016-06-21) [...]
```

Now cd to `bap-seminar/r` and run the following command and wait until all the packages are downloaded and installed. 
```
$ Rscript requirements.r
```
