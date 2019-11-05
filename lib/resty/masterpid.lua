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
    typedef pid_t     ngx_pid_t;

    extern ngx_uint_t ngx_process;
    extern ngx_pid_t  ngx_parent;
]]

-- 0 = single process
local function is_single_process()
    return ffi_C.ngx_process == 0
end

local function get_masterpid()
    if ffi.os ~= "Linux" then
        return nil, "only works in linux"
    end

    if is_single_process() then
        return ngx_worker_pid()
    else
        -- nginx 1.13.8 has ngx_parent
        if ngx.config and ngx.config.nginx_version >= 1013008 then
            return ffi_C.ngx_parent
        else
            return ffi_C.getppid()
        end
    end
end

return get_masterpid
