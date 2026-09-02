#include <algorithm>
#include <cctype>
#include <charconv>
#include <cstdio>
#include <cstdlib>
#include <filesystem>
#include <fstream>
#include <iostream>
#include <optional>
#include <random>
#include <string_view>
#include <vector>

#include <poll.h>
#include <sys/signalfd.h>
#include <sys/timerfd.h>
#include <sys/wait.h>
#include <unistd.h>

namespace fs = std::filesystem;

using std::string;

struct State {
  fs::path wallpaper_dir{"~/Immagini/Wallpapers"};
  fs::path symlink_path{"/tmp/current_wallpaper"};
  int interval = 300;
  fs::path current_wallpaper;
  bool paused = false;
  bool reset_timer = false;
};

State state;

std::random_device rd;
std::mt19937 rng(rd());

fs::path expand(const fs::path &path) {
  const string str = path.string();
  const char *home = std::getenv("HOME");

  if (!home)
    return path;

  if (str == "~")
    return fs::path(home);

  if (str.starts_with("~/"))
    return fs::path(home) / str.substr(2);

  return path;
}

bool is_image(const fs::path &path) {
  static constexpr std::string_view extensions[] = {".png", ".jpg",  ".jpeg",
                                                    ".gif", ".webp", ".bmp"};

  string ext = path.extension().string();

  std::transform(ext.begin(), ext.end(), ext.begin(), [](unsigned char c) {
    return static_cast<char>(std::tolower(c));
  });

  for (auto valid : extensions) {
    if (ext == valid)
      return true;
  }

  return false;
}

std::vector<fs::path> get_all_images(const fs::path &directory) {
  std::vector<fs::path> images;

  std::error_code ec;

  if (!fs::exists(directory, ec) || !fs::is_directory(directory, ec))
    return images;

  fs::recursive_directory_iterator it(
      directory, fs::directory_options::skip_permission_denied, ec);

  fs::recursive_directory_iterator end;

  for (; it != end; it.increment(ec)) {
    if (ec) {
      ec.clear();
      continue;
    }

    std::error_code file_ec;

    if (!it->is_regular_file(file_ec))
      continue;

    if (is_image(it->path()))
      images.push_back(it->path());
  }

  return images;
}

std::optional<int> parse_int(std::string_view str) {
  int value = 0;

  const auto [ptr, ec] =
      std::from_chars(str.data(), str.data() + str.size(), value);

  if (ec != std::errc{} || ptr != str.data() + str.size()) {
    return std::nullopt;
  }

  return value;
}

void set_wallpaper(const fs::path &path) {
  std::error_code ec;

  if (!fs::exists(path, ec) || !fs::is_regular_file(path, ec))
    return;

  pid_t pid = fork();

  if (pid == 0) {
    execlp("awww", "awww", "img", "-a", "-t", "random", path.c_str(),
           static_cast<char *>(nullptr));

    _exit(127);
  }

  if (pid < 0) {
    std::cerr << "failed to fork\n";
    return;
  }

  int status = 0;
  waitpid(pid, &status, 0);

  if (!WIFEXITED(status) || WEXITSTATUS(status) != 0) {
    std::cerr << "awww failed for: " << path << '\n';
    return;
  }

  if (fs::is_symlink(state.symlink_path, ec) ||
      fs::exists(state.symlink_path, ec)) {

    ec.clear();
    fs::remove(state.symlink_path, ec);

    if (ec) {
      std::cerr << "failed to remove old symlink: " << ec.message() << '\n';
    }
  }

  ec.clear();

  fs::create_symlink(fs::absolute(path), state.symlink_path, ec);

  if (ec) {
    std::cerr << "failed to create symlink: " << ec.message() << '\n';
  }

  state.current_wallpaper = path;
}

