/* i686-pc-linux-gnu/config.h.  Generated by configure.  */
/* config.h.in.  Generated from configure.in by autoheader.  */


#define GHBN_R_SOLARIS  2
#define GHBN_R_AIX      3
#define GHBN_R_GLIBC    4


/* Define the brk() argument type. */
#define BRK_ARG_TYPE void *

/* Define the brk() return type. */
#define BRK_RET_TYPE int

/* Define if you do not have a high-res. timer & want to use times() instead
   */
/* #undef CORRECT_USING_TIMES */

/* Modern style mcontext_t in MacOSX */
/* #undef DARWIN_MODERN_MCONTEXT */

/* Define if you need to include rpc/types.h to get INADDR_LOOPBACK defined */
/* #undef DEF_INADDR_LOOPBACK_IN_RPC_TYPES_H */

/* Define if you need to include winsock2.h to get INADDR_LOOPBACK defined */
/* #undef DEF_INADDR_LOOPBACK_IN_WINSOCK2_H */

/* Define if you want to disable child waiter thread */
/* #undef DISABLE_CHILD_WAITER_THREAD */

/* Define if you want to disable vfork. */
/* #undef DISABLE_VFORK */

/* Use elib malloc as clib */
/* #undef ELIB_ALLOC_IS_CLIB */

/* Elib sbrk */
/* #undef ELIB_HEAP_SBRK */

/* Define to enable the use of sorted blocks when using elib_malloc */
/* #undef ELIB_SORTED_BLOCKS */

/* Define if you want to enable child waiter thread */
/* #undef ENABLE_CHILD_WAITER_THREAD */

/* Define to enable use of elib_malloc (a malloc() replacement) */
/* #undef ENABLE_ELIB_MALLOC */

/* Define if sbrk()/brk() wrappers can track malloc()s core memory use */
/* #undef ERTS_BRK_WRAPPERS_CAN_TRACK_MALLOC */

/* The only reason ERTS_EMU_CMDLINE_FLAGS exists is to force modification of
   config.h when the emulator command line flags are modified by configure */
#define ERTS_EMU_CMDLINE_FLAGS " -g -O2 -I/home/dale/apps/otp_src_R13B/erts/i686-pc-linux-gnu  -D_LARGEFILE_SOURCE -D_FILE_OFFSET_BITS=64  -D_GNU_SOURCE -g  -D_GNU_SOURCE -I/home/dale/apps/otp_src_R13B/erts/i686-pc-linux-gnu  -D_LARGEFILE_SOURCE -D_FILE_OFFSET_BITS=64  -DUSE_THREADS -D_THREAD_SAFE -D_REENTRANT -D_POSIX_THREAD_SAFE_FUNCTIONS  -Wall -Wstrict-prototypes -Wmissing-prototypes -Wdeclaration-after-statement"

/* Define if you have kernel poll and want to use it */
#define ERTS_ENABLE_KERNEL_POLL 1

/* Define if the hybrid emulator is built */
#define ERTS_HAVE_HYBRID_EMU 1

/* Define if the smp emulator is built */
#define ERTS_HAVE_SMP_EMU 1

/* Define if dlopen() needs to be called before first call to dlerror() */
/* #undef ERTS_NEED_DLOPEN_BEFORE_DLERROR */

/* Define if poll() should be used instead of select() */
#define ERTS_USE_POLL 1

/* Define if __after_morecore_hook can track malloc()s core memory use. */
#define ERTS___AFTER_MORECORE_HOOK_CAN_TRACK_MALLOC 1

/* Define if you want to disable native ethread implementations */
/* #undef ETHR_DISABLE_NATIVE_IMPLS */

/* Define if you have all ethread defines */
#define ETHR_HAVE_ETHREAD_DEFINES 1

/* Define if the pthread.h header file is in pthread/mit directory. */
/* #undef ETHR_HAVE_MIT_PTHREAD_H */

/* Define if you have the pthread_atfork function. */
#define ETHR_HAVE_PTHREAD_ATFORK 1

/* Define if you have the pthread_attr_setguardsize function. */
#define ETHR_HAVE_PTHREAD_ATTR_SETGUARDSIZE 1

/* Define if you have the <pthread.h> header file. */
#define ETHR_HAVE_PTHREAD_H 1

