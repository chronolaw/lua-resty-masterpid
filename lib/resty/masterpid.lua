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
]]


local function get_masterpid()
    if ffi.os ~= "Linux" then
        return nil, "only works in linux"
    end

    -- 0 = single process
    local ppid = (ffi_C.ngx_process == 0) and
                    ngx_worker_pid() or ffi_C.getppid()

    return ppid
end

return get_masterpid
