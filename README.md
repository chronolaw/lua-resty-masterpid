# lua-resty-masterpid
Get the pid of nginx master process

## Installation

Please use `opm`, such as :

```lua
opm get chronolaw/lua-resty-masterpid
```

## Usage

```lua
local masterpid = require "resty.masterpid"
ngx.say(masterpid())
```