/* Define if you have the pthread_mutexattr_setkind_np function. */
#define ETHR_HAVE_PTHREAD_MUTEXATTR_SETKIND_NP 1

/* Define if you have the pthread_mutexattr_settype function. */
#define ETHR_HAVE_PTHREAD_MUTEXATTR_SETTYPE 1

/* Define if you have the pthread_rwlock_init function. */
#define ETHR_HAVE_PTHREAD_RWLOCK_INIT 1

/* Define if you have the pthread_spin_lock function. */
#define ETHR_HAVE_PTHREAD_SPIN_LOCK 1

/* Define if you have the <sys/time.h> header file. */
#define ETHR_HAVE_SYS_TIME_H 1

/* Define if mutexes should be reinitialized (instead of unlocked) in child at
   fork. */
#define ETHR_INIT_MUTEX_IN_CHILD_AT_FORK 1

/* Define if you want to modify the default stack size */
/* #undef ETHR_MODIFIED_DEFAULT_STACK_SIZE */

/* Define if you have pthreads */
#define ETHR_PTHREADS 1

/* Define to the size of pointers */
#define ETHR_SIZEOF_PTR 4

/* Define if you can safely include both <sys/time.h> and <time.h>. */
#define ETHR_TIME_WITH_SYS_TIME 1

/* Define if you have win32 threads */
/* #undef ETHR_WIN32_THREADS */

/* Define if you want to use clock_gettime to simulate gethrtime */
#define GETHRTIME_WITH_CLOCK_GETTIME 1

/* Define to 1 if you have the <arpa/nameser.h> header file. */
#define HAVE_ARPA_NAMESER_H 1

/* Define to 1 if you have the `brk' function. */
#define HAVE_BRK 1

/* define if clock_gettime() works for getting process time */
/* #undef HAVE_CLOCK_GETTIME */

/* Define if you have a decl of fread that conflicts with int fread */
#define HAVE_CONFLICTING_FREAD_DECLARATION 1

/* Define if you have a putenv() that stores a copy of the key-value pair */
/* #undef HAVE_COPYING_PUTENV */

/* Define to 1 if you have the declaration of `SCTP_ABORT', and to 0 if you
   don't. */
/* #undef HAVE_DECL_SCTP_ABORT */

/* Define to 1 if you have the declaration of `SCTP_ADDR_CONFIRMED', and to 0
   if you don't. */
/* #undef HAVE_DECL_SCTP_ADDR_CONFIRMED */

/* Define to 1 if you have the declaration of `SCTP_ADDR_OVER', and to 0 if
   you don't. */
/* #undef HAVE_DECL_SCTP_ADDR_OVER */

/* Define to 1 if you have the declaration of `SCTP_EOF', and to 0 if you
   don't. */
/* #undef HAVE_DECL_SCTP_EOF */

/* Define to 1 if you have the declaration of `SCTP_SENDALL', and to 0 if you
   don't. */
/* #undef HAVE_DECL_SCTP_SENDALL */

/* Define to 1 if you have the declaration of `SCTP_UNORDERED', and to 0 if
   you don't. */
/* #undef HAVE_DECL_SCTP_UNORDERED */

/* Define to 1 if you have the <dirent.h> header file, and it defines `DIR'.
   */
#define HAVE_DIRENT_H 1

/* Define to 1 if you have the <dlfcn.h> header file. */
#define HAVE_DLFCN_H 1

/* Define to 1 if you have the `dlopen' function. */
#define HAVE_DLOPEN 1

/* Define to 1 if you don't have `vprintf' but do have `_doprnt.' */
/* #undef HAVE_DOPRNT */

/* Define if you have the 'end' symbol */
#define HAVE_END_SYMBOL 1

/* Define to 1 if you have the <fcntl.h> header file. */
#define HAVE_FCNTL_H 1

/* Define to 1 if you have the `finite' function. */
#define HAVE_FINITE 1

/* Define to 1 if you have the `flockfile' function. */
#define HAVE_FLOCKFILE 1

/* Define to 1 if you have the `fork' function. */
#define HAVE_FORK 1

/* Define to 1 if you have the `fpsetmask' function. */
/* #undef HAVE_FPSETMASK */

