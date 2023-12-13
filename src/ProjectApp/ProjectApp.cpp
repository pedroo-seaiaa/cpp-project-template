/// ##########################################################################
/// @copyright Copyright (c) 2023, AI & ARTS Alchemy. All rights reserved.
/// ##########################################################################
#include "Project/ProjectLib.hpp"

int main(const int argc, char const* const* const argv) {

#ifdef NO_HEAP_ALLOCATIONS
  std::array<std::string_view, 255> args;

  std::size_t arg_count = std::min(args.size(), static_cast<std::size_t>(argc));

  for (std::size_t arg = 0; arg < arg_count; ++arg) {
    args[arg] = std::string_view(*std::next(argv, static_cast<std::ptrdiff_t>(arg)));
  }
#else
  std::vector<std::string_view> args(argv, std::next(argv, static_cast<std::ptrdiff_t>(argc)));
#endif

  return project::lib::better_main(args);
}
