unit np.libuv;
{$A8,Z4}

interface

{$IFDEF MSWINDOWS}

uses np.common, WinApi.Windows, np.winsock, System.sysUtils;
{$ENDIF}
{$IFDEF LINUX}

uses np.common, sysUtils, Posix.Base, Posix.SysSocket, Posix.ArpaInet,
  Posix.NetinetIn, Posix.NetDB,
  Posix.SysTypes, Posix.Semaphore, Posix.Fcntl, Posix.SysStat, Posix.SysUio;
{$ENDIF}
// {$IF not defined( PUTF8Char ) }
// type
// PUTF8Char = _^AnsiChar;
// {$ENDIF}

const
  UV_EOF = -4095;
  UV_ECANCELED = -4081;
  UV_ENOBUFS = -4060;
  UV_DEFAULT_PORT = 0;
{$IFDEF MSWINDOWS}
  UV_DEFAULT_BACKLOG = SOMAXCONN;
{$ELSE}
  UV_DEFAULT_BACKLOG = 0;
{$ENDIF}
  UV_AF_INET = AF_INET;
  UV_AF_INET6 = AF_INET6;

  SIGINT = 2;
  SIGILL = 4;
  SIGABRT_COMPAT = 6;
  SIGFPE = 8;
  SIGSEGV = 11;
  SIGTERM = 15;
  SIGBREAK = 21;
  SIGABRT = 22;
  SIGHUP = 1;
  SIGKILL = 9;
  SIGWINCH = 28;

  UV_STDIN_FD = 0;
  UV_STDOUT_FD = 1;
  UV_STDERR_FD = 2;

  UV_READABLE = 1;
  UV_WRITABLE = 2;
  UV_DISCONNECT = 4;
  UV_PRIORITIZED = 8;

type

  ENPException = class(Exception)
    errCode: integer;
    errName: string;
    constructor Create(err: integer);
  end;

  Pnodepas_constants = ^Tnodepas_constants;

  Tnodepas_constants = record
    (* fs open() flags supported on other platforms (or mapped on this platform): *)
    uv_fs_o_direct: integer;
    uv_fs_o_directory: integer;
    uv_fs_o_dsync: integer;
    uv_fs_o_exlock: integer;
    uv_fs_o_noatime: integer;
    uv_fs_o_noctty: integer;
    uv_fs_o_nofollow: integer;
    uv_fs_o_nonblock: integer;
    uv_fs_o_symlink: integer;
    uv_fs_o_sync: integer;

    (* fs open() flags supported on this platform: *)
    uv_fs_o_append: integer;
    uv_fs_o_creat: integer;
    uv_fs_o_excl: integer;
    uv_fs_o_random: integer;
    uv_fs_o_rdonly: integer;
    uv_fs_o_rdwr: integer;
    uv_fs_o_sequential: integer;
    uv_fs_o_short_lived: integer;
    uv_fs_o_temporary: integer;
    uv_fs_o_trunc: integer;
    uv_fs_o_wronly: integer;
    f_ok: integer;
    r_ok: integer;
    w_ok: integer;
    x_ok: integer;
  end;

  // sockaddr_in = record
  // end;
  //
  // sockaddr_in6 = record
  // end;
  //
  // PADDRINFO = record
  // end;
  Tsockaddr_in = sockaddr_in;
  Tsockaddr_in6 = sockaddr_in6;
  psockaddr = ^Tsockaddr_in;
  PSockAddr_In = ^Tsockaddr_in;
  psockaddr_In6 = ^Tsockaddr_in6;
  PSockAddr_in_any = ^TSockAddr_in_any;

  TSockAddr_in_any = record
    case integer of
      UV_AF_INET:
        (ip4: Tsockaddr_in);
      UV_AF_INET6:
        (ip6: Tsockaddr_in6);
  end;

  puv_sockAddr = ^uv_sockAddr;

  uv_sockAddr = record
    sa: TSockAddr_in_any;
    function GetAddr: UTF8String;
    procedure SetAddr(const Aaddr: UTF8String);
    function GetPort: word;
    procedure SetPort(Aport: word);
    function isIP6: Boolean;
    function ToString: String;
    procedure Assign(addr: PSockAddr_in_any);
    class function Create(const Aaddr: UTF8String; Aport: word)
      : uv_sockAddr; static;
    procedure Init(const Aaddr: UTF8String; Aport: word);
    property Port: word read GetPort write SetPort;
    property addr: UTF8String read GetAddr write SetAddr;
  end;

  uv_handle_type = (UV_UNKNOWN_HANDLE = 0, UV_ASYNC, UV_CHECK, UV_FS_EVENT_,
    UV_FS_POLL, UV_HANDLE, UV_IDLE, UV_NAMED_PIPE, UV_POLL, UV_PREPARE,
    UV_PROCESS, UV_STREAM, UV_TCP, UV_TIMER, UV_TTY, UV_UDP, UV_SIGNAL,
    UV_FILE_, UV_HANDLE_TYPE_MAX);

  uv_req_type = (UV_UNKNOWN_REQ = 0, UV_REQ, UV_CONNECT, UV_WRITE_,
    UV_SHUTDOWN_, UV_UDP_SEND_, UV_FS, UV_WORK, UV_GETADDRINFO_,
    UV_GETNAMEINFO_, UV_ACCEPT_, UV_FS_EVENT_REQ, UV_POLL_REQ, UV_PROCESS_EXIT,
    UV_READ, UV_UDP_RECV, UV_WAKEUP, UV_SIGNAL_REQ, UV_REQ_TYPE_MAX);

{$IFDEF WIN32}

const
  LIBUV_FILE = NODEPAS_LIB;

  sizeof_loop_t = 256;
  sizeof_async_t = 116;
  sizeof_check_t = 60;
  sizeof_fs_event_t = 140;
  sizeof_fs_poll_t = 52;
  sizeof_handle_t = 48;
  sizeof_idle_t = 60;
  sizeof_pipe_t = 320;
  sizeof_poll_t = 256;
  sizeof_prepare_t = 60;
  sizeof_process_t = 136;
  sizeof_stream_t = 144;
  sizeof_tcp_t = 168;
  sizeof_timer_t = 96;
  sizeof_tty_t = 196;
  sizeof_udp_t = 288;
  sizeof_signal_t = 136;
  sizeof_req_t = 60;
  sizeof_connect_t = 68;
  sizeof_write_t = 92;
  sizeof_shutdown_t = 68;
  sizeof_udp_send_t = 68;
  sizeof_fs_t = 312;
  sizeof_work_t = 92;
  sizeof_addrinfo_t = 112;
  sizeof_nameinfo_t = 1288;
  sizeof_rwlock_t = 48;
  sizeof_cond_t = 36;
  sizeof_barrier_t = 40;
  sizeof_mutex_t = 24;

{$ENDIF}
{$IFDEF WIN64}

const
  LIBUV_FILE = NODEPAS_LIB;

  sizeof_loop_t = 464;
  sizeof_async_t = 224;
  sizeof_check_t = 120;
  sizeof_fs_event_t = 272;
  sizeof_fs_poll_t = 104;
  sizeof_handle_t = 96;
  sizeof_idle_t = 120;
  sizeof_pipe_t = 576;
  sizeof_poll_t = 416;
  sizeof_prepare_t = 120;
  sizeof_process_t = 264;
  sizeof_stream_t = 272;
  sizeof_tcp_t = 320;
  sizeof_timer_t = 160;
  sizeof_tty_t = 344;
  sizeof_udp_t = 424;
  sizeof_signal_t = 264;
  sizeof_req_t = 112;
  sizeof_connect_t = 128;
  sizeof_write_t = 176;
  sizeof_shutdown_t = 128;
  sizeof_udp_send_t = 128;
  sizeof_fs_t = 456;
  sizeof_work_t = 176;
  sizeof_addrinfo_t = 216;
  sizeof_nameinfo_t = 1368;
  sizeof_rwlock_t = 80;
  sizeof_cond_t = 64;
  sizeof_barrier_t = 64;
  sizeof_mutex_t = 40;

{$ENDIF}
{$IFDEF MSWINDOWS}

type
  SIZE_T = NativeUInt;
  psize_t = ^SIZE_T;
  SSIZE_T = NativeInt;
  uv_os_sock_t = TSOCKET;
  uv_os_fd_t = THANDLE;

  uv_thread_t = THANDLE;
  uv_sem_t = THANDLE;

  uv_uid_t = Byte;
  uv_gid_t = Byte;
  uv_pid_t = integer;

  uv_lib_t = record
    handle: HMODULE;
    errmsg: PAnsiChar;
  end;

  uv_once_t = record
    ran: Byte;
    event: THANDLE;
  end;

  uv_key_t = record
    tls_index: DWORD;
  end;

  uv_buf_t = record
    case Boolean of
      true:
        (cast: WSABUF);
      false:
        (len: { size_t } u_long;
          Base: PByte;);
  end;

const

  sizeof_os_sock_t = sizeof(uv_os_sock_t);
  sizeof_os_fd_t = sizeof(uv_os_fd_t);

{$ENDIF}
{$IFDEF LINUX64}

const
  LIBUV_FILE = NODEPAS_LIB;
  sizeof_loop_t = 848;
  sizeof_async_t = 128;
  sizeof_check_t = 120;
  sizeof_fs_event_t = 136;
  sizeof_fs_poll_t = 104;
  sizeof_handle_t = 96;
  sizeof_idle_t = 120;
  sizeof_pipe_t = 264;
  sizeof_poll_t = 160;
  sizeof_prepare_t = 120;
  sizeof_process_t = 136;
  sizeof_stream_t = 248;
  sizeof_tcp_t = 248;
  sizeof_timer_t = 152;
  sizeof_tty_t = 312;
  sizeof_udp_t = 216;
  sizeof_signal_t = 152;

  sizeof_req_t = 64;
  sizeof_connect_t = 96;
  sizeof_write_t = 192;
  sizeof_shutdown_t = 80;
  sizeof_udp_send_t = 320;
  sizeof_fs_t = 440;
  sizeof_work_t = 128;
  sizeof_addrinfo_t = 160;
  sizeof_nameinfo_t = 1320;

  sizeof_rwlock_t = 56;
  sizeof_cond_t = 48;
  sizeof_barrier_t = 32;
  // sizeof_sem_t = 32;
  sizeof_mutex_t = 40;
  // sizeof_os_sock_t = 4;
  // sizeof_os_fd_t  = 4;