/* Define to 1 if you have the `fstat' function. */
#define HAVE_FSTAT 1

/* Define if you have fwrite_unlocked */
#define HAVE_FWRITE_UNLOCKED 1

/* Define to 1 if you have a good `getaddrinfo' function. */
/* #undef HAVE_GETADDRINFO */

/* Define to 1 if you have the `gethostbyname2' function. */
#define HAVE_GETHOSTBYNAME2 1

/* Define to flavour of gethostbyname_r */
#define HAVE_GETHOSTBYNAME_R GHBN_R_GLIBC

/* Define to 1 if you have the `gethrtime' function. */
/* #undef HAVE_GETHRTIME */

/* define if gethrvtime() works and uses ioctl() to /proc/self */
/* #undef HAVE_GETHRVTIME_PROCFS_IOCTL */

/* Define to 1 if you have the `getipnodebyaddr' function. */
/* #undef HAVE_GETIPNODEBYADDR */

/* Define to 1 if you have the `getipnodebyname' function. */
/* #undef HAVE_GETIPNODEBYNAME */

/* Define to 1 if you have the `getnameinfo' function. */
#define HAVE_GETNAMEINFO 1

/* Define to 1 if you have the `getpagesize' function. */
#define HAVE_GETPAGESIZE 1

/* Define to 1 if you have the `gmtime_r' function. */
#define HAVE_GMTIME_R 1

/* Define to 1 if you have the <ieeefp.h> header file. */
/* #undef HAVE_IEEEFP_H */

/* Define to 1 if you have the `ieee_handler' function. */
/* #undef HAVE_IEEE_HANDLER */

/* Define if ipv6 is present */
#define HAVE_IN6 1

/* Define to 1 if you have the <inttypes.h> header file. */
#define HAVE_INTTYPES_H 1

/* Early linux used in_addr6 instead of in6_addr, define if you have this */
/* #undef HAVE_IN_ADDR6_STRUCT */

/* Define to 1 if you have the `isinf' function. */
#define HAVE_ISINF 1

/* Define to 1 if you have the `isnan' function. */
#define HAVE_ISNAN 1

/* Define if you have kstat */
/* #undef HAVE_KSTAT */

/* Define to 1 if you have the <langinfo.h> header file. */
#define HAVE_LANGINFO_H 1

/* Define to 1 if you have the `dl' library (-ldl). */
#define HAVE_LIBDL 1

/* Define to 1 if you have the `inet' library (-linet). */
/* #undef HAVE_LIBINET */

/* Define to 1 if you have the `m' library (-lm). */
#define HAVE_LIBM 1

/* Define to 1 if you have the `util' library (-lutil). */
#define HAVE_LIBUTIL 1

/* Define to 1 if you have the <limits.h> header file. */
#define HAVE_LIMITS_H 1

/* Define to 1 if you have the `localtime_r' function. */
#define HAVE_LOCALTIME_R 1

/* Define to 1 if you have the <mach-o/dyld.h> header file. */
/* #undef HAVE_MACH_O_DYLD_H */

/* Define to 1 if you have the <malloc.h> header file. */
#define HAVE_MALLOC_H 1

/* Define to 1 if you have the `mallopt' function. */
#define HAVE_MALLOPT 1

/* Define to 1 if you have the `memcpy' function. */
#define HAVE_MEMCPY 1

/* Define to 1 if you have the `memmove' function. */
#define HAVE_MEMMOVE 1

/* Define to 1 if you have the <memory.h> header file. */
#define HAVE_MEMORY_H 1

/* Define to 1 if you have a working `mmap' system call. */
#define HAVE_MMAP 1

/* Define to 1 if you have the `mremap' function. */
#define HAVE_MREMAP 1

/* Define if setsockopt() accepts multicast options */
#define HAVE_MULTICAST_SUPPORT 1

/* Define to 1 if you have the <ndir.h> header file, and it defines `DIR'. */
/* #undef HAVE_NDIR_H */

/* Define to 1 if you have the <net/errno.h> header file. */
/* #undef HAVE_NET_ERRNO_H */

/* Define to 1 if you have the `nl_langinfo' function. */
#define HAVE_NL_LANGINFO 1

