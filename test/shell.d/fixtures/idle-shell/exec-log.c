// Preloaded into the shell under test and inherited by everything it starts,
// so every program any descendant runs is logged, however briefly it lives.
// Sampling the process tree instead misses the short-lived probes polling
// spawns. One line per exec: the pid that runs the program and its parent's,
// then argv joined by spaces. A fork logs the same line without a command, so
// a reader can follow ancestry through a subshell that never execs.
//
// The exec family can run in a vfork child, which shares the parent's memory,
// so the logging path allocates nothing and takes no locks: raw syscalls from
// a stack buffer. The real functions are resolved once, at load.
#define _GNU_SOURCE
#include <dlfcn.h>
#include <fcntl.h>
#include <spawn.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

typedef int (*execve_fn)(const char *, char *const[], char *const[]);
typedef int (*execv_fn)(const char *, char *const[]);
typedef int (*fexecve_fn)(int, char *const[], char *const[]);
typedef pid_t (*fork_fn)(void);
typedef int (*spawn_fn)(pid_t *, const char *, const posix_spawn_file_actions_t *,
                        const posix_spawnattr_t *, char *const[], char *const[]);

static execve_fn real_execve;
static execv_fn real_execv;
static execv_fn real_execvp;
static execve_fn real_execvpe;
static fexecve_fn real_fexecve;
static spawn_fn real_posix_spawn;
static spawn_fn real_posix_spawnp;
static fork_fn real_fork;
static char log_path[4096];

__attribute__((constructor)) static void init(void) {
  real_execve = (execve_fn)dlsym(RTLD_NEXT, "execve");
  real_execv = (execv_fn)dlsym(RTLD_NEXT, "execv");
  real_execvp = (execv_fn)dlsym(RTLD_NEXT, "execvp");
  real_execvpe = (execve_fn)dlsym(RTLD_NEXT, "execvpe");
  real_fexecve = (fexecve_fn)dlsym(RTLD_NEXT, "fexecve");
  real_posix_spawn = (spawn_fn)dlsym(RTLD_NEXT, "posix_spawn");
  real_posix_spawnp = (spawn_fn)dlsym(RTLD_NEXT, "posix_spawnp");
  real_fork = (fork_fn)dlsym(RTLD_NEXT, "fork");

  const char *path = getenv("OMARCHY_EXEC_LOG");
  if (path && strlen(path) < sizeof(log_path)) strcpy(log_path, path);
}

static size_t put_number(char *buf, size_t at, size_t cap, long value) {
  char digits[24];
  int count = 0;

  do {
    digits[count++] = (char)('0' + value % 10);
    value /= 10;
  } while (value > 0 && count < (int)sizeof(digits));
  while (count > 0 && at < cap) buf[at++] = digits[--count];
  return at;
}

static void record_as(pid_t pid, pid_t parent, char *const argv[]) {
  if (!log_path[0]) return;

  char line[8192];
  size_t cap = sizeof(line) - 1, at = 0;

  at = put_number(line, at, cap, (long)pid);
  if (at < cap) line[at++] = ' ';
  at = put_number(line, at, cap, (long)parent);
  for (int i = 0; argv && argv[i]; i++) {
    if (at < cap) line[at++] = ' ';
    for (const char *c = argv[i]; *c && at < cap; c++) line[at++] = *c == '\n' ? ' ' : *c;
  }
  line[at++] = '\n';

  int fd = open(log_path, O_WRONLY | O_APPEND | O_CREAT | O_CLOEXEC, 0600);
  if (fd < 0) return;
  ssize_t written = write(fd, line, at);
  (void)written;
  close(fd);
}

static void record(char *const argv[]) {
  record_as(getpid(), getppid(), argv);
}

int execve(const char *path, char *const argv[], char *const envp[]) {
  record(argv);
  return real_execve(path, argv, envp);
}

int execv(const char *path, char *const argv[]) {
  record(argv);
  return real_execv(path, argv);
}

int execvp(const char *file, char *const argv[]) {
  record(argv);
  return real_execvp(file, argv);
}

int execvpe(const char *file, char *const argv[], char *const envp[]) {
  record(argv);
  return real_execvpe(file, argv, envp);
}

int fexecve(int fd, char *const argv[], char *const envp[]) {
  record(argv);
  return real_fexecve(fd, argv, envp);
}

pid_t fork(void) {
  pid_t pid = real_fork();
  if (pid == 0) record(NULL);
  return pid;
}

// The spawned child runs its program from inside libc, past these wrappers, so
// it is logged from the parent, under the child's pid, once it exists.
int posix_spawn(pid_t *pid, const char *path, const posix_spawn_file_actions_t *actions,
                const posix_spawnattr_t *attr, char *const argv[], char *const envp[]) {
  pid_t child = 0;
  int status = real_posix_spawn(&child, path, actions, attr, argv, envp);
  if (status == 0) record_as(child, getpid(), argv);
  if (pid) *pid = child;
  return status;
}

int posix_spawnp(pid_t *pid, const char *file, const posix_spawn_file_actions_t *actions,
                 const posix_spawnattr_t *attr, char *const argv[], char *const envp[]) {
  pid_t child = 0;
  int status = real_posix_spawnp(&child, file, actions, attr, argv, envp);
  if (status == 0) record_as(child, getpid(), argv);
  if (pid) *pid = child;
  return status;
}