type
  SIZE_T = NativeUInt;
  psize_t = ^SIZE_T;
  SSIZE_T = NativeInt;
  UInt = Cardinal;
  PAnsiChar = PUTF8Char;
  uv_os_sock_t = integer;
  uv_os_fd_t = integer;
  uv_thread_t = pthread_t;
  uv_sem_t = sem_t;
  uv_uid_t = uid_t;
  uv_gid_t = gid_t;
  uv_pid_t = pid_t;

  uv_lib_t = record
    handle: Pointer;
    errmsg: PAnsiChar;
  end;

  uv_once_t = pthread_once_t;
  uv_key_t = pthread_key_t;

  uv_buf_t = record
    case Boolean of
      true:
        (cast: iovec);
      false:
        (Base: PByte; { Pointer to data. }
          len: SIZE_T; { Length of data. } );

  end;
{$ENDIF}

type
  _PAddrInfo = PAddrInfo;

  uv_mutex_t = record
    interval: array [1 .. sizeof_mutex_t] of Byte;
  end;

  puv_mutex_t = ^uv_mutex_t;

  uv_rwlock_t = record
    interval: array [1 .. sizeof_rwlock_t] of Byte;
  end;

  puv_rwlock_t = ^uv_rwlock_t;

  uv_cond_t = record
    interval: array [1 .. sizeof_cond_t] of Byte;
  end;

  puv_cond_t = ^uv_cond_t;

  uv_barrier_t = record
    interval: array [1 .. sizeof_barrier_t] of Byte;
  end;

  puv_barrier_t = ^uv_barrier_t;

type
  puv_os_fd_t = ^uv_os_fd_t;
  puv_os_sock_t = ^uv_os_sock_t;
  puv_thread_t = ^uv_thread_t;
  puv_sem_t = ^uv_sem_t;
  puv_lib_t = ^uv_lib_t;
  puv_once_t = ^uv_once_t;
  puv_key_t = ^uv_key_t;

  puv_loop_t = ^uv_loop_t;

  puv_handle_t = ^uv_handle_s;
  puv_shutdown_t = ^uv_shutdown_s;

  uv_file = uv_os_fd_t;

{$POINTERMATH ON}
  puv_buf_t = ^uv_buf_t;
  PAnsiCharArray = ^PAnsiChar;
{$POINTERMATH OFF}
  // uv_buf_array = array [0 .. 0] of uv_buf_t;
  // puv_buf_array = ^uv_buf_array;

  (* Request types. *)
  uv_req_s = record
    internal: array [1 .. sizeof_req_t] of Byte;
  end;

  uv_req_t = uv_req_s;
  puv_req_t = ^uv_req_t;

  uv_dirent_type_t = (UV_DIRENT_UNKNOWN, UV_DIRENT_FILE, UV_DIRENT_DIR,
    UV_DIRENT_LINK, UV_DIRENT_FIFO, UV_DIRENT_SOCKET, UV_DIRENT_CHAR,
    UV_DIRENT_BLOCK);

  puv_stream_t = ^uv_stream_t;

  uv_close_cb = procedure(handle: puv_handle_t); cdecl;

  uv_handle_s = record
    internal: array [1 .. sizeof_handle_t] of Byte;
  end;

  uv_handle_t = uv_handle_s;

  uv_connection_cb = procedure(server: puv_stream_t; Status: integer); cdecl;

  puv_udp_send_t = ^uv_udp_send_t;
  puv_udp_t = ^uv_udp_t;
  puv_write_t = ^uv_write_t;
  uv_udp_send_cb = procedure(req: puv_udp_send_t; Status: integer); cdecl;
  uv_udp_recv_cb = procedure(handle: puv_udp_t; nread: SSIZE_T; buf: puv_buf_t;
    addr: psockaddr; flags: UInt); cdecl;
  uv_alloc_cb = procedure(handle: puv_handle_t; suggested_size: SIZE_T;
    buf: puv_buf_t); cdecl;
  uv_read_cb = procedure(stream: puv_stream_t; nread: SSIZE_T;
    const buf: puv_buf_t); cdecl;
  uv_write_cb = procedure(req: puv_write_t; Status: integer); cdecl;
  puv_poll_t = ^uv_poll_t;
  uv_poll_cb = procedure(handle: puv_poll_t; Status: integer;
    Events: integer); cdecl;
  puv_timer_t = ^uv_timer_t;
  uv_timer_cb = procedure(handle: puv_timer_t); cdecl;
  puv_prepare_t = ^uv_prepare_t;
  uv_prepare_cb = procedure(handle: puv_prepare_t); cdecl;
  puv_connect_t = ^uv_connect_t;
  uv_connect_cb = procedure(req: puv_connect_t; Status: integer); cdecl;
  puv_check_t = ^uv_check_t;
  uv_check_cb = procedure(handle: puv_check_t); cdecl;
  puv_idle_t = ^uv_idle_t;
  uv_idle_cb = procedure(handle: puv_idle_t); cdecl;
  puv_async_t = ^uv_async_t;
  uv_async_cb = procedure(handle: puv_async_t); cdecl;
  puv_process_t = ^uv_process_t;
  uv_exit_cb = procedure(process: puv_process_t; exit_status: Int64;
    term_signal: integer); cdecl;
  puv_fs_event_t = ^uv_fs_event_t;
  uv_fs_event_cb = procedure(handle: puv_fs_event_t; filename: PUTF8Char;
    Events: integer; Status: integer); cdecl;
  puv_signal_t = ^uv_signal_t;
  uv_signal_cb = procedure(handle: puv_signal_t; signum: integer); cdecl;
  puv_fs_t = ^uv_fs_t;
  uv_fs_cb = procedure(req: puv_fs_t); cdecl;
  puv_work_t = ^uv_work_t;
  uv_work_cb = procedure(req: puv_work_t); cdecl;
  uv_after_work_cb = procedure(req: puv_work_t; Status: integer); cdecl;

  uv_write_s = record
    internal: array [1 .. sizeof_write_t] of Byte;
  end;

  uv_write_t = uv_write_s;

  // puv_pipe_accept_t = ^uv_pipe_accept_t;
  //
  // uv_pipe_accept_t = record
  // internal: array [1 .. sizeof_pipe_accept_t] of Byte;
  // end;

  // puv_tcp_accept_t = ^uv_tcp_accept_t;

  // uv_tcp_accept_t = record
  // internal: array [1 .. sizeof_tcp_accept_t] of Byte;
  // end;

  uv_stream_s = record
    internal: array [1 .. sizeof_stream_t] of Byte;
  end;

  uv_stream_t = uv_stream_s;

  uv_tcp_s = packed record
    internal: array [1 .. sizeof_tcp_t] of Byte;
  end;

  uv_tcp_t = uv_tcp_s;
  puv_tcp_t = ^uv_tcp_t;

  uv_udp_s = record
    internal: array [1 .. sizeof_udp_t] of Byte;
  end;

  uv_udp_t = uv_udp_s;
  // puv_udp_t = ^uv_udp_t;

  uv_pipe_s = packed record
    internal: array [1 .. sizeof_pipe_t] of Byte;
  end;

  uv_pipe_t = uv_pipe_s;
  puv_pipe_t = ^uv_pipe_t;

  uv_tty_s = packed record
    internal: array [1 .. sizeof_tty_t] of Byte;
  end;

  uv_tty_t = uv_tty_s;
  puv_tty_t = ^uv_tty_t;

  uv_poll_s = record
    internal: array [1 .. sizeof_poll_t] of Byte;
  end;

  uv_poll_t = uv_poll_s;
  // puv_poll_t = ^uv_poll_t;

  uv_timer_s = record
    internal: array [1 .. sizeof_timer_t] of Byte;
  end;

  uv_timer_t = uv_timer_s;
  // puv_timer_t = ^uv_timer_t;

  uv_prepare_s = record
    internal: array [1 .. sizeof_prepare_t] of Byte;
  end;

  uv_prepare_t = uv_prepare_s;
  // puv_prepare_t = ^uv_prepare_t;

  uv_check_s = record
    internal: array [1 .. sizeof_check_t] of Byte;
  end;

  uv_check_t = uv_check_s;
  // puv_check_t = ^uv_check_t;

  uv_idle_s = record
    internal: array [1 .. sizeof_idle_t] of Byte;
  end;

  uv_idle_t = uv_idle_s;

  uv_async_s = record
    internal: array [1 .. sizeof_async_t] of Byte;
  end;

  uv_async_t = uv_async_s;
  // puv_async_t = ^uv_async_t;

  uv_process_s = record
    internal: array [1 .. sizeof_process_t] of Byte;
  end;

  uv_process_t = uv_process_s;
  // puv_process_t = ^uv_process_t;

  uv_fs_event_s = record
    internal: array [1 .. sizeof_fs_event_t] of Byte;
  end;

  uv_fs_event_t = uv_fs_event_s;

  uv_fs_poll_s = record
    internal: array [1 .. sizeof_fs_poll_t] of Byte;
  end;

  uv_fs_poll_t = uv_fs_poll_s;
  puv_fs_poll_t = ^uv_fs_poll_t;

  uv_signal_s = record
    internal: array [1 .. sizeof_signal_t] of Byte;
  end;

  uv_signal_t = uv_signal_s;

  uv_getaddrinfo_s = record
    internal: array [1 .. sizeof_addrinfo_t] of Byte;
  end;

  uv_getaddrinfo_t = uv_getaddrinfo_s;
  puv_getaddrinfo_t = ^uv_getaddrinfo_t;

  uv_getnameinfo_s = record
    internal: array [1 .. sizeof_nameinfo_t] of Byte;
  end;

  uv_getnameinfo_t = uv_getnameinfo_s;
  puv_getnameinfo_t = ^uv_getnameinfo_t;

  // puv_shutdown_t = ^uv_shutdown_s;

  uv_shutdown_cb = procedure(req: puv_shutdown_t; Status: integer); cdecl;

  uv_shutdown_s = record
    internal: array [1 .. sizeof_shutdown_t] of Byte;
  end;

  uv_shutdown_t = uv_shutdown_s;

  uv_connect_s = record
    internal: array [1 .. sizeof_connect_t] of Byte;
  end;

  uv_connect_t = uv_connect_s;
  // puv_connect_t = ^uv_connect_t;

  // uv_udp_send_t is a subclass of uv_req_t.
  uv_udp_send_s = record
    internal: array [1 .. sizeof_udp_send_t] of Byte;
  end;

  uv_udp_send_t = uv_udp_send_s;

  uv_fs_type = (UV_FS_UNKNOWN = -1, UV_FS_CUSTOM, UV_FS_OPEN_, UV_FS_CLOSE_,
    UV_FS_READ_, UV_FS_WRITE_, UV_FS_SENDFILE_, UV_FS_STAT_, UV_FS_LSTAT_,
    UV_FS_FSTAT_, UV_FS_FTRUNCATE_, UV_FS_UTIME_, UV_FS_FUTIME_, UV_FS_ACCESS_,
    UV_FS_CHMOD_, UV_FS_FCHMOD_, UV_FS_FSYNC_, UV_FS_FDATASYNC_, UV_FS_UNLINK_,
    UV_FS_RMDIR_, UV_FS_MKDIR_, UV_FS_MKDTEMP_, UV_FS_RENAME_, UV_FS_SCANDIR_,
    UV_FS_LINK_, UV_FS_SYMLINK_, UV_FS_READLINK_, UV_FS_CHOWN_, UV_FS_FCHOWN_,
    UV_FS_LCHOWN_, UV_FS_REALPATH_, UV_FS_COPYFILE_);

  uv_timespec_t = record
    tv_sec: integer;
    tv_nsec: integer;
    function toTimeStamp: Double;
  end;

  uv_stat_t = record
    st_dev: UInt64;
    st_mode: UInt64;
    st_nlink: UInt64;
    st_uid: UInt64;
    st_gid: UInt64;
    st_rdev: UInt64;
    st_ino: UInt64;
    st_size: UInt64;
    st_blksize: UInt64;
    st_blocks: UInt64;
    st_flags: UInt64;
    st_gen: UInt64;
    st_atim: uv_timespec_t;
    st_mtim: uv_timespec_t;
    st_ctim: uv_timespec_t;
    st_birthtim: uv_timespec_t;
  end;

  puv_stat_t = ^uv_stat_t;

  // uv_fs_t is a subclass of uv_req_t.
  uv_fs_s = record
    case Boolean of
      true:
        (internal: array [1 .. sizeof_fs_t] of Byte);
      false:
        (req: uv_req_t;
          fs_type: uv_fs_type;
          loop: puv_loop_t;
          cb: uv_fs_cb;
          result: SSIZE_T;
          ptr: Pointer;
          path: PUTF8Char;
          statbuf: uv_stat_t;);
  end;

  uv_fs_t = uv_fs_s;

  uv_work_s = record
    internal: array [1 .. sizeof_work_t] of Byte;
  end;

  uv_work_t = uv_work_s;

  uv_cpu_times_s = record
    user, nice, sys, idle, irq: UInt64;
  end;

  uv_cpu_info_s = record
    model: PAnsiChar;
    speed: integer;
    cpu_times: uv_cpu_times_s;
  end;

  uv_cpu_info_t = uv_cpu_info_s;
  puv_cpu_info_t = ^uv_cpu_info_t;

  uv_interface_address_s = record
    name: PAnsiChar;
    phys_addr: array [0 .. 5] of Byte;
    is_internal: integer;

    address: record
      case integer of
        0:
          (address4: Tsockaddr_in;);
        1:
          (address6: Tsockaddr_in6;);
    end;

    netmask: record
      case integer of
        0:
          (netmask4: Tsockaddr_in;);
        1:
          (netmask6: Tsockaddr_in6;);
    end;
  end;

  uv_interface_address_t = uv_interface_address_s;
  puv_interface_address_t = ^uv_interface_address_t;

  uv_dirent_s = record
    name: PAnsiChar;
    &type: uv_dirent_type_t;
  end;

  uv_dirent_t = uv_dirent_s;
  puv_dirent_t = ^uv_dirent_t;

  uv_passwd_s = record
    username: PAnsiChar;
    uid, gid: Long;
    shell, homedir: PAnsiChar;
  end;

  uv_passwd_t = uv_passwd_s;
  puv_passwd_t = ^uv_passwd_t;
  uv_loop_option = (UV_LOOP_BLOCK_SIGNAL);

  uv_run_mode = (UV_RUN_DEFAULT = 0, UV_RUN_ONCE, UV_RUN_NOWAIT);

  uv_loop_s = record
    internal: array [1 .. sizeof_loop_t] of Byte;
  end;

  uv_loop_t = uv_loop_s;