/* Define if you don't have a definition of INADDR_LOOPBACK */
/* #undef HAVE_NO_INADDR_LOOPBACK */

/* Define to 1 if you have the `openpty' function. */
#define HAVE_OPENPTY 1

/* Define to 1 if you have the `posix2time' function. */
/* #undef HAVE_POSIX2TIME */

/* Define to 1 if you have the `pread' function. */
#define HAVE_PREAD 1

/* Define if you have processor_bind functionality */
/* #undef HAVE_PROCESSOR_BIND */

/* Define if you have pset functionality */
/* #undef HAVE_PSET */

/* Define to 1 if you have the <pty.h> header file. */
#define HAVE_PTY_H 1

/* Define if you have putc_unlocked */
#define HAVE_PUTC_UNLOCKED 1

/* Define to 1 if you have the `pwrite' function. */
#define HAVE_PWRITE 1

/* Define to 1 if you have the `res_gethostbyname' function. */
/* #undef HAVE_RES_GETHOSTBYNAME */

/* Define to 1 if you have the `sbrk' function. */
#define HAVE_SBRK 1

/* Define if you have sched_getaffinity/sched_setaffinity */
#define HAVE_SCHED_xETAFFINITY 1

/* Define to 1 if you have the <netinet/sctp.h> header file */
/* #undef HAVE_SCTP_H */

/* Define to 1 if you have the `setlocale' function. */
#define HAVE_SETLOCALE 1

/* Define to 1 if you have the `setsid' function. */
#define HAVE_SETSID 1

/* Define if we have socklen_t */
#define HAVE_SOCKLEN_T 1

/* define if you have the Solaris/ultrasparc /dev/perfmon interface */
/* #undef HAVE_SOLARIS_SPARC_PERFMON */

/* Define if you have SO_BSDCOMPAT flag on sockets */
#define HAVE_SO_BSDCOMPAT 

/* Define to 1 if you have the <stdint.h> header file. */
#define HAVE_STDINT_H 1

/* Define to 1 if you have the <stdlib.h> header file. */
#define HAVE_STDLIB_H 1

/* Define to 1 if you have the `strerror' function. */
#define HAVE_STRERROR 1

/* Define to 1 if you have the `strerror_r' function. */
#define HAVE_STRERROR_R 1

/* Define to 1 if you have the <strings.h> header file. */
#define HAVE_STRINGS_H 1

/* Define to 1 if you have the <string.h> header file. */
#define HAVE_STRING_H 1

/* Define to 1 if you have the `strlcat' function. */
/* #undef HAVE_STRLCAT */

/* Define to 1 if you have the `strlcpy' function. */
/* #undef HAVE_STRLCPY */

/* Define to 1 if you have the `strncasecmp' function. */
#define HAVE_STRNCASECMP 1

/* Define to 1 if `spp_flags' is member of `struct sctp_paddrparams'. */
/* #undef HAVE_STRUCT_SCTP_PADDRPARAMS_SPP_FLAGS */

/* Define to 1 if `spp_pathmtu' is member of `struct sctp_paddrparams'. */
/* #undef HAVE_STRUCT_SCTP_PADDRPARAMS_SPP_PATHMTU */

/* Define to 1 if `spp_sackdelay' is member of `struct sctp_paddrparams'. */
/* #undef HAVE_STRUCT_SCTP_PADDRPARAMS_SPP_SACKDELAY */

/* Define to 1 if `sre_data' is member of `struct sctp_remote_error'. */
/* #undef HAVE_STRUCT_SCTP_REMOTE_ERROR_SRE_DATA */

/* Define to 1 if `ssf_data' is member of `struct sctp_send_failed'. */
/* #undef HAVE_STRUCT_SCTP_SEND_FAILED_SSF_DATA */

/* Define to 1 if you have the <syslog.h> header file. */
#define HAVE_SYSLOG_H 1

/* Define if you have <sys/devpoll.h> header file. */
/* #undef HAVE_SYS_DEVPOLL_H */

/* Define to 1 if you have the <sys/dir.h> header file, and it defines `DIR'.
   */
/* #undef HAVE_SYS_DIR_H */

/* Define if you have the <sys/epoll.h> header file. */
#define HAVE_SYS_EPOLL_H 1

/* Define if you have <sys/event.h> header file. */
/* #undef HAVE_SYS_EVENT_H */

