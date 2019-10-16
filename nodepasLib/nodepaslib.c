#include <stdio.h>
#include <stdlib.h>
#include "nodepaslib.h"
#include "http_parser.h"

/*
size_t uv_tcp_accept_size() {
   return sizeof(uv_tcp_accept_t);
}
size_t uv_pipe_accept_size() {
   return sizeof(uv_pipe_accept_t);
}
*/

size_t uv_process_options_size() {
  return sizeof( uv_process_options_t );
}

size_t uv_rwlock_size() {
   return sizeof(uv_rwlock_t);
}

size_t uv_cond_size() {
   return sizeof(uv_cond_t);
}

size_t uv_barrier_size() {
   return sizeof(uv_barrier_t);
}

size_t uv_sem_size() {
  return sizeof(uv_sem_t);
}

size_t uv_mutex_size(void) {
  return sizeof(uv_mutex_t);
}

size_t uv_os_sock_size(void) {
  return sizeof( uv_os_sock_t );
}

size_t uv_os_fd_size(void) {
  return sizeof( uv_os_fd_t );
}

void uv_set_close_cb(uv_handle_t*h, uv_close_cb close_cb) {
  h->close_cb = close_cb;
}

uv_close_cb uv_get_close_cb(uv_handle_t*h) {
  return(h->close_cb);
}


uv_handle_type uv_get_handle_type(uv_handle_t*h) {
  return h->type;
}

void uv_set_user_data(uv_handle_t* h, void*data) {
   h->data = data;
}

void* uv_get_user_data(uv_handle_t* h) {
  return ( h->data );
}

uv_req_type uv_get_req_type(uv_req_t* r) {
  return (r->type);
}

NP_API int uv_get_process_pid(uv_process_t*h) {
   return (h->pid);
}

//NP_API uv_version_string_ = uv_version_string;
/*
  uv_exit_cb exit_cb;
  const char* file;
  char** args;
  char** env;
  const char* cwd;
  unsigned int flags;
  int stdio_count;
  uv_stdio_container_t* stdio;
  uv_uid_t uid;
  uv_gid_t gid;
  char* cpumask;
  size_t cpumask_size;
*/

NP_API void uv_init_process_options(uv_process_options_t * po,
                                    uv_exit_cb exit_cb,
                                    const char* file,
                                    char**args,
                                    char** env,
                                    const char * cwd,
                                    unsigned int flags,
                                    int stdio_count,
                                    uv_stdio_container_t* stdio,
                                    uv_uid_t uid,
                                    uv_gid_t gid,
                                    char* cpumask,
                                    size_t cpumask_size) {

   po->exit_cb = exit_cb;
   po->file = file;
   po->args = args;
   po->env  = env;
   po->cwd  = cwd;
   po->flags = flags;
   po->stdio_count = stdio_count;
   po->stdio = stdio;
   po->uid = uid;
   po->gid = gid;
#ifdef _WINDOWS
   po->cpumask = cpumask;
   po->cpumask_size = cpumask_size;
#endif
}


unsigned int http_parser_get_method(const http_parser * parser) {
   return parser->method;
}

unsigned int http_parser_get_status_code(const http_parser * parser) {
   return parser->status_code;
}

unsigned int http_parser_get_http_errno(const http_parser * parser) {
   return parser->http_errno;
}

unsigned int http_parser_get_http_upgrade(const http_parser * parser) {
   return parser->upgrade;
}

unsigned int http_parser_get_flags(const http_parser * parser) {
   return parser->flags;
}

constants_t constants = {
/* fs open() flags supported on other platforms (or mapped on this platform): */
    UV_FS_O_DIRECT,
    UV_FS_O_DIRECTORY,
    UV_FS_O_DSYNC,
    UV_FS_O_EXLOCK,
    UV_FS_O_NOATIME,
    UV_FS_O_NOCTTY,
    UV_FS_O_NOFOLLOW,
    UV_FS_O_NONBLOCK,
    UV_FS_O_SYMLINK,
    UV_FS_O_SYNC,

/* fs open() flags supported on this platform: */
    UV_FS_O_APPEND,
    UV_FS_O_CREAT,
    UV_FS_O_EXCL,
    UV_FS_O_RANDOM,
    UV_FS_O_RDONLY,
    UV_FS_O_RDWR,
    UV_FS_O_SEQUENTIAL,
    UV_FS_O_SHORT_LIVED,
    UV_FS_O_TEMPORARY,
    UV_FS_O_TRUNC,
    UV_FS_O_WRONLY,

    F_OK,
    R_OK,
    W_OK,
    X_OK
};
pconstants_t uv_get_constants() {
     return &constants;
}