function uv_get_constants: Pnodepas_constants;

function UV_ONCE_INIT: uv_once_t;

function uv_version: UInt; cdecl;

function uv_version_string: PUTF8Char; cdecl;

type
  uv_malloc_func = function(size: SIZE_T): Pointer; cdecl;
  uv_realloc_func = function(ptr: Pointer; size: SIZE_T): Pointer; cdecl;
  uv_calloc_func = function(count: SIZE_T; size: SIZE_T): Pointer; cdecl;
  uv_free_func = procedure(ptr: Pointer); cdecl;

function uv_replace_allocator(malloc_func: uv_malloc_func;
  realloc_func: uv_realloc_func; calloc_func: uv_calloc_func;
  free_func: uv_free_func): integer; cdecl;

function uv_default_loop: puv_loop_t; cdecl;

function uv_loop_init(loop: puv_loop_t): integer; cdecl;

function uv_loop_close(loop: puv_loop_t): integer; cdecl;
(*
  * NOTE:
  *  This function is DEPRECATED (to be removed after 0.12), users should
  *  allocate the loop manually and use uv_loop_init instead.
*)

function uv_loop_new: puv_loop_t; cdecl;
(*
  * NOTE:
  *  This function is DEPRECATED (to be removed after 0.12). Users should use
  *  uv_loop_close and free the memory manually instead.
*)

procedure uv_loop_delete(loop: puv_loop_t); cdecl;

function uv_loop_size: SIZE_T; cdecl;

function uv_loop_alive(loop: puv_loop_t): integer; cdecl;

function uv_loop_configure(loop: puv_loop_t; option: uv_loop_option): integer;
  varargs; cdecl;

function uv_run(loop: puv_loop_t; mode: uv_run_mode): integer; cdecl;

procedure uv_stop(loop: puv_loop_t); cdecl;

procedure uv_ref(loop: puv_handle_t); cdecl;

procedure uv_unref(handle: puv_handle_t); cdecl;

function uv_has_ref(const handle: puv_handle_t): integer; cdecl;

procedure uv_update_time(loop: puv_loop_t); cdecl;

function uv_no(loop: puv_loop_t): UInt64; cdecl;

function uv_backend_fd(const loop: puv_loop_t): integer; cdecl;

function uv_backend_timeout(const loop: puv_loop_t): integer; cdecl;

type
  uv_walk_cb = procedure(handle: puv_handle_t; arg: pinteger); cdecl;
  uv_getaddrinfo_cb = procedure(req: puv_getaddrinfo_t; Status: integer;
    res: PAddrInfo); cdecl;
  uv_getnameinfo_cb = procedure(req: puv_getnameinfo_t; Status: integer;
    hostname: PUTF8Char; service: PUTF8Char); cdecl;
  uv_fs_poll_cb = procedure(handle: puv_fs_poll_t; Status: integer;
    prev: puv_stat_t; curr: puv_stat_t); cdecl;

  uv_membership = (UV_LEAVE_GROUP = 0, UV_JOIN_GROUP);

function uv_strerror(err: integer): PAnsiChar; cdecl;

function uv_err_name(err: integer): PAnsiChar; cdecl;

function uv_shutdown(req: puv_shutdown_t; handle: puv_stream_t;
  cb: uv_shutdown_cb): integer; cdecl;

function uv_handle_size(&type: uv_handle_type): SIZE_T; cdecl;

function uv_cancel(req: puv_req_t): integer; cdecl;
function uv_req_size(&type: uv_req_type): SIZE_T; cdecl;
function uv_req_get_data(const req: puv_req_t): Pointer; cdecl;
procedure uv_req_set_data(const req: puv_req_t; data: Pointer); cdecl;
function uv_req_get_type(const req: puv_req_t): uv_req_type; cdecl;
function uv_req_type_name(const req: puv_req_t): PAnsiChar; cdecl;

function uv_is_active(handle: puv_handle_t): integer; cdecl;

procedure uv_walk(loop: puv_loop_t; walk_cb: uv_walk_cb; arg: pinteger); cdecl;
(* Helpers for ad hoc debugging, no API/ABI stability guaranteed. *)

procedure uv_print_all_handles(loop: puv_loop_t; stream: Pointer); cdecl;

procedure uv_print_active_handles(loop: puv_loop_t; stream: Pointer); cdecl;

procedure uv_close(handle: puv_handle_t; close_cb: uv_close_cb); cdecl;

function uv_send_buffer_size(handle: puv_handle_t; value: pinteger)
  : integer; cdecl;

function uv_recv_buffer_size(handle: puv_handle_t; value: pinteger)
  : integer; cdecl;

function uv_fileno(handle: puv_handle_t; var fd: uv_os_fd_t): integer; cdecl;

function uv_buf_init(Base: PByte; len: Cardinal): uv_buf_t;

function uv_listen(stream: puv_stream_t; backlog: integer; cb: uv_connection_cb)
  : integer; cdecl;

function uv_accept(server: puv_stream_t; client: puv_stream_t): integer; cdecl;

function uv_read_start(req: puv_stream_t; alloc_cb: uv_alloc_cb;
  read_cb: uv_read_cb): integer; cdecl;

function uv_read_stop(req: puv_stream_t): integer; cdecl;

function uv_write(req: puv_write_t; handle: puv_stream_t; const bufs: puv_buf_t;
  nbufs: UInt; cb: uv_write_cb): integer; cdecl;

function uv_write2(req: puv_write_t; handle: puv_stream_t;
  const bufs: puv_buf_t; nbufs: UInt; send_handle: puv_stream_t;
  cb: uv_write_cb): integer; cdecl;

function uv_try_write(handle: puv_stream_t; const bufs: puv_buf_t;
  nbufs: UInt): integer;

(* uv_write_t is a subclass of uv_req_t. *)

function uv_is_readable(handle: puv_stream_t): integer; cdecl;

function uv_is_writable(handle: puv_stream_t): integer; cdecl;

function uv_stream_set_blocking(handle: puv_stream_t; blocking: integer)
  : integer; cdecl;

function uv_is_closing(handle: puv_handle_t): integer; cdecl;
(*
  * uv_tcp_t is a subclass of uv_stream_t.
  *
  * Represents a TCP stream or TCP server.
*)

function uv_tcp_init(loop: puv_loop_t; handle: puv_tcp_t): integer; cdecl;

function uv_tcp_init_ex(loop: puv_loop_t; handle: puv_tcp_t; flags: UInt)
  : integer; cdecl;

function uv_tcp_open(handle: puv_tcp_t; sock: uv_os_sock_t): integer; cdecl;

function uv_tcp_nodelay(handle: puv_tcp_t; enable: integer): integer; cdecl;

function uv_tcp_keepalive(handle: puv_tcp_t; enable: integer; delay: UInt)
  : integer; cdecl;

function uv_tcp_simultaneous_accepts(handle: puv_tcp_t; enable: integer)
  : integer; cdecl;

type
  uv_tcp_flags = (
    (* Used with uv_tcp_bind, when an IPv6 address is used. *)
    UV_TCP_IPV6ONLY = 1);

function uv_tcp_bind(handle: puv_tcp_t; const addr: TSockAddr_in_any;
  flags: UInt): integer; cdecl;

function uv_tcp_getsockname(handle: puv_tcp_t; out name: TSockAddr_in_any;
  var namelen: integer): integer; cdecl;