void load_next() {
  auto images = get_all_images(state.wallpaper_dir);

  if (images.empty()) {
    std::cerr << "no wallpapers found in " << state.wallpaper_dir << '\n';
    return;
  }

  if (images.size() > 1) {
    std::erase(images, state.current_wallpaper);
  }

  if (images.empty())
    return;

  std::uniform_int_distribution<std::size_t> distribution(0, images.size() - 1);

  set_wallpaper(images[distribution(rng)]);
}

std::vector<string> read_all_lines(const fs::path &path) {
  std::ifstream file(path);

  std::vector<string> lines;
  string line;

  while (std::getline(file, line))
    lines.push_back(std::move(line));

  return lines;
}

void reload_config() {
  const fs::path config_file = "/tmp/awww_manager_ipc";

  if (!fs::exists(config_file))
    return;

  const auto lines = read_all_lines(config_file);

  for (const auto &line : lines) {
    if (line.starts_with("DIR:")) {
      state.wallpaper_dir = expand(line.substr(4));
    } else if (line.starts_with("INT:")) {
      auto interval = parse_int(line.substr(4));

      if (interval && *interval > 0)
        state.interval = *interval;

    } else if (line.starts_with("IMG:")) {
      fs::path path = expand(line.substr(4));
      std::error_code ec;
      path = fs::canonical(path, ec);

      if (ec) {
        std::cerr << "invalid image path: " << ec.message() << '\n';
        continue;
      }
      set_wallpaper(path);
    }
  }

  state.reset_timer = true;
}

void reset_timer(int fd) {
  itimerspec timer{};
  timer.it_value.tv_sec = state.interval;
  timer.it_interval.tv_sec = state.interval;
  if (timerfd_settime(fd, 0, &timer, nullptr) == -1)
    perror("timerfd_settime");
}

void disable_timer(int fd) {
  itimerspec timer{};
  timerfd_settime(fd, 0, &timer, nullptr);
}

int main() {
  {
    std::ofstream pid_file("/tmp/awww_manager.pid");

    if (!pid_file) {
      std::cerr << "failed to create PID file\n";
      return 1;
    }

    pid_file << getpid() << '\n';
  }

  state.wallpaper_dir = expand(state.wallpaper_dir);

  sigset_t mask;
  sigemptyset(&mask);
  sigaddset(&mask, SIGUSR1);
  sigaddset(&mask, SIGUSR2);
  sigaddset(&mask, SIGHUP);
  sigprocmask(SIG_BLOCK, &mask, nullptr);

  int signal_fd = signalfd(-1, &mask, SFD_CLOEXEC);
  int timer_fd = timerfd_create(CLOCK_MONOTONIC, TFD_CLOEXEC);

  reset_timer(timer_fd);

  pollfd fds[2];
  fds[0].fd = timer_fd;
  fds[0].events = POLLIN;

  fds[1].fd = signal_fd;
  fds[1].events = POLLIN;

  load_next();

  while (true) {
    int result = poll(fds, 2, -1);
    if (result == -1) {
      if (errno == EINTR)
        continue;
      perror("poll");
      break;
    }

    if (fds[0].revents & POLLIN) {
      uint64_t expirations;
      if (read(timer_fd, &expirations, sizeof(expirations)) !=
          sizeof(expirations)) {
        perror("read timerfd");
        continue;
      }

      if (!state.paused)
        load_next();
    }

    if (fds[1].revents & POLLIN) {
      signalfd_siginfo info{};
      if (read(signal_fd, &info, sizeof(info)) != sizeof(info)) {
        perror("read signalfd");
        continue;
      }

      switch (info.ssi_signo) {
      case SIGUSR1:
        load_next();
        reset_timer(timer_fd);
        break;

      case SIGUSR2:
        state.paused = !state.paused;
        if (state.paused)
          disable_timer(timer_fd);
        else
          reset_timer(timer_fd);

        break;

      case SIGHUP:
        reload_config();
        reset_timer(timer_fd);
        break;
      }
    }
  }

  close(timer_fd);
  close(signal_fd);
}
