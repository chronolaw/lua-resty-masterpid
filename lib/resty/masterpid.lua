-- Copyright (C) 2017 by chrono

local ffi = require "ffi"
local ffi_cdef = ffi.cdef
local ffi_C = ffi.C

local ngx_worker_pid = ngx.worker.pid

ffi_cdef[[
    typedef int pid_t;
    pid_t getppid(void);
]]

ffi_cdef[[
    typedef uintptr_t ngx_uint_t;

    extern ngx_uint_t ngx_process;
    extern ngx_pid_t  ngx_parent;
]]


local function get_masterpid()
    if ffi.os ~= "Linux" then
        return nil, "only works in linux"
    end

    -- nginx 1.13.8 has ngx_parent
    if ngx.config and ngx.config.nginx_version >= 1013008 then
        return ffi_C.ngx_parent
    end

    -- 0 = single process
    local pid = (ffi_C.ngx_process == 0) and
                    ngx_worker_pid() or ffi_C.getppid()

    return pid
end

return get_masterpid