function uv_tcp_getpeername(handle: puv_tcp_t; out name: TSockAddr_in_any;
  var namelen: integer): integer; cdecl;

function uv_tcp_connect(req: puv_connect_t; handle: puv_tcp_t;
  addr: PSockAddr_in_any; cb: uv_connect_cb): integer; cdecl;
(* uv_connect_t is a subclass of uv_req_t. *)

(*
  * UDP support.
*)
const
  // uv_udp_flags = (
  (* Disables dual stack mode. *)
  UV_UDP_IPV6ONLY = 1;
  UV_UDP_PARTIAL = 2;
  (*
    * Indicates message was truncated because read buffer was too small. The
    * remainder was discarded by the OS. Used in uv_udp_recv_cb.
  *)
  UV_UDP_REUSEADDR = 4;
  (*
    * Indicates if SO_REUSEADDR will be set when binding the handle.
    * This sets the SO_REUSEPORT socket flag on the BSDs and OS X. On other
    * Unix platforms, it sets the SO_REUSEADDR flag.  What that means is that
    * multiple threads or processes can bind to the same address without error
    * (provided they all set the flag) but only the last one to bind will receive
    * any traffic, in effect "stealing" the port from the previous listener.
  *)
  // );

  (* uv_udp_t is a subclass of uv_handle_t. *)
  (* uv_udp_send_t is a subclass of uv_req_t. *)

function uv_udp_init(loop: puv_loop_t; handle: puv_udp_t): integer; cdecl;

function uv_udp_init_ex(loop: puv_loop_t; handle: puv_udp_t; flags: UInt)
  : integer; cdecl;

function uv_udp_open(handle: puv_udp_t; sock: uv_os_sock_t): integer; cdecl;

function uv_udp_bind(handle: puv_udp_t; const addr: TSockAddr_in_any;
  flags: UInt): integer; cdecl;

function uv_udp_connect(handle: puv_udp_t; const addr: TSockAddr_in_any)
  : integer; cdecl;

function uv_udp_getsockname(handle: puv_udp_t; name: psockaddr;
  var namelen: integer): integer; cdecl;

function uv_udp_getpeername(handle: puv_udp_t; name: psockaddr;
  var namelen: integer): integer; cdecl;

function uv_udp_get_send_queue_count(const handle: puv_udp_t): SIZE_T;
function uv_udp_get_send_queue_size(const handle: puv_udp_t): SIZE_T;

function uv_udp_set_membership(handle: puv_udp_t; multicast_addr: PUTF8Char;
  interface_addr: PUTF8Char; membership: uv_membership): integer; cdecl;

function uv_udp_set_multicast_loop(handle: puv_udp_t; &on: integer)
  : integer; cdecl;

function uv_udp_set_multicast_ttl(handle: puv_udp_t; ttl: integer)
  : integer; cdecl;

function uv_udp_set_multicast_interface(handle: puv_udp_t;
  interface_addr: PUTF8Char): integer; cdecl;

function uv_udp_set_broadcast(handle: puv_udp_t; &on: integer): integer; cdecl;

function uv_udp_set_ttl(handle: puv_udp_t; ttl: integer): integer; cdecl;

function uv_udp_send(req: puv_udp_send_t; handle: puv_udp_t;
  const bufs: puv_buf_t; nbufs: UInt; addr: psockaddr; send_cb: uv_udp_send_cb)
  : integer; cdecl;

function uv_udp_try_send(handle: puv_udp_t; const bufs: puv_buf_t; nbufs: UInt;
  addr: psockaddr): integer; cdecl;

function uv_udp_recv_start(handle: puv_udp_t; alloc_cb: uv_alloc_cb;
  recv_cb: uv_udp_recv_cb): integer; cdecl;

function uv_udp_recv_stop(handle: puv_udp_t): integer; cdecl;

type
  (*
    * uv_tty_t is a subclass of uv_stream_t.
    *
    * Representing a stream for the console.
  *)
  uv_tty_mode_t = ( (* Initial/normal terminal mode *)
    UV_TTY_MODE_NORMAL,
    (* Raw input mode (On Windows, ENABLE_WINDOW_INPUT is also enabled) *)
    UV_TTY_MODE_RAW,
    (* Binary-safe I/O mode for IPC (Unix-only) *)
    UV_TTY_MODE_IO);

function uv_tty_init(loop: puv_loop_t; tty: puv_tty_t; os_fd: uv_file;
  unused: integer): integer; cdecl;

function uv_tty_set_mode(tty: puv_tty_t; mode: uv_tty_mode_t): integer; cdecl;

function uv_tty_reset_mode: integer; cdecl;

function uv_tty_get_winsize(tty: puv_tty_t; var width, height: integer)
  : integer; cdecl;
function uv_guess_handle(&file: uv_file): uv_handle_type; cdecl;

(*
  * uv_pipe_t is a subclass of uv_stream_t.
  *
  * Representing a pipe stream or pipe server. On Windows this is a Named
  * Pipe. On Unix this is a Unix domain socket.
*)

function uv_pipe_init(loop: puv_loop_t; handle: puv_pipe_t; ipc: integer)
  : integer; cdecl;

function uv_pipe_open(pipe: puv_pipe_t; os_fd: uv_file): integer; cdecl;

function uv_pipe_bind(handle: puv_pipe_t; name: PUTF8Char): integer; cdecl;

procedure uv_pipe_connect(req: puv_connect_t; handle: puv_pipe_t;
  name: PUTF8Char; cb: uv_connect_cb); cdecl;

function uv_pipe_getsockname(handle: puv_pipe_t; buffer: PUTF8Char;
  var size: SIZE_T): integer; cdecl;

function uv_pipe_getpeername(handle: puv_pipe_t; buffer: PUTF8Char;
  var size: SIZE_T): integer; cdecl;

procedure uv_pipe_pending_instances(handle: puv_pipe_t; count: integer); cdecl;

function uv_pipe_pending_count(handle: puv_pipe_t): integer; cdecl;

function uv_pipe_pending_type(handle: puv_pipe_t): uv_handle_type; cdecl;

function uv_pipe_chmod(handle: puv_pipe_t; flags: integer): integer; cdecl;

// type

// uv_poll_event = (UV_READABLE = 1, UV_WRITABLE = 2, UV_DISCONNECT = 4, UV_PRIORITIZED=8);

function uv_poll_init(loop: puv_loop_t; handle: puv_poll_t; fd: integer)
  : integer; cdecl;

function uv_poll_init_socket(loop: puv_loop_t; handle: puv_poll_t;
  socket: uv_os_sock_t): integer; cdecl;

function uv_poll_start(handle: puv_poll_t; Events: integer; cb: uv_poll_cb)
  : integer; cdecl;

function uv_poll_stop(handle: puv_poll_t): integer; cdecl;

function uv_prepare_init(loop: puv_loop_t; prepare: puv_prepare_t)
  : integer; cdecl;

function uv_prepare_start(prepare: puv_prepare_t; cb: uv_prepare_cb)
  : integer; cdecl;

function uv_prepare_stop(prepare: puv_prepare_t): integer; cdecl;

function uv_check_init(loop: puv_loop_t; check: puv_check_t): integer; cdecl;

function uv_check_start(check: puv_check_t; cb: uv_check_cb): integer; cdecl;

function uv_check_stop(check: puv_check_t): integer; cdecl;

function uv_idle_init(loop: puv_loop_t; idle: puv_idle_t): integer; cdecl;

function uv_idle_start(idle: puv_idle_t; cb: uv_idle_cb): integer; cdecl;

function uv_idle_stop(idle: puv_idle_t): integer; cdecl;

function uv_async_init(loop: puv_loop_t; async: puv_async_t;
  async_cb: uv_async_cb): integer; cdecl;

function uv_async_send(async: puv_async_t): integer; cdecl;
(*
  * uv_timer_t is a subclass of uv_handle_t.
  *
  * Used to get woken up at a specified time in the future.
*)

function uv_timer_init(loop: puv_loop_t; handle: puv_timer_t): integer; cdecl;

function uv_timer_start(handle: puv_timer_t; cb: uv_timer_cb; Timeout: UInt64;
  &repeat: UInt64): integer; cdecl;

function uv_timer_stop(handle: puv_timer_t): integer; cdecl;

function uv_timer_again(handle: puv_timer_t): integer; cdecl;

procedure uv_timer_set_repeat(handle: puv_timer_t; &repeat: UInt64); cdecl;

function uv_timer_get_repeat(handle: puv_timer_t): UInt64; cdecl;
(*
  * uv_getaddrinfo_t is a subclass of uv_req_t.
  *
  * Request object for uv_getaddrinfo.
*)

function uv_getaddrinfo(loop: puv_loop_t; req: puv_getaddrinfo_t;
  getaddrinfo_cb: uv_getaddrinfo_cb; const node: PAnsiChar;
  const service: PAnsiChar; hints: PAddrInfo): integer; cdecl;

procedure uv_freeaddrinfo(ai: PAddrInfo); cdecl;
(*
  * uv_getnameinfo_t is a subclass of uv_req_t.
  *
  * Request object for uv_getnameinfo.
*)
function uv_getnameinfo(loop: puv_loop_t; req: puv_getnameinfo_t;
  getnameinfo_cb: uv_getnameinfo_cb; addr: psockaddr; flags: integer)
  : integer; cdecl;
(* uv_spawn() options. *)
{ !!!3 unknown typedef }

(*
  * These are the flags that can be used for the uv_process_options.flags field.
*)
type
  uv_process_flags = (
    (*
      * Set the child process' user id. The user id is supplied in the `uid` field
      * of the options struct. This does not work on windows; setting this flag
      * will cause uv_spawn() to fail.
    *)
    UV_PROCESS_SETUID = (1 shl 0), UV_PROCESS_SETGID = (1 shl 1),
    (*
      * Set the child process' group id. The user id is supplied in the `gid`
      * field of the options struct. This does not work on windows setting this
      * flag will cause uv_spawn() to fail.
    *)
    UV_PROCESS_WINDOWS_VERBATIM_ARGUMENTS = (1 shl 2),
    (*
      * Do not wrap any arguments in quotes, or perform any other escaping, when
      * converting the argument list into a command line string. This option is
      * only meaningful on Windows systems. On Unix it is silently ignored.
    *)
    UV_PROCESS_DETACHED = (1 shl 3),
    (*
      * Spawn the child process in a detached state - this will make it a process
      * group leader, and will effectively enable the child to keep running after
      * the parent exits.  Note that the child process will still keep the
      * parent's event loop alive unless the parent process calls uv_unref() on
      * the child's process handle.
    *)
    UV_PROCESS_WINDOWS_HIDE = (1 shl 4)
    (*
      * Hide the subprocess console window that would normally be created. This
      * option is only meaningful on Windows systems. On Unix it is silently
      * ignored.
    *)
    );

  uv_process_flags_set = set of uv_process_flags;

  (*
    * uv_process_t is a subclass of uv_handle_t.
  *)
