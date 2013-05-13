statusboard-graphs
==================

This is the start of a repository of
[thor](https://github.com/wycats/thor/) tasks to generate graphs and
tables for Panic's [statusboard](http://panic.com/statusboard/). It is
currently highly customized for my own needs.

Supported Services
------------------

* 37signals Highrise CRM (Deals and recordings)
* Zendesk (Ticket counts in views)

Configuration
-------------

The repository contains a `config.yaml.sample` file that you need to 
rename to `config.yaml` and provide your account information with.

Running
-------

Run once or as a cron/launchd job:

    thor graph:all
    thor table:all

Using with Statusboard
----------------------

Put the resulting JSON anf HTML files onto your webspace or use the
embedded [Sinatra](http://sinatrarb.com) server and use the `public/` 
paths as the data source URLs for Statusboard's widgets.

Maintainer
----------

Patrick Lenz <patricklenz@gmail.com>