/* Define to 1 if you have the <sys/ioctl.h> header file. */
#define HAVE_SYS_IOCTL_H 1

/* Define to 1 if you have the <sys/ndir.h> header file, and it defines `DIR'.
   */
/* #undef HAVE_SYS_NDIR_H */

/* Define to 1 if you have the <sys/socketio.h> header file. */
/* #undef HAVE_SYS_SOCKETIO_H */

/* Define to 1 if you have the <sys/socket.h> header file. */
#define HAVE_SYS_SOCKET_H 1

/* Define to 1 if you have the <sys/sockio.h> header file. */
/* #undef HAVE_SYS_SOCKIO_H */

/* Define to 1 if you have the <sys/stat.h> header file. */
#define HAVE_SYS_STAT_H 1

/* Define to 1 if you have the <sys/stropts.h> header file. */
#define HAVE_SYS_STROPTS_H 1

/* Define to 1 if you have the <sys/sysctl.h> header file. */
#define HAVE_SYS_SYSCTL_H 1

/* Define to 1 if you have the <sys/time.h> header file. */
#define HAVE_SYS_TIME_H 1

/* Define to 1 if you have the <sys/types.h> header file. */
#define HAVE_SYS_TYPES_H 1

/* Define to 1 if you have the <sys/uio.h> header file. */
#define HAVE_SYS_UIO_H 1

/* Define to 1 if you have <sys/wait.h> that is POSIX.1 compatible. */
#define HAVE_SYS_WAIT_H 1

/* Define if termcap functions exists */
#define HAVE_TERMCAP 1

/* Define to 1 if you have the <unistd.h> header file. */
#define HAVE_UNISTD_H 1

/* Define to 1 if you have the <util.h> header file. */
/* #undef HAVE_UTIL_H */

/* Define to 1 if you have the <utmp.h> header file. */
#define HAVE_UTMP_H 1

/* Define to 1 if you have the `vfork' function. */
#define HAVE_VFORK 1

/* Define to 1 if you have the <vfork.h> header file. */
/* #undef HAVE_VFORK_H */

/* Define to 1 if you have the `vprintf' function. */
#define HAVE_VPRINTF 1

/* Define to 1 if `fork' works. */
#define HAVE_WORKING_FORK 1

/* Define if you have a working posix_openpt implementation */
#define HAVE_WORKING_POSIX_OPENPT 1

/* Define to 1 if `vfork' works. */
#define HAVE_WORKING_VFORK 1

/* Define to 1 if you have the `writev' function. */
#define HAVE_WRITEV 1

/* Define to 1 if you have the `_brk' function. */
/* #undef HAVE__BRK */

/* Define if you have the '_end' symbol */
#define HAVE__END_SYMBOL 1

/* Define to 1 if you have the `_sbrk' function. */
/* #undef HAVE__SBRK */

/* Define to 1 if you have the `__brk' function. */
/* #undef HAVE___BRK */

/* Define to 1 if you have the `__sbrk' function. */
#define HAVE___SBRK 1

/* Define to enable HiPE */
#define HIPE 1

/* define if h_errno is declared (in some way) in a system header file */
#define H_ERRNO_DECLARED 1

/* Define if netdb.h needs struct sockaddr_in ans in.h CAN be included before
   */
#define NETDB_H_NEEDS_IN_H 1

/* Define if you don't want the fix allocator in Erlang */
/* #undef NO_FIX_ALLOC */

/* Define if floating points exceptions are non-existing/not reliable */
/* #undef NO_FPE_SIGNALS */

/* Defined if no found C compiler can handle jump tables */
/* #undef NO_JUMP_TABLE */

/* Obscure SYSV feature */
/* #undef NO_PRAGMA_WEAK */

/* Define if you dont have salen */
#define NO_SA_LEN 1

/* Define to the address where bug reports for this package should be sent. */
#define PACKAGE_BUGREPORT ""

/* Define to the full name of this package. */
#define PACKAGE_NAME ""

/* Define to the full name and version of this package. */
#define PACKAGE_STRING ""

/* Define to the one symbol short name of this package. */
#define PACKAGE_TARNAME ""

/* Define to the version of this package. */
#define PACKAGE_VERSION ""