const
  UV_IGNORE = $00;
  UV_CREATE_PIPE = $01;
  UV_INHERIT_FD = $02;
  UV_INHERIT_STREAM = $04;

  (*
    * When UV_CREATE_PIPE is specified, UV_READABLE_PIPE and UV_WRITABLE_PIPE
    * determine the direction of flow, from the child process' perspective. Both
    * flags may be specified to create a duplex data stream.
  *)
  UV_READABLE_PIPE = $10;
  UV_WRITABLE_PIPE = $20;

type

  v_stdio_flags = Byte;

  uv_stdio_container_s = record
    flags: v_stdio_flags;
    case integer of
      0:
        (stream: puv_stream_t;);
      1:
        (fd: integer;);
  end;
{$POINTERMATH ON}

  puv_stdio_container_t = ^uv_stdio_container_t;
{$POINTERMATH OFF}
  uv_stdio_container_t = uv_stdio_container_s;

  uv_process_options_s = record
    exit_cb: uv_exit_cb; (* Called after the process exits. *)
    &file: PAnsiChar; (* Path to program to execute. *)
    (*
      * Command line arguments. args[0] should be the path to the program. On
      * Windows this uses CreateProcess which concatenates the arguments into a
      * string this can cause some strange errors. See the note at
      * windows_verbatim_arguments.
    *)
    args: PAnsiCharArray;
    (*
      * This will be set as the environ variable in the subprocess. If this is
      * NULL then the parents environ will be used.
    *)
    env: PAnsiCharArray;
    (*
      * If non-null this represents a directory the subprocess should execute
      * in. Stands for current working directory.
    *)
    cwd: PAnsiChar;
    (*
      * Various flags that control how uv_spawn() behaves. See the definition of
      * enum uv_process_flags` below.
    *)
    flags: uv_process_flags_set; // Cardinal;
    (*
      * The `stdio` field points to an array of uv_stdio_container_t structs that
      * describe the file descriptors that will be made available to the child
      * process. The convention is that stdio[0] points to stdin, fd 1 is used for
      * stdout, and fd 2 is stderr.
      *
      * Note that on windows file descriptors greater than 2 are available to the
      * child process only if the child processes uses the MSVCRT runtime.
    *)
    stdio_count: integer;
    stdio: puv_stdio_container_t;
    (*
      * Libuv can change the child process' user/group id. This happens only when
      * the appropriate bits are set in the flags fields. This is not supported on
      * windows; uv_spawn() will fail and set the error to UV_ENOTSUP.
    *)
    uid: uv_uid_t;
    gid: uv_gid_t;

    cpumask: PAnsiChar;
    cpumask_size: SIZE_T;
  end;

  uv_process_options_t = uv_process_options_s;
  puv_process_options_t = ^uv_process_options_t;

function uv_spawn(loop: puv_loop_t; handle: puv_process_t;
  const options: puv_process_options_t): integer; cdecl;

function uv_process_kill(process: puv_process_t; signum: integer)
  : integer; cdecl;

function uv_process_getpid(process: puv_process_t): uv_pid_t; cdecl;

function uv_kill(pid: uv_pid_t; signum: integer): integer; cdecl;
(*
  * uv_work_t is a subclass of uv_req_t.
*)

function uv_queue_work(loop: puv_loop_t; req: puv_work_t; work_cb: uv_work_cb;
  after_work_cb: uv_after_work_cb): integer; cdecl;

function uv_setup_args(argc: integer; argv: PAnsiCharArray)
  : PAnsiCharArray; cdecl;

function uv_get_process_title(buffer: PAnsiChar; size: SIZE_T): integer; cdecl;

function uv_set_process_title(const title: PAnsiChar): integer; cdecl;

function uv_resident_set_memory(rss: psize_t): integer; cdecl;

function uv_uptime(uptime: pdouble): integer; cdecl;

type
  uv_timeval_t = record
    tv_sec: integer;
    tv_usec: integer;
  end;

  puv_timeval_t = ^uv_timeval_t;

  uv_rusage_t = record
    ru_utime: uv_timeval_t; (* user CPU time used *)
    ru_stime: uv_timeval_t; (* system CPU time used *)
    ru_maxrss: UInt64; (* maximum resident set size *)
    ru_ixrss: UInt64; (* integral shared memory size *)
    ru_idrss: UInt64; (* integral unshared data size *)
    ru_isrss: UInt64; (* integral unshared stack size *)
    ru_minflt: UInt64; (* page reclaims (soft page faults) *)
    ru_majflt: UInt64; (* page faults (hard page faults) *)
    ru_nswap: UInt64; (* swaps *)
    ru_inblock: UInt64; (* block input operations *)
    ru_oublock: UInt64; (* block output operations *)
    ru_msgsnd: UInt64; (* IPC messages sent *)
    ru_msgrcv: UInt64; (* IPC messages received *)
    ru_nsignals: UInt64; (* signals received *)
    ru_nvcsw: UInt64; (* voluntary context switches *)
    ru_nivcsw: UInt64; (* involuntary context switches *)
  end;

  puv_rusage_t = ^uv_rusage_t;

function uv_getrusage(rusage: puv_rusage_t): integer; cdecl;

function uv_os_homedir(buffer: PAnsiChar; size: psize_t): integer; cdecl;

function uv_os_tmpdir(buffer: PAnsiChar; size: psize_t): integer; cdecl;

function uv_os_get_passwd(pwd: puv_passwd_t): integer; cdecl;

procedure uv_os_free_passwd(pwd: puv_passwd_t); cdecl;

function uv_os_getpid: uv_pid_t; cdecl;

function uv_cpu_info(var cpu_infos: puv_cpu_info_t; var count: integer)
  : integer; cdecl;

procedure uv_free_cpu_info(cpu_infos: puv_cpu_info_t; count: integer); cdecl;

function uv_interface_addresses(var addresses: puv_interface_address_t;
  var count: integer): integer; cdecl;

procedure uv_free_interface_addresses(addresses: puv_interface_address_t;
  count: integer); cdecl;

procedure uv_fs_req_cleanup(req: puv_fs_t); cdecl;

function uv_fs_get_type(const req: puv_fs_t): uv_fs_type; cdecl;
function uv_fs_get_path(const req: puv_fs_t): PUTF8Char; cdecl;
function uv_fs_get_ptr(const req: puv_fs_t): Pointer; cdecl;
function uv_fs_get_result(const req: puv_fs_t): SSIZE_T; cdecl;
function uv_fs_get_statbuf(const req: uv_fs_t): puv_stat_t; cdecl;

function uv_fs_close(loop: puv_loop_t; req: puv_fs_t; &file: uv_file;
  cb: uv_fs_cb): integer; cdecl;

function uv_fs_open(loop: puv_loop_t; req: puv_fs_t; path: PUTF8Char;
  flags: integer; mode: integer; cb: uv_fs_cb): integer; cdecl;

function uv_fs_read(loop: puv_loop_t; req: puv_fs_t; &file: uv_file;
  bufs: puv_buf_t; nbufs: UInt; offset: Int64; cb: uv_fs_cb): integer; cdecl;

function uv_fs_unlink(loop: puv_loop_t; req: puv_fs_t; path: PUTF8Char;
  cb: uv_fs_cb): integer; cdecl;

function uv_fs_write(loop: puv_loop_t; req: puv_fs_t; &file: uv_file;
  bufs: puv_buf_t; nbufs: UInt; offset: Int64; cb: uv_fs_cb): integer; cdecl;

function uv_fs_mkdir(loop: puv_loop_t; req: puv_fs_t; path: PUTF8Char;
  mode: integer; cb: uv_fs_cb): integer; cdecl;

function uv_fs_mkdtemp(loop: puv_loop_t; req: puv_fs_t; tpl: PUTF8Char;
  cb: uv_fs_cb): integer; cdecl;

function uv_fs_rmdir(loop: puv_loop_t; req: puv_fs_t; path: PUTF8Char;
  cb: uv_fs_cb): integer; cdecl;

function uv_fs_scandir(loop: puv_loop_t; req: puv_fs_t; path: PUTF8Char;
  flags: integer; cb: uv_fs_cb): integer; cdecl;

function uv_fs_scandir_next(req: puv_fs_t; ent: puv_dirent_t): integer; cdecl;

function uv_fs_stat(loop: puv_loop_t; req: puv_fs_t; path: PUTF8Char;
  cb: uv_fs_cb): integer; cdecl;

function uv_fs_fstat(loop: puv_loop_t; req: puv_fs_t; &file: uv_file;
  cb: uv_fs_cb): integer; cdecl;

function uv_fs_rename(loop: puv_loop_t; req: puv_fs_t; const path: PUTF8Char;
  const new_path: PUTF8Char; cb: uv_fs_cb): integer; cdecl;

(*
  * This flag can be used with uv_fs_copyfile() to return an error if the
  * destination already exists.
*)
const
  UV_FS_COPYFILE_EXCL = $1;

  (*
    * This flag can be used with uv_fs_copyfile() to attempt to create a reflink.
    * If copy-on-write is not supported, a fallback copy mechanism is used.
  *)
  UV_FS_COPYFILE_FICLONE = $2;

  (*
    * This flag can be used with uv_fs_copyfile() to attempt to create a reflink.
    * If copy-on-write is not supported, an error is returned.
  *)
  UV_FS_COPYFILE_FICLONE_FORCE = $4;

function uv_fs_copyfile(loop: puv_loop_t; req: puv_fs_t; const path: PUTF8Char;
  const new_path: PUTF8Char; flags: integer; cb: uv_fs_cb): integer; cdecl;

function uv_fs_fsync(loop: puv_loop_t; req: puv_fs_t; &file: uv_file;
  cb: uv_fs_cb): integer; cdecl;

function uv_fs_fdatasync(loop: puv_loop_t; req: puv_fs_t; &file: uv_file;
  cb: uv_fs_cb): integer; cdecl;

function uv_fs_ftruncate(loop: puv_loop_t; req: puv_fs_t; &file: uv_file;
  offset: Int64; cb: uv_fs_cb): integer; cdecl;

function uv_fs_sendfile(loop: puv_loop_t; req: puv_fs_t; out_fd: uv_file;
  in_fd: uv_file; in_offset: Int64; length: SIZE_T; cb: uv_fs_cb)
  : integer; cdecl;

function uv_fs_access(loop: puv_loop_t; req: puv_fs_t; path: PUTF8Char;
  mode: integer; cb: uv_fs_cb): integer; cdecl;

function uv_fs_chmod(loop: puv_loop_t; req: puv_fs_t; path: PUTF8Char;
  mode: integer; cb: uv_fs_cb): integer; cdecl;

function uv_fs_utime(loop: puv_loop_t; req: puv_fs_t; path: PUTF8Char;
  atime: Double; mtime: Double; cb: uv_fs_cb): integer; cdecl;

function uv_fs_futime(loop: puv_loop_t; req: puv_fs_t; &file: uv_file;
  atime: Double; mtime: Double; cb: uv_fs_cb): integer; cdecl;

function uv_fs_lstat(loop: puv_loop_t; req: puv_fs_t; path: PUTF8Char;
  cb: uv_fs_cb): integer; cdecl;

function uv_fs_link(loop: puv_loop_t; req: puv_fs_t; path: PUTF8Char;
  new_path: PUTF8Char; cb: uv_fs_cb): integer; cdecl;

(*
  * This flag can be used with uv_fs_symlink() on Windows to specify whether
  * path argument points to a directory.
*)
const
  UV_FS_SYMLINK_DIR = $0001;
  (*
    * This flag can be used with uv_fs_symlink() on Windows to specify whether
    * the symlink is to be created using junction points.
  *)
  UV_FS_SYMLINK_JUNCTION = $0002;

function uv_fs_symlink(loop: puv_loop_t; req: puv_fs_t; path: PUTF8Char;
  new_path: PUTF8Char; flags: integer; cb: uv_fs_cb): integer; cdecl;

function uv_fs_readlink(loop: puv_loop_t; req: puv_fs_t; path: PUTF8Char;
  cb: uv_fs_cb): integer; cdecl;

function uv_fs_realpath(loop: puv_loop_t; req: puv_fs_t; path: PUTF8Char;
  cb: uv_fs_cb): integer; cdecl;

function uv_fs_fchmod(loop: puv_loop_t; req: puv_fs_t; &file: uv_file;
  mode: integer; cb: uv_fs_cb): integer; cdecl;

function uv_fs_chown(loop: puv_loop_t; req: puv_fs_t; path: PUTF8Char;
  uid: uv_uid_t; gid: uv_gid_t; cb: uv_fs_cb): integer; cdecl;

function uv_fs_fchown(loop: puv_loop_t; req: puv_fs_t; &file: uv_file;
  uid: uv_uid_t; gid: uv_gid_t; cb: uv_fs_cb): integer; cdecl;

type
  uv_fs_event = integer;
  TFS_Event = set of (feRename, feChange);

const
  UV_RENAME = 1;
  UV_CHANGE = 2;

  (*
    * uv_fs_stat() based polling file watcher.
  *)

function uv_fs_poll_init(loop: puv_loop_t; handle: puv_fs_poll_t)
  : integer; cdecl;

function uv_fs_poll_start(handle: puv_fs_poll_t; poll_cb: uv_fs_poll_cb;
  path: PUTF8Char; interval: UInt): integer; cdecl;

function uv_fs_poll_stop(handle: puv_fs_poll_t): integer; cdecl;

function uv_fs_poll_getpath(handle: puv_fs_poll_t; buffer: PUTF8Char;
  size: psize_t): integer; cdecl;

function uv_signal_init(loop: puv_loop_t; handle: puv_signal_t): integer; cdecl;

function uv_signal_start(handle: puv_signal_t; signal_cb: uv_signal_cb;
  signum: integer): integer; cdecl;

function uv_signal_stop(handle: puv_signal_t): integer; cdecl;

type
  uv_loadavg_param = array [0 .. 2] of Double;
procedure uv_loadavg(avg: uv_loadavg_param); cdecl;

type
  (*
    * Flags to be passed to uv_fs_event_start().
  *)
  uv_fs_event_flags = ( (*
      * By default, if the fs event watcher is given a directory name, we will
      * watch for all events in that directory. This flags overrides this behavior
      * and makes fs_event report only changes to the directory entry itself. This
      * flag does not affect individual files watched.
      * This flag is currently not implemented yet on any backend.
    *)
    UV_FS_EVENT_WATCH_ENTRY = 1, UV_FS_EVENT_STAT = 2,
    (*
      * By default uv_fs_event will try to use a kernel interface such as inotify
      * or kqueue to detect events. This may not work on remote filesystems such
      * as NFS mounts. This flag makes fs_event fall back to calling stat() on a
      * regular interval.
      * This flag is currently not implemented yet on any backend.
    *)
    UV_FS_EVENT_RECURSIVE = 4
    (*
      * By default, event watcher, when watching directory, is not registering
      * (is ignoring) changes in it's subdirectories.
      * This flag will override this behaviour on platforms that support it.
    *)
    );

function uv_fs_event_init(loop: puv_loop_t; handle: puv_fs_event_t)
  : integer; cdecl;

function uv_fs_event_start(handle: puv_fs_event_t; cb: uv_fs_event_cb;
  path: PUTF8Char; flags: UInt): integer; cdecl;

function uv_fs_event_stop(handle: puv_fs_event_t): integer; cdecl;

function uv_fs_event_getpath(handle: puv_fs_event_t; buffer: PUTF8Char;
  var size: SIZE_T): integer; cdecl;

function uv_get_osfhandle(fd: uv_file): uv_os_fd_t; inline;

function uv_ip4_addr(ip: PAnsiChar; Port: integer; out addr: Tsockaddr_in)
  : integer; cdecl;

function uv_ip6_addr(ip: PAnsiChar; Port: integer; out addr: Tsockaddr_in6)
  : integer; cdecl;

function uv_ip4_name(src: PSockAddr_In; dst: PAnsiChar; size: SIZE_T)
  : integer; cdecl;

function uv_get_ip_port(src: PSockAddr_In): word;
procedure uv_set_ip_port(src: PSockAddr_In; Port: word);

function uv_ip6_name(src: psockaddr_In6; dst: PAnsiChar; size: SIZE_T)
  : integer; cdecl;

function uv_inet_ntop(af: integer; src: pinteger; dst: PAnsiChar; size: SIZE_T)
  : integer; cdecl;

function uv_inet_pton(af: integer; src: PAnsiChar; out dst): integer; cdecl;

function uv_exepath(buffer: PUTF8Char; size: psize_t): integer; cdecl;

function uv_cwd(buffer: PUTF8Char; size: psize_t): integer; cdecl;

function uv_chdir(dir: PUTF8Char): integer; cdecl;

function uv_get_free_memory: UInt64; cdecl;

function uv_get_total_memory: UInt64; cdecl;

function uv_hrtime: UInt64; cdecl;

procedure uv_disable_stdio_inheritance; cdecl;

function uv_dlopen(filename: PUTF8Char; lib: puv_lib_t): integer; cdecl;

procedure uv_dlclose(lib: puv_lib_t); cdecl;

function uv_dlsym(lib: puv_lib_t; name: PUTF8Char; var ptr: Pointer)
  : integer; cdecl;

function uv_dlerror(lib: puv_lib_t): PUTF8Char; cdecl;

function uv_mutex_init(handle: puv_mutex_t): integer; cdecl;

procedure uv_mutex_destroy(handle: puv_mutex_t); cdecl;

procedure uv_mutex_lock(handle: puv_mutex_t); cdecl;

function uv_mutex_trylock(handle: puv_mutex_t): integer; cdecl;

procedure uv_mutex_unlock(handle: puv_mutex_t); cdecl;

function uv_rwlock_init(rwlock: puv_rwlock_t): integer; cdecl;

procedure uv_rwlock_destroy(rwlock: puv_rwlock_t); cdecl;

procedure uv_rwlock_rdlock(rwlock: puv_rwlock_t); cdecl;

function uv_rwlock_tryrdlock(rwlock: puv_rwlock_t): integer; cdecl;

procedure uv_rwlock_rdunlock(rwlock: puv_rwlock_t); cdecl;

procedure uv_rwlock_wrlock(rwlock: puv_rwlock_t); cdecl;

function uv_rwlock_trywrlock(rwlock: puv_rwlock_t): integer; cdecl;

procedure uv_rwlock_wrunlock(rwlock: puv_rwlock_t); cdecl;

function uv_sem_init(sem: puv_sem_t; value: UInt): integer; cdecl;

procedure uv_sem_destroy(sem: puv_sem_t); cdecl;

procedure uv_sem_post(sem: puv_sem_t); cdecl;

procedure uv_sem_wait(sem: puv_sem_t); cdecl;

function uv_sem_trywait(sem: puv_sem_t): integer; cdecl;

function uv_cond_init(cond: puv_cond_t): integer; cdecl;

procedure uv_cond_destroy(cond: puv_cond_t); cdecl;

procedure uv_cond_signal(cond: puv_cond_t); cdecl;

procedure uv_cond_broadcast(cond: puv_cond_t); cdecl;

function uv_barrier_init(barrier: puv_barrier_t; count: UInt): integer; cdecl;

procedure uv_barrier_destroy(barrier: puv_barrier_t); cdecl;

function uv_barrier_wait(barrier: puv_barrier_t): integer; cdecl;

procedure uv_cond_wait(cond: puv_cond_t; mutex: puv_mutex_t); cdecl;

function uv_cond_timedwait(cond: puv_cond_t; mutex: puv_mutex_t;
  Timeout: UInt64): integer; cdecl;

type
  TOnceProcedure = procedure; cdecl;

procedure uv_once(guard: puv_once_t; callback: TOnceProcedure)cdecl;

function uv_key_create(key: puv_key_t): integer; cdecl;

procedure uv_key_delete(key: puv_key_t); cdecl;

procedure uv_key_get(key: puv_key_t); cdecl;

procedure uv_key_set(key: puv_key_t; value: pinteger); cdecl;

type
  uv_thread_cb = procedure(arg: Pointer); cdecl;

function uv_thread_create(tid: puv_thread_t; entry: uv_thread_cb; arg: Pointer)
  : integer; cdecl;

function uv_thread_self: uv_thread_t; cdecl;

function uv_thread_join(tid: puv_thread_t): integer; cdecl;

function uv_thread_equal(t1: puv_thread_t; t2: puv_thread_t): integer; cdecl;
(* The presence of these unions force similar struct layout. *)

function uv_rwlock_size(): SIZE_T; cdecl;
function uv_cond_size(): SIZE_T; cdecl;
function uv_barrier_size(): SIZE_T; cdecl;
function uv_sem_size(): SIZE_T; cdecl;
function uv_mutex_size(): SIZE_T; cdecl;
function uv_os_sock_size(): SIZE_T; cdecl;
function uv_os_fd_size(): SIZE_T; cdecl;
function uv_tcp_accept_size(): SIZE_T; cdecl;
function uv_pipe_accept_size(): SIZE_T; cdecl;
// function uv_buf_size() : SIZE_T; cdecl;

procedure uv_set_close_cb(h: puv_handle_t; close_cb: uv_close_cb); cdecl;
function uv_get_close_cb(h: puv_handle_t): uv_close_cb; cdecl;

function uv_get_handle_type(h: puv_handle_t): uv_handle_type; cdecl;
procedure uv_set_user_data(h: Pointer; data: Pointer); cdecl;
function uv_get_user_data(h: Pointer): Pointer; cdecl;
function uv_get_req_type(t: puv_req_t): uv_req_type; cdecl;
// function uv_process_options_size : SIZE_T; cdecl;
function uv_get_process_pid(h: puv_process_t): integer; cdecl;

function uv_now(loop: puv_loop_t): UInt64; cdecl;

// procedure WakeupLoop(loop: puv_loop_t);
// procedure uv_buf_set(var buf:uv_buf_t; base:PByte; len: Cardinal); cdecl;

function np_error(err: integer): string;
function IsIP(const ip: UTF8String): integer;
function IsIPv4(const ip: UTF8String): Boolean; inline;
function IsIPv6(const ip: UTF8String): Boolean; inline;

(*
  8
  8
  8
  8                         8 8 8                                  8
  8                        8     8           8 8 88 8             8
  8     8 8 88  8                 8         8        8           8
  88             8        8        8 8 8  88          8
  8    8          8 8 8 88                             8 8 8 88 8

  8

*)

procedure np_ok(res: integer);

implementation

function uv_get_constants; external NODEPAS_LIB;

function uv_version; external LIBUV_FILE;

function uv_version_string; external LIBUV_FILE;

function uv_replace_allocator; external LIBUV_FILE;

function uv_default_loop; external LIBUV_FILE;

function uv_loop_init; external LIBUV_FILE;

function uv_loop_close; external LIBUV_FILE;

function uv_loop_new; external LIBUV_FILE;

procedure uv_loop_delete; external LIBUV_FILE;

function uv_loop_size; external LIBUV_FILE;

function uv_loop_alive; external LIBUV_FILE;

function uv_loop_configure; external LIBUV_FILE;

function uv_run; external LIBUV_FILE;

procedure uv_stop; external LIBUV_FILE;

procedure uv_ref; external LIBUV_FILE;

procedure uv_unref; external LIBUV_FILE;

function uv_has_ref; external LIBUV_FILE;

procedure uv_update_time; external LIBUV_FILE;

function uv_no; external LIBUV_FILE;

function uv_backend_fd; external LIBUV_FILE;

function uv_backend_timeout; external LIBUV_FILE;

function uv_strerror; external LIBUV_FILE;

function uv_err_name; external LIBUV_FILE;

function uv_shutdown; external LIBUV_FILE;

function uv_handle_size; external LIBUV_FILE;

function uv_is_active; external LIBUV_FILE;

procedure uv_walk; external LIBUV_FILE;

procedure uv_print_all_handles; external LIBUV_FILE;

procedure uv_print_active_handles; external LIBUV_FILE;

procedure uv_close; external LIBUV_FILE;

function uv_send_buffer_size; external LIBUV_FILE;

function uv_recv_buffer_size; external LIBUV_FILE;

function uv_fileno; external LIBUV_FILE;

// function uv_buf_init; external LIBUV_FILE;

function uv_listen; external LIBUV_FILE;

function uv_accept; external LIBUV_FILE;

function uv_read_start; external LIBUV_FILE;

function uv_read_stop; external LIBUV_FILE;

function uv_write; external LIBUV_FILE;

function uv_write2; external LIBUV_FILE;

function uv_try_write; external LIBUV_FILE;

function uv_is_readable; external LIBUV_FILE;

function uv_is_writable; external LIBUV_FILE;

function uv_stream_set_blocking; external LIBUV_FILE;

function uv_is_closing; external LIBUV_FILE;

function uv_tcp_init; external LIBUV_FILE;

function uv_tcp_init_ex; external LIBUV_FILE;

function uv_tcp_open; external LIBUV_FILE;

function uv_tcp_nodelay; external LIBUV_FILE;

function uv_tcp_keepalive; external LIBUV_FILE;

function uv_tcp_simultaneous_accepts; external LIBUV_FILE;

function uv_tcp_bind; external LIBUV_FILE;

function uv_tcp_getsockname; external LIBUV_FILE;

function uv_tcp_getpeername; external LIBUV_FILE;

function uv_tcp_connect; external LIBUV_FILE;
function uv_udp_init; external LIBUV_FILE;

function uv_udp_init_ex; external LIBUV_FILE;

function uv_udp_open; external LIBUV_FILE;

function uv_udp_bind; external LIBUV_FILE;

function uv_udp_connect; external LIBUV_FILE;
function uv_udp_getpeername; external LIBUV_FILE;
function uv_udp_getsockname; external LIBUV_FILE;
function uv_udp_get_send_queue_count; external LIBUV_FILE;
function uv_udp_get_send_queue_size; external LIBUV_FILE;

function uv_udp_set_membership; external LIBUV_FILE;

function uv_udp_set_multicast_loop; external LIBUV_FILE;

function uv_udp_set_multicast_ttl; external LIBUV_FILE;

function uv_udp_set_multicast_interface; external LIBUV_FILE;

function uv_udp_set_broadcast; external LIBUV_FILE;

function uv_udp_set_ttl; external LIBUV_FILE;

function uv_udp_send; external LIBUV_FILE;

function uv_udp_try_send; external LIBUV_FILE;

function uv_udp_recv_start; external LIBUV_FILE;

function uv_udp_recv_stop; external LIBUV_FILE;

function uv_tty_init; external LIBUV_FILE;

function uv_tty_set_mode; external LIBUV_FILE;

function uv_tty_reset_mode; external LIBUV_FILE;

function uv_tty_get_winsize; external LIBUV_FILE;
function uv_guess_handle; external LIBUV_FILE;

function uv_pipe_init; external LIBUV_FILE;

function uv_pipe_open; external LIBUV_FILE;

function uv_pipe_bind; external LIBUV_FILE;

procedure uv_pipe_connect; external LIBUV_FILE;

function uv_pipe_getsockname; external LIBUV_FILE;

function uv_pipe_getpeername; external LIBUV_FILE;

procedure uv_pipe_pending_instances; external LIBUV_FILE;

function uv_pipe_pending_count; external LIBUV_FILE;

function uv_pipe_pending_type; external LIBUV_FILE;

function uv_pipe_chmod; external LIBUV_FILE;

function uv_poll_init; external LIBUV_FILE;

function uv_poll_init_socket; external LIBUV_FILE;

function uv_poll_start; external LIBUV_FILE;

function uv_poll_stop; external LIBUV_FILE;

function uv_prepare_init; external LIBUV_FILE;

function uv_prepare_start; external LIBUV_FILE;

function uv_prepare_stop; external LIBUV_FILE;

function uv_check_init; external LIBUV_FILE;

function uv_check_start; external LIBUV_FILE;

function uv_check_stop; external LIBUV_FILE;

function uv_idle_init; external LIBUV_FILE;

function uv_idle_start; external LIBUV_FILE;

function uv_idle_stop; external LIBUV_FILE;

function uv_async_init; external LIBUV_FILE;

function uv_async_send; external LIBUV_FILE;

function uv_timer_init; external LIBUV_FILE;

function uv_timer_start; external LIBUV_FILE;

function uv_timer_stop; external LIBUV_FILE;

function uv_timer_again; external LIBUV_FILE;

procedure uv_timer_set_repeat; external LIBUV_FILE;

function uv_timer_get_repeat; external LIBUV_FILE;

function uv_getaddrinfo; external LIBUV_FILE;

procedure uv_freeaddrinfo; external LIBUV_FILE;

function uv_getnameinfo; external LIBUV_FILE;

function uv_spawn; external LIBUV_FILE;

function uv_process_kill; external LIBUV_FILE;

function uv_process_getpid; external LIBUV_FILE;

function uv_kill; external LIBUV_FILE;

function uv_queue_work; external LIBUV_FILE;

function uv_cancel; external LIBUV_FILE;
function uv_req_size; external LIBUV_FILE;
function uv_req_get_data; external LIBUV_FILE;
procedure uv_req_set_data; external LIBUV_FILE;
function uv_req_get_type; external LIBUV_FILE;
function uv_req_type_name; external LIBUV_FILE;

function uv_setup_args; external LIBUV_FILE;

function uv_get_process_title; external LIBUV_FILE;

function uv_set_process_title; external LIBUV_FILE;

function uv_resident_set_memory; external LIBUV_FILE;

function uv_uptime; external LIBUV_FILE;

function uv_getrusage; external LIBUV_FILE;

function uv_os_homedir; external LIBUV_FILE;

function uv_os_tmpdir; external LIBUV_FILE;

function uv_os_get_passwd; external LIBUV_FILE;

procedure uv_os_free_passwd; external LIBUV_FILE;

function uv_os_getpid; external LIBUV_FILE;

function uv_cpu_info; external LIBUV_FILE;

procedure uv_free_cpu_info; external LIBUV_FILE;

function uv_interface_addresses; external LIBUV_FILE;

procedure uv_free_interface_addresses; external LIBUV_FILE;

procedure uv_fs_req_cleanup; external LIBUV_FILE;

function uv_fs_get_type; external LIBUV_FILE;
function uv_fs_get_path; external LIBUV_FILE;
function uv_fs_get_ptr; external LIBUV_FILE;
function uv_fs_get_result; external LIBUV_FILE;
function uv_fs_get_statbuf; external LIBUV_FILE;

function uv_fs_close; external LIBUV_FILE;

function uv_fs_open; external LIBUV_FILE;

function uv_fs_read; external LIBUV_FILE;

function uv_fs_unlink; external LIBUV_FILE;

function uv_fs_write; external LIBUV_FILE;

function uv_fs_mkdir; external LIBUV_FILE;

function uv_fs_mkdtemp; external LIBUV_FILE;

function uv_fs_rmdir; external LIBUV_FILE;

function uv_fs_scandir; external LIBUV_FILE;

function uv_fs_scandir_next; external LIBUV_FILE;

function uv_fs_stat; external LIBUV_FILE;

function uv_fs_fstat; external LIBUV_FILE;

function uv_fs_rename; external LIBUV_FILE;

function uv_fs_copyfile; external LIBUV_FILE;

function uv_fs_fsync; external LIBUV_FILE;

function uv_fs_fdatasync; external LIBUV_FILE;

function uv_fs_ftruncate; external LIBUV_FILE;

function uv_fs_sendfile; external LIBUV_FILE;

function uv_fs_access; external LIBUV_FILE;

function uv_fs_chmod; external LIBUV_FILE;

function uv_fs_utime; external LIBUV_FILE;

function uv_fs_futime; external LIBUV_FILE;

function uv_fs_lstat; external LIBUV_FILE;

function uv_fs_link; external LIBUV_FILE;

function uv_fs_symlink; external LIBUV_FILE;

function uv_fs_readlink; external LIBUV_FILE;

function uv_fs_realpath; external LIBUV_FILE;

function uv_fs_fchmod; external LIBUV_FILE;

function uv_fs_chown; external LIBUV_FILE;

function uv_fs_fchown; external LIBUV_FILE;

function uv_fs_poll_init; external LIBUV_FILE;

function uv_fs_poll_start; external LIBUV_FILE;

function uv_fs_poll_stop; external LIBUV_FILE;

function uv_fs_poll_getpath; external LIBUV_FILE;

function uv_signal_init; external LIBUV_FILE;

function uv_signal_start; external LIBUV_FILE;

function uv_signal_stop; external LIBUV_FILE;

procedure uv_loadavg; external LIBUV_FILE;

function uv_fs_event_init; external LIBUV_FILE;

function uv_fs_event_start; external LIBUV_FILE;

function uv_fs_event_stop; external LIBUV_FILE;

function uv_fs_event_getpath; external LIBUV_FILE;

function uv_get_osfhandle(fd: uv_file): uv_os_fd_t;
begin
  result := uv_os_fd_t(fd);
end;

function uv_ip4_addr; external LIBUV_FILE;

function uv_ip6_addr; external LIBUV_FILE;

function uv_ip4_name; external LIBUV_FILE;

function uv_ip6_name; external LIBUV_FILE;

function uv_inet_ntop; external LIBUV_FILE;

function uv_inet_pton; external LIBUV_FILE;

function uv_exepath; external LIBUV_FILE;

function uv_cwd; external LIBUV_FILE;

function uv_chdir; external LIBUV_FILE;

function uv_get_free_memory; external LIBUV_FILE;

function uv_get_total_memory; external LIBUV_FILE;

function uv_hrtime; external LIBUV_FILE;

procedure uv_disable_stdio_inheritance; external LIBUV_FILE;

function uv_dlopen; external LIBUV_FILE;

procedure uv_dlclose; external LIBUV_FILE;

function uv_dlsym; external LIBUV_FILE;

function uv_dlerror; external LIBUV_FILE;

function uv_mutex_init; external LIBUV_FILE;

procedure uv_mutex_destroy; external LIBUV_FILE;

procedure uv_mutex_lock; external LIBUV_FILE;

function uv_mutex_trylock; external LIBUV_FILE;

procedure uv_mutex_unlock; external LIBUV_FILE;

function uv_rwlock_init; external LIBUV_FILE;

procedure uv_rwlock_destroy; external LIBUV_FILE;

procedure uv_rwlock_rdlock; external LIBUV_FILE;

function uv_rwlock_tryrdlock; external LIBUV_FILE;

procedure uv_rwlock_rdunlock; external LIBUV_FILE;

procedure uv_rwlock_wrlock; external LIBUV_FILE;

function uv_rwlock_trywrlock; external LIBUV_FILE;

procedure uv_rwlock_wrunlock; external LIBUV_FILE;

function uv_sem_init; external LIBUV_FILE;

procedure uv_sem_destroy; external LIBUV_FILE;

procedure uv_sem_post; external LIBUV_FILE;

procedure uv_sem_wait; external LIBUV_FILE;

function uv_sem_trywait; external LIBUV_FILE;

function uv_cond_init; external LIBUV_FILE;

procedure uv_cond_destroy; external LIBUV_FILE;

procedure uv_cond_signal; external LIBUV_FILE;

procedure uv_cond_broadcast; external LIBUV_FILE;

function uv_barrier_init; external LIBUV_FILE;

procedure uv_barrier_destroy; external LIBUV_FILE;

function uv_barrier_wait; external LIBUV_FILE;

procedure uv_cond_wait; external LIBUV_FILE;

function uv_cond_timedwait; external LIBUV_FILE;

procedure uv_once; external LIBUV_FILE;

function uv_key_create; external LIBUV_FILE;

procedure uv_key_delete; external LIBUV_FILE;

procedure uv_key_get; external LIBUV_FILE;

procedure uv_key_set; external LIBUV_FILE;

function uv_thread_create; external LIBUV_FILE;

function uv_thread_self; external LIBUV_FILE;

function uv_thread_join; external LIBUV_FILE;

function uv_thread_equal; external LIBUV_FILE;

function uv_rwlock_size; external LIBUV_FILE;
function uv_cond_size; external LIBUV_FILE;
function uv_barrier_size; external LIBUV_FILE;
function uv_sem_size; external LIBUV_FILE;
function uv_mutex_size; external LIBUV_FILE;
function uv_os_sock_size; external LIBUV_FILE;
function uv_os_fd_size; external LIBUV_FILE;
function uv_tcp_accept_size; external LIBUV_FILE;
function uv_pipe_accept_size; external LIBUV_FILE;
// function uv_buf_size; external LIBUV_FILE;
// function uv_process_options_size; external LIBUV_FILE;

procedure uv_set_close_cb; external LIBUV_FILE;
function uv_get_close_cb; external LIBUV_FILE;
function uv_get_handle_type; external LIBUV_FILE;
procedure uv_set_user_data; external LIBUV_FILE;
function uv_get_user_data; external LIBUV_FILE;
function uv_get_req_type; external LIBUV_FILE;

function uv_get_process_pid; external LIBUV_FILE;

function uv_now; external LIBUV_FILE;

// procedure uv_buf_set; external LIBUV_FILE;

function uv_buf_init(Base: PByte; len: Cardinal): uv_buf_t;
begin
  result.len := len;
  result.Base := Base;
end;

function malloc_func(size: SIZE_T): Pointer; cdecl;
begin
  GetMem(result, size);
end;

function realloc_func(ptr: Pointer; size: SIZE_T): Pointer; cdecl;
begin
  result := ptr;
  ReallocMem(result, size);
end;

function calloc_func(count: SIZE_T; size: SIZE_T): Pointer; cdecl;
begin
  result := malloc_func(size * count);
end;

procedure free_func(ptr: Pointer); cdecl;
begin
  FreeMem(ptr);
end;

// procedure __async_cb(async: puv_async_t);cdecl;
// begin
// //Dispose(async);
// end;
//
// procedure WakeupLoop(loop: puv_loop_t);
// var
// dlawup: puv_async_t;
// begin
// new(dlawup);
// uv_async_init(loop, @dlawup, @__async_cb);
// uv_async_send(@dlawup);
// end;
{$Q-,O+}
// function _octal(oct:integer) : integer;
// var
// o1,o2,o3: integer;
// begin
/// /  result := 0;
/// /  o := 0;
/// /  while oct > 0 do
/// /  begin
/// /    tmp := oct mod 10 and 7;
/// /    o := (o shl 3) or tmp;
/// /    oct := oct div 10;
/// /  end;
/// /  while o > 0 do
/// /  begin
/// /    result := result shl 3;
/// /    result := result or (o and 7);
/// /    o := o shr 3;
/// /  end;
// o1 := (oct mod 10) and 7;
// o2 := (oct div 10 mod 10) and 7;
// o3 := (oct div 100 mod 10) and 7;
// result := o1 or (o2 shl 3) or (o3 shl 6);
// end;

function np_error(err: integer): string;
begin
  result := uv_err_name(err) + ' (' + IntToStr(err) + ') : ' + uv_strerror(err);

end;

{ EDUVException }

constructor ENPException.Create(err: integer);
begin
  errCode := err;
  errName := uv_err_name(err);
  inherited Create(uv_strerror(err));
end;

procedure np_ok(res: integer);
begin
  if res <> 0 then
    raise ENPException.Create(res);
end;

function uv_get_ip_port(src: PSockAddr_In): word;
begin
  assert(src <> nil);
  result := ntohs(src.sin_port);
end;

procedure uv_set_ip_port(src: PSockAddr_In; Port: word);
begin
  src.sin_port := htons(Port);
end;

function IsIP(const ip: UTF8String): integer;
var
  addr: TSockAddr_in_any;
begin
  if ip = '' then
    exit(0);
  result := 0;
  if (uv_inet_pton(AF_INET, PUTF8Char(ip), addr) = 0) then
    result := 4
  else if (uv_inet_pton(AF_INET6, PUTF8Char(ip), addr) = 0) then
    result := 6;
end;

function IsIPv4(const ip: UTF8String): Boolean; inline;
begin
  result := IsIP(ip) = 4;
end;

function IsIPv6(const ip: UTF8String): Boolean; inline;
begin
  result := IsIP(ip) = 6;
end;

{ uv_sockAddr }

procedure uv_sockAddr.Assign(addr: PSockAddr_in_any);
begin
  self := default (uv_sockAddr);
  if assigned(addr) then
  begin
    if addr.ip4.sin_family = UV_AF_INET then
      sa.ip4 := addr.ip4
    else if addr.ip4.sin_family = UV_AF_INET6 then
      sa.ip6 := addr.ip6;
  end;
end;

class function uv_sockAddr.Create(const Aaddr: UTF8String; Aport: word)
  : uv_sockAddr;
begin
  result.Init(Aaddr, Aport);
end;

function uv_sockAddr.GetAddr: UTF8String;
var
  nameBuf: array [0 .. 128] of UTF8Char;
begin
  case sa.ip4.sin_family of
    UV_AF_INET:
      begin
        np_ok(uv_ip4_name(PSockAddr_In(@sa), @nameBuf, sizeof(nameBuf)));
        result := UTF8String(PUTF8Char(@nameBuf));
      end;
    UV_AF_INET6:
      begin
        np_ok(uv_ip6_name(psockaddr_In6(@sa), @nameBuf, sizeof(nameBuf)));
        result := UTF8String(PUTF8Char(@nameBuf));
      end;
  else
    assert(false);
  end;

end;

function uv_sockAddr.GetPort: word;
begin
  result := ntohs(sa.ip4.sin_port);
end;

procedure uv_sockAddr.Init(const Aaddr: UTF8String; Aport: word);
begin
  self := default (uv_sockAddr);
  Port := Aport;
  addr := Aaddr;
end;

function uv_sockAddr.isIP6: Boolean;
begin
  result := sa.ip4.sin_family = UV_AF_INET6;
end;

procedure uv_sockAddr.SetAddr(const Aaddr: UTF8String);
begin
  if uv_ip4_addr(PUTF8Char(Aaddr), GetPort, sa.ip4) < 0 then
    np_ok(uv_ip6_addr(PUTF8Char(Aaddr), GetPort, sa.ip6));
end;

procedure uv_sockAddr.SetPort(Aport: word);
begin
  sa.ip4.sin_port := htons(Aport);
end;

function uv_sockAddr.ToString: String;
begin
  if isIP6 then
    result := Format('[%s]:%u', [addr, Port])
  else
    result := Format('%s:%u', [addr, Port]);
end;

function UV_ONCE_INIT: uv_once_t;
begin
  result := default (uv_once_t);
end;

{ uv_timespec_t }

function uv_timespec_t.toTimeStamp: Double;
begin
  result := Int64(tv_sec) * 1000 + tv_nsec / 1000000;
end;

initialization

IsMultiThread := true;
uv_replace_allocator(malloc_func, realloc_func, calloc_func, free_func);

finalization

end.