/* Define to 1 if the C compiler supports function prototypes. */
#define PROTOTYPES 1

/* Define if you wish to redefine FD_SETSIZE to be able to select on more fd
   */
/* #undef REDEFINE_FD_SETSIZE */

/* Define as the return type of signal handlers (`int' or `void'). */
#define RETSIGTYPE void

/* Define the sbrk() argument type. */
#define SBRK_ARG_TYPE intptr_t

/* Define the sbrk() return type. */
#define SBRK_RET_TYPE void *

/* Define to 1 if the `setvbuf' function takes the buffering type as its
   second argument and the buffer pointer as the third, as on System V before
   release 3. */
/* #undef SETVBUF_REVERSED */

/* The size of a `char', as computed by sizeof. */
#define SIZEOF_CHAR 1

/* The size of a `int', as computed by sizeof. */
#define SIZEOF_INT 4

/* The size of a `long', as computed by sizeof. */
#define SIZEOF_LONG 4

/* The size of a `long long', as computed by sizeof. */
#define SIZEOF_LONG_LONG 8

/* The number of bytes in an off_t */
#define SIZEOF_OFF_T 8

/* The size of a `short', as computed by sizeof. */
#define SIZEOF_SHORT 2

/* The number of bytes in a size_t */
#define SIZEOF_SIZE_T 4

/* The size of a `void *', as computed by sizeof. */
#define SIZEOF_VOID_P 4

/* Obscure SYSV feature */
/* #undef SOCKOPT_CONNECT_STAT */

/* Define to 1 if you have the ANSI C header files. */
#define STDC_HEADERS 1

/* define if the variable sys_errlist is declared in a system header file */
#define SYS_ERRLIST_DECLARED 

/* Define to 1 if you can safely include both <sys/time.h> and <time.h>. */
#define TIME_WITH_SYS_TIME 1

/* Define to 1 if your <sys/time.h> declares `struct tm'. */
/* #undef TM_IN_SYS_TIME */

/* Define if you have matherr() function and struct exception type */
#define USE_MATHERR 1

/* Define to enable hrvtime() on Linux systems with perfctr extension */
/* #undef USE_PERFCTR */

/* Define if malloc should use a recursive mutex */
#define USE_RECURSIVE_MALLOC_MUTEX 1

/* Define if select() should be used instead of poll() */
/* #undef USE_SELECT */

/* Define if windows.h includes winsock2.h */
/* #undef WINDOWS_H_INCLUDES_WINSOCK2_H */

/* Define to 1 if your processor stores words with the most significant byte
   first (like Motorola and SPARC, unlike Intel and VAX). */
/* #undef WORDS_BIGENDIAN */

/* Define like PROTOTYPES; this can be used by system headers. */
#define __PROTOTYPES 1

/* Define to empty if `const' does not conform to ANSI C. */
/* #undef const */

/* Define to `long' if <sys/types.h> does not define. */
/* #undef off_t */

/* Define to `int' if <sys/types.h> does not define. */
/* #undef pid_t */

/* Define to `unsigned' if <sys/types.h> does not define. */
/* #undef size_t */

/* Define as `fork' if `vfork' does not work. */
/* #undef vfork */


/* Redefine in6_addr. XXX this should be moved to the files where it's used? */
#ifdef HAVE_IN_ADDR6_STRUCT
#define in6_addr in_addr6
#endif

/* Define a reasonable default for INADDR_LOOPBACK */
/* XXX this should be moved to the files where it's used? */
#ifdef HAVE_NO_INADDR_LOOPBACK
#define INADDR_LOOPBACK (u_long)0x7F000001
#endif

#ifdef REDEFINE_FD_SETSIZE
#define FD_SETSIZE 1024
#endif

#ifdef HAVE_GETHRVTIME_PROCFS_IOCTL
#define HAVE_GETHRVTIME
#endif

#ifndef HAVE_FINITE
# if defined(HAVE_ISINF) && defined(HAVE_ISNAN)
#  define USE_ISINF_ISNAN
# endif
#endif

#if defined(DEBUG) && defined(USE_THREADS) && !defined(ERTS_ENABLE_LOCK_CHECK)
#define ERTS_ENABLE_LOCK_CHECK 1
#endif
